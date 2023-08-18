---
title: "Installation"
id: "installation"
layout: documentation
---

{% include beta-warning.html %}

Cocov's installation steps comprises:

1. Provisioning required databases and storage
2. Creating a GitHub App to allow users to be authenticated, commits to be clonned,
and events to be received
3. Deciding how to allow GitHub to POST to the events endpoint
4. Determining which optional components the instance will have
5. Choosing a deployment method

The next sections will provide guides on each of those activities. Do notice,
however, that specific guides on networking and other external services are out
of scope for this documentation.

### On This Section

- {% doclink "Requirements" %}
- {% doclink "Creating a GitHub App" %}
- {% doclink "Installing on Kubernetes using Helm" %}
- {% doclink "Starting an Instance Using Docker Compose" %}
