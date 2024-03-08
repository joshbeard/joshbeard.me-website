---
title: My Home Lab
meta_title: My Home Lab
description: Information about my Home Lab servers
layout: page
permalink: /homelab/
class: ascii-art
keywords: ['homelab', 'home lab', 'homelabs', 'proxmox', 'home server']
---
## My Home Lab

{% include submenu.html %}

I'm working on publishing the codebase for my Home Lab to my
[GitHub profile](https://github.com/joshbeard?tab=repositories&q=homelab&type=&language=&sort=).
Eventually, I hope to provide some more content and code about my Homelab.

__2024 Update:__ I'm lagging behind on this, but still maintaining my Home Lab
internally with the same basic tools. It's a fairly well-oiled machine at this
point. I'm planning a storage upgrade soon.

My current home server is a Dell PowerEdge T410, bought off eBay for $250 a few
years ago. I'm running [Proxmox](https://www.proxmox.com/en/) on it with
several virtual machines and [LXC](https://en.wikipedia.org/wiki/LXC) containers.

Some services I run are [Pi-Hole](https://pi-hole.net/), [Plex Media Server](https://www.plex.tv/),
[Transmission BitTorrent](https://transmissionbt.com/),
[GitLab](https://about.gitlab.com/),
[Nginx](https://nginx.org/),
[Docker Swarm](https://docs.docker.com/engine/swarm/),
and some other odds and ends.

I manage it all with code, mostly Ansible and Terraform, with automated image
templates and GitLab CI/CD.

I host my Gemini, Gopher, and Finger services on it in containers. See my
[Small Internet](/site/small.html) page for more information.
