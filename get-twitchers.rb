#!/usr/bin/env ruby

require 'twitch-api'
require 'json'

ACCESS_TOKEN = '' # fill this in
USER_ID = 0 # fill this in

begin
  twitch = Twitch::Client.new(access_token: ACCESS_TOKEN)

  # first get all the followed streams
  follow_chunks = []
  page = nil
  while true
    streams = twitch.get_users_follows(from_id: USER_ID, first: 100, after: page)
    ids = streams.data.map(&:to_id)
    unless ids.empty?
      follow_chunks << ids
    end
    if streams.pagination && !(streams.data.empty?)
      page = streams.pagination['cursor']
    else
      break
    end
  end

  # then get stream info, which filters to only live ones
  streams = []
  follow_chunks.each do |chunk|
    streams = streams + twitch.get_streams(user_id: chunk, first: 100).data.map do |stream|
      {channel: {
        display_name: stream.user_name,
        status: stream.title,
        url: "https://twitch.tv/#{stream.user_name}" # TODO get real url, non-ascii chars will probably break this
      }}
    end
  end

  o = {streams: streams}
rescue Exception => e
  o = {error: e.to_s}
end
puts o.to_json
