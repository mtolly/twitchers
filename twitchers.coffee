getTwitchers = "INSERT: path to get-twitchers.rb"
joinIRC = "INSERT: path to join-irc.applescript"
livestreamer = "INSERT: path to livestreamer"
twitchAuth = "INSERT: your Twitch OAuth token"

# this is the shell command that gets executed every time this widget refreshes
command: getTwitchers

# the refresh frequency in milliseconds
refreshFrequency: 60000

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
render: (output) ->
  # streams.each do |s|
  #   puts [s['channel']['display_name'], s['channel']['status'], s['channel']['url']].inspect
  # end
  results = JSON.parse output
  if results.streams?
    if results.streams.length > 0
      window.openTwitch = (url) =>
        @run "#{livestreamer} --twitch-oauth-token #{twitchAuth} #{url} high,best", (=>)
      window.openIRC = (url) =>
        if md = url.match(/twitch.tv\/(.*)/)
          @run "#{joinIRC} #{md[1].toLowerCase()}", (=>)
      lines = for stream in results.streams
        name = stream.channel.display_name
        status = stream.channel.status
        url = stream.channel.url
        """
        <tr>
          <td>#{name}</td>
          <td><a href="#{url}" style="color: #f4a4c8;" class="button">View</a></td>
          <td><a href="#{url}/chat?popout=" style="color: #d3a4f4;" class="button">Chat</a></td>
          <td><span onClick="window.openTwitch('#{url}');" style="color: #f9ca6b;" class="button">VLC</span></td>
          <td><span onClick="window.openIRC('#{url}');" style="color: #aadd6b;" class="button">IRC</span></td>
        </tr>
        <tr class="status">
          <td colspan="5">#{status}</td>
        </tr>
        """
      "<table>#{lines.join('')}</table>"
    else
      "<p>No streams...</p>"
  else
    """
    <table>
      <tr>
        <td>Error</td>
      </tr>
      <tr>
        <td>
          <pre>#{results.error}</pre>
        </td>
      </tr>
    </table>
    """

# the CSS style for this widget, written using Stylus
# (http://learnboost.github.io/stylus/)
style: """
  background: rgba(50, 0, 75, 0.4)
  box-sizing: border-box
  font-family: Open Sans
  font-weight: bold
  font-size: 17px
  left: 82px
  top: 10px
  padding-left: 10px
  padding-right: 10px
  border-radius: 15px
  padding-top: 10px
  color: white
  a
    color: inherit
    text-decoration: inherit
  .button
    background-color: rgba(0,0,0,0.6)
    padding: 5px
    border-radius: 5px
  td
    padding-top: 3px
    padding-left: 3px
    padding-right: 3px
    padding-bottom: 0px
  .status
    height: 25px
  .status td
    padding-left: 15px
    padding-right: 3px
    padding-bottom: 10px
    font-size: 13px
    font-weight: normal
  pre
    max-width: 1000px
    white-space: pre-wrap
    font-family: Input Mono
    font-weight: normal
    background-color: rgba(200,200,200,0.2)
    padding: 10px
    border-radius: 15px;
"""
