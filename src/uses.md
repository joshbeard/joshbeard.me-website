---
title: What I Use
meta_title: What I Use
description: My uses page lists hardware, software, and other stuff I use
keywords: ['uses','uses.tech']
layout: page
permalink: /uses/
class: ascii-art
---
## What I Use

{% include submenu.html %}

This is my [uses page](https://uses.tech/).

It nags at my security conscience to publish information about software and
equipment I use but in the spirit of community and tradition, here it is.

### Computers

* __Primary:__ MacBook Pro (2015) 13" Retina i7 3.1GHz/16GB. Runs Linux
  full-time. Rarely boot macOS for [LogicPro](https://www.apple.com/logic-pro/).
* __Work Provided:__ MacBook Pro M1 (work)/macOS.
* __Keyboards:__ 2x [NuPhy Air75](https://nuphy.com/products/air75) since
  February 2024. Previous [Logitech MX Keys Mechanical](https://www.logitech.com/en-us/products/keyboards/mx-mechanical.html).
* __Mouse:__ Logitech MX Master 3
* __Monitors:__ Phillips 32" 4k UHD curved, 2x Viewsonic 22" IPS 1080p, 2x
  Viewsonic 24" IPS 1080p.

Checkout my [Old Computers page](/old-computers.html) for previous computers
I've had since the 1990s.

### Desktop

```ascii-art-right
       __________________
      /\  ______________ \
     /::\ \ZZZZZZZZZZZZ/\ \
    /:/\.\ \        /:/\:\ \
   /:/Z/\:\ \      /:/Z/\:\ \
  /:/Z/__\:\ \____/:/Z/  \:\ \
 /:/Z/____\:\ \___\/Z/    \:\ \
 \:\ \ZZZZZ\:\ \ZZ/\ \     \:\ \
  \:\ \     \:\ \ \:\ \     \:\ \
   \:\ \     \:\ \_\;\_\_____\;\ \
    \:\ \     \:\_________________\
     \:\ \    /:/ZZZZZZZZZZZZZZZZZ/
      \:\ \  /:/Z/    \:\ \  /:/Z/
       \:\ \/:/Z/      \:\ \/:/Z/
        \:\/:/Z/________\;\/:/Z/
         \::/Z/_______itz__\/Z/
          \/ZZZZZZZZZZZZZZZZZ/
```

* __OS:__ [Arch Linux](https://archlinux.org/), btw
* __WM:__ [Hyprland](https://hyprland.org/). Previously used i3
* __Launcher:__ [rofi](https://github.com/davatorium/rofi)
* __Status:__ [Waybar](https://github.com/Alexays/Waybar)
* __Launcher:__ [fzf](https://www.logitech.com/en-us/products/keyboards/mx-mechanical.html)
* __Terminal:__ [Alacritty](https://alacritty.org/) with [tmux](https://github.com/tmux/tmux)
* __Editor:__ [neovim](https://neovim.io/). VIM user since 2001
* __Fonts:__ [Hack monospace font](https://sourcefoundry.org/hack/)
* __Shell:__ zsh with [prezto](https://github.com/sorin-ionescu/prezto)
* __Browsers:__ [Brave](https://brave.com) and [Firefox](https://www.mozilla.org/en-US/firefox/new/)
* __Browser Plugins:__ [Vimium-C](https://www.logitech.com/en-us/products/keyboards/mx-mechanical.html),
  [Dark Reader](https://darkreader.org/).
* __Notes:__ [Obsidian](https://obsidian.md/)
* __Mail:__ [Mutt](https://mutt.org) and [NeoMutt](http://www.neomutt.org/)
* __Music:__ [spotify](https://open.spotify.com/user/hewbert007?si=52f6e599773a4cab) and [last.fm](https://www.last.fm/user/joshbeard)

See my [dotfiles](https://github.com/joshbeard/dotfiles)

### Development and Work

* __Languages:__ Go, Python, Shell
* __Cloud:__ AWS, DigitalOcean
* __CfgMgmt/IaC:__ Ansible, Terraform
* __Git/CI/CD:__ GitLab and GitHub
* __Diagrams:__ [draw.io](https://draw.io/)
* __Web Fonts:__ [google-webfonts-helper](https://colorslurp.com/) for downloading and serving Google web fonts locally
* __Mail Provider:__ [Migadu](https://www.migadu.com/) is outstanding

### Homelab

See my [Home Lab](/homelab) page for more information.

### Keyboard-Driven Workflow

I started using VIM and learning its keybindings over 20 years ago and it has
been an invaluable part of my workflow ever since.

I've made my workflow as keyboard-driven as possible, at least on Linux.
This has made for a very fast and efficient workflow. I've been using tiling
window managers for a long time, which works well in this regard.

A few things to highlight that lend to keyboard-driven efficiency:

* VIM-like keybindings where I can
* Window manager with good keybindings and programmability (Hyprland)
* Terminal multiplexer (tmux)
* Fuzzy finder (fzf) and fuzzy finding in general
* Launcher (rofi)
* Editor (neovim)
* Shell with predictive typing (zsh)

For my most common tasks, I can press a quick keystroke to pop up a menu to
launch applications, open a dedicated tmux session for a project, switch and
move around workspaces, etc.

* Launching apps: I press `CMD+Space` to open rofi, type a few letters of the
  app, and press `Enter` to launch.
* tmux sessions for projects: `CMD+Shift+Space` launches [`tmux-sessionizer`](https://github.com/joshbeard/dotfiles/blob/master/home/bin/tmux-sessionizer.sh),
  a script adapted from [ThePrimeagen](https://www.youtube.com/c/ThePrimeagen)
  that uses [`fzf`](https://github.com/junegunn/fzf) to select a project and
  either create a new tmux session or attach to an existing one. From there,
  I launch my editor and/or other shells within that project. I can also press
  `Ctrl-A Space` within tmux itself to switch between sessions.
* Within NeoVim, I'm using [Telescope](https://github.com/nvim-telescope/telescope.nvim)
  for fuzzy finding files, buffers, and grepping.
* In the browser, I'm using [Vimium-C](https://www.logitech.com/en-us/products/keyboards/mx-mechanical.html)
  for keyboard-driven navigation (as much as a browser can be).
* I run [`neomutt`](http://www.neomutt.org/) in a tmux session as well, which
  uses [1password](https://1password.com/)'s CLI to retrieve passwords for the
  session. This has a dedicated workspace with a quick `CMD+M` to switch to it,
  either launching it or attaching to an existing session. This also has an
  icon in my Waybar status bar to show unread mail count.

My workflow's not as smooth on macOS, which I've been stuck with at work over
the years. At least it's not Windows, but I'm adaptable when it comes to
getting paid.
