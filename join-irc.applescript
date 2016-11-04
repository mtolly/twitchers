#!/usr/bin/osascript
on run argv
  tell application "Colloquy"
    repeat while connections is {}
      delay 0.5
    end repeat
    tell first connection
      join chat room "#" & item 1 of argv
    end tell
  end tell
end run
