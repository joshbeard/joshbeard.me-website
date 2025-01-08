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

* __Primary:__ MacBook Pro (2015) 13" Retina i7 3.1GHz/16GB. Runs Arch Linux.
* __Work Provided:__ MacBook Pro M1 - macOS.
* __Keyboards:__ [NuPhy Air75](https://nuphy.com/products/air75)
* __Mouse:__ Logitech MX Master 3
* __Monitors:__ Phillips 32" 4k UHD curved, 2x Viewsonic 22" IPS 1080p, 2x
  Viewsonic 24" IPS 1080p.

Checkout my [Old Computers page](/old-computers.html) for previous computers
I've had since the 1990s.

### Desktop

* __OS:__ [Arch Linux](https://archlinux.org/), btw
* __Desktop Environment:__ [Hyprland](https://hyprland.org/)
* __Launcher:__ [wofi](https://sr.ht/~scoopta/wofi/)
* __Status:__ [Waybar](https://github.com/Alexays/Waybar)
* __Launcher:__ [fzf](https://github.com/junegunn/fzf)
* __Terminal:__ [Ghostty](https://ghostty.org/) recently or [Alacritty](https://alacritty.org/) with [tmux](https://github.com/tmux/tmux)
* __Editor:__ [neovim](https://neovim.io/). VIM user since 2001
* __Fonts:__ [Hack monospace font](https://sourcefoundry.org/hack/)
* __Shell:__ zsh with [prezto](https://github.com/sorin-ionescu/prezto)
* __Browsers:__ [Brave](https://brave.com)
* __Browser Plugins:__ [Vimium](https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb)
  [Dark Reader](https://darkreader.org/).
* __Notes:__ [Obsidian](https://obsidian.md/) + nvim
* __Mail:__ [NeoMutt](http://www.neomutt.org/)
* __Music:__ [spotify](https://open.spotify.com/user/hewbert007?si=52f6e599773a4cab) and [last.fm](https://www.last.fm/user/joshbeard)
* __Wallpapers:__ [walsh](https://github.com/joshbeard/walsh) is my own little wrapper tool for managing wallpapers

See my [dotfiles](https://github.com/joshbeard/dotfiles)

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

I've mainly been using subscriptions to GitHub Copilot, ChatGPT, and Claude.ai
for AI/LLM assistance.

### Homelab

See my [Home Lab](/homelab) page for more information.

### Keyboard-Driven Workflow and Fuzzy Finding

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
* In the browser, I'm using [Vimium](https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb)
  for keyboard-driven navigation (as much as a browser can be).
* I run [`neomutt`](http://www.neomutt.org/) in a tmux session as well, which
  uses [1password](https://1password.com/)'s CLI to retrieve passwords for the
  session. This has a dedicated workspace with a quick `CMD+M` to switch to it,
  either launching it or attaching to an existing session. This also has an
  icon in my Waybar status bar to show unread mail count.

My workflow's not as smooth on macOS, particularly corporate-provided
workstations.
