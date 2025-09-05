# Tmux Chromium Profile Selector

<!--
	FILENAME: README.md
	AUTHOR: Zachary Krepelka
	DATE: Thursday, September 4th, 2025
	ORIGIN: https://github.com/zachary-krepelka/tmux-chromium-profile-selector.git
-->

A tmux plugin for launching a Chromium-based web browser under a targeted profile.

- [Introduction](#introduction)
- [Usage](#usage)
- [Installation](#installation)
- [Post-installation Setup](#post-installation-setup)

## Introduction

[Tmux][1] is an open-source terminal multiplexer for \*nix operating systems.
This repository is a plugin for tmux.  It targets the [Tmux Plugin Manager][2]
platform.  This plugin provides a way to launch a web browser under a targeted
profile from within tmux.  I presume a majority of individuals do not use more
than one profile in their web browsers.  This plugin is for the minority that
do.

The Chromium design documents define a web browser profile as "a bundle of data
about the current user and the current chrome session that can span multiple
browser windows."  In short, they are sandboxed environments that
compartmentalize data between users, storing bookmarks, history, extensions, and
settings on a user-by-user basis.

Web browser profiles are useful when

 - there are multiple users on a computer
 - one user wants to organize and separate their online activities

A third use case is realized for web developers.  The Chromium developer
documentation writes that

> By creating and using multiple profiles, you can do development--creating
> extensions, modifying the browser, or testing the browser--while still being
> able to use Google Chrome as your default browser.

This plugin is particularly relevant for web developers who work out of a
terminal, one running tmux.

## Usage

This plugin provides a single keybinding `prefix + P` that when invoked displays
a pop-up menu from which the user can select a web browser profile to open.
This menu is dynamically generated each time the keybinding is invoked, meaning
that if profiles are deleted or added, these changes will be reflected in the
menu the next time it is opened.

```text
┌─Browser Profiles─┐
│ Personal     (1) │
│ School       (2) │
│ Work         (3) │
└──────────────────┘
```

To be clear, this menu targets a *specific* web browser determined by a
configuration variable described later in this document.  This plugin likely
works with any Chromium-based web browser, but only one at a time.  If the user
only has one web browser profile, invoking `prefix + P` will simply launch the
specified browser without prompting.

## Installation

There are two installation methods.  Both presume that you have an active
internet connection.

### Automated installation

With the Tmux Plugin Manager installed, all you have to do is write the
following line to your `~/.tmux.conf` and subsequently press `prefix + I` from
within tmux.  This will handle the installation for you.

```tmux.conf
set -g @plugin 'zachary-krepelka/tmux-chromium-profile-selector'
```

### Manual installation

Clone this repo into a directory of your choice, say `~/.tmux/plugins/profile-chooser`.

```bash
git clone https://github.com/zachary-krepelka/tmux-chromium-profile-selector.git ~/.tmux/plugins/profile-chooser
```

Add this line to your `~/.tmux.conf`, changing the directory accordingly.

```tmux.conf
run-shell ~/.tmux/plugins/profile-chooser/chromium-profile-selector.tmux
```

Reload the tmux configuration file by typing `tmux source-file ~/.tmux.conf`.

## Post-installation Setup

There are some mandatory configuration tasks required after installation.  You
must set two options in your `~/.tmux.conf` in order for this plugin to function
properly.

```tmux.conf
set-option -g @chromium_exec "/path/to/executable"
set-option -g @chromium_data "/path/to/file"
```

Note that these values are read dynamically each time the keybinding is invoked,
meaning that you can reset them on the fly using tmux's command prompt without
having to re-source your `~/.tmux.conf`.

### Chromium Executable

The variable `@chromium_exec` should contain the absolute path of the executable
of a chromium-based web browser.  If the executable is on your path, you only
need to specify the name of the executable, e.g., `google-chrome-stable`.

### Chromium Data

The variable `@chromium_data` should contain the absolute path of the chosen web
browser's `Local State` file.  Local State is a JSON file found in
Chromium-based web browsers.  In the case of Google Chrome, it is typically
found in these locations.

| OS      | Path                                                      |
| ------- | --------------------------------------------------------- |
| Windows | `%LOCALAPPDATA%\Google\Chrome\User Data\Local State`      |
| macOS   | `~/Library/Application Support/Google/Chrome/Local State` |
| Linux   | `~/.config/google-chrome/Local State`                     |

### Example

To configure this plugin to use Microsoft Edge on Window's Subsystem for Linux:

```tmux.conf
set -g @chromium_exec '/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
set -g @chromium_data '/mnt/c/Users/<You>/AppData/Local/Microsoft/Edge/User Data/Local State'
```

<!-- References -->

[1]: https://en.wikipedia.org/wiki/Tmux
[2]: https://github.com/tmux-plugins/tpm
