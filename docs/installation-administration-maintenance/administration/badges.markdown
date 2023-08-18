---
title: "Badges"
id: "badges"
layout: documentation
---

Badges are small images usually present in README files indicating compliance
or showing coverage levels of repositories. Cocov includes a badge server
capable of emitting information regarding coverage level and the amount of
issues present in a repository's default branch, and is widely available for
all users from the repository page:


![Repository Badges](/assets/images/docs/badges.png){: .screenshot }

Badges are available on instances that have the badge server configured and
exposed to the public internet.

## Why Exposing the Badges Server

GitHub proxies and caches images displayed in their domains, meaning that
your badge server must be publicly accessible. More information can be obtained
from GitHub engineering Blog on [Proxying User Images](https://github.blog/2014-01-28-proxying-user-images/)
and [Sidejack Prevention](https://github.blog/2010-11-13-sidejack-prevention-phase-3-ssl-proxied-assets/).
