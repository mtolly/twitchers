#!/usr/local/bin/ruby

require 'twitch'
require 'json'

begin
  twitch = Twitch.new({
    client_id: 'INSERT: your Twitch app client id',
    secret_key: 'INSERT: your Twitch app secret key',
    redirect_uri: 'http://localhost:8888',
    scope: ['user_read', 'channel_read']
  })
  twitch = Twitch.new access_token: 'INSERT: your Twitch access token'
  streams = twitch.followed_streams[:body].parsed_response['streams']
  if streams.nil?
    raise Exception.new twitch.followed_streams[:body].parsed_response
  end
  o = {streams: streams}
rescue Exception => e
  o = {error: e.to_s}
end
puts o.to_json
