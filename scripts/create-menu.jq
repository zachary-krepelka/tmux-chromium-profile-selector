#!/usr/bin/env -S jq --arg executable google-chrome-stable -rf

# FILENAME: create-menu.jq
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, September 3rd, 2025
# ORIGIN: https://github.com/zachary-krepelka/tmux-chromium-profile-selector.git
# USAGE: jq --arg executable /path/to/browser -rf create-menu.jq /path/to/localstate | tmux source -

.profile.info_cache |
	to_entries |
	map({
		"id": "\(.key)",
		"username": "\(.value.shortcut_name)"
	}) |
	. as $profiles |
		($profiles | length) as $how_many |
	if $how_many > 1
	then
		# We reduce the json data into a command of the form

			# display-menu [-T title] name key command ...

		# Our inital value is the head of the command.
		# Our accumulator expression incorporates
		# a name, key, and cmd for each data point.

		reduce range(0; $how_many) as $i
		(
			"display-menu -T 'Browser Profiles' ";

			$profiles[$i] as $profile |
			. + (
					"'\($profile.username)'"                 as $name     |
					"\($i + 1)"                              as $key      |
					"--profile-directory=\"\($profile.id)\"" as $flag     |
					"\"\($executable)\" \($flag)"            as $sh_cmd   |
					"{ run-shell -b '\($sh_cmd)' }"          as $tmux_cmd |

					"\($name) \($key) \($tmux_cmd) "
			)
		) | .[:-1] # cut trailing whitespace
	else
		"run-shell -b '\"\($executable)\"'"
	end

# vim: tw=80 ts=4 sw=4 noet
