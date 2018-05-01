# desktop screenshot and mv them to /tmp
on screen()
	tell application "System Events"
		key down command
		key down shift
		key down (key code 20)
		key up (key code 20)
		key up shift
		key up command
	end tell
end screen

screen()
delay 1
tell application "Finder"
	set i to every file of folder "Desktop" of home
	repeat with f in i
		set n to name of f
		if n starts with "Screen Shot" then
			do shell script "mv ~/Desktop/'" & n & "' /private/tmp"
		end if
	end repeat
end tell
