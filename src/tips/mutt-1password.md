---
title: Mutt with 1Password
meta_title: Mutt with 1Password
show_meta_title: false
description: Using Mutt and Neomutt with 1Password
keywords: ['mutt', 'neomutt', '1password', 'email', 'tmux']
layout: page
permalink: /tips/mutt-1password/
---
## Mutt with 1Password

Using [Mutt](https://mutt.org) or [Neomutt](https://neomutt.org) with 1Password
is pretty straightforward, but 1Password's CLI tool will prompt for the master
password each time you run mutt, which can be annoying unless you leave mutt
running all the time. I detail a solution I use with [tmux]() below.

Rather than store your passwords in plain text within the `muttrc` file, you
can use mutt's ability to execute shell commands to retrieve your passwords
from 1Password using the `op` command line tool.

### Prerequisites

* 1Password _and_ 1Password CLI
  * Make sure you have the `op` command line tool installed. On Arch Linux and in
    Homebrew, it's in the `1password-cli` package. On other systems, you can
    download it from the [1Password
    CLI](https://1password.com/downloads/command-line/) page.
* `jq`
* 1Password has to be running (it doesn't need to be unlocked)

### Configuration

In 1Password, you need to enable the CLI in the settings from the "Developer"
section.

<img src="/assets/img/1password-cli-setting.png" alt="Enable CLI" style="max-width: 100%;">

In your `muttrc` file, you can use the backticks to execute the `op` command.
For example:

```plain
set smtp_pass = `op item get "My Mail Login" --fields type=concealed --format json | jq -r '.value'`
```

You might also want to retrieve the username and SMTP server URL from
1Password.

For example:

```plain
set from = `op item get "My Mail Login" --fields username`
set smtp_url = `op item get "My Mail Login" --fields smtp_url`
```

In this example `smtp_url` is a custom field in the 1Password item.

### Keeping Mutt Running In The Background

1Password's CLI tool will prompt for the master password via the desktop app
each time you run mutt.

I use a [shell wrapper script](https://github.com/joshbeard/dotfiles/blob/master/home/bin/mutt.sh)
(that I named `mutt.sh`) that manages starting and attaching to a tmux session
with mutt running in it and signals the window manager to switch to the window
if it's already running or starts a new session if it's not.

With this, I can open and close mutt as I please - either
using a [keybinding](https://github.com/joshbeard/dotfiles/blob/master/home/.config/hypr/keybinds.conf),
clicking a status icon, or running it directly in the shell.

I take it a step further and have a dedicated workspace in my window manager
for mutt. When I press `CMD+m`, it switches to that workspace and runs the
`mutt.sh` script.

To avoid accidentally exiting mutt by pressing `q` on the index, I've made that
a `noop`:

```plain
bind index q noop
```

Instead, I just close the terminal so it stays running in the background. If I
truly want to exit mutt, I use `ctrl+c` or kill the tmux session.

The script generically supports Xorg via `wmctrl` and currently supports
Hyprland via `hyprctl`. It should be straightforward to adapt to other
compositors and window managers if they support similar functionality.

Feel free to [contact me](mailto:hello@joshbeard.me) if you have questions.
