---
title: "Service Tokens"
id: "service-tokens"
layout: documentation
---

Service Tokens allows other systems to integrate with your instance by
leveraging access to the instance's API. For instance, Service Tokens are widely
used to authenticate access from other Cocov mechanisms such as the Badger,
Cache, and even Workers.

![Adminland Service Tokens](/assets/images/docs/adminland-service-tokens.png){: .screenshot }

A Service Token is an opaque token that is tied to a description of what it will
be used for. Creating a token displays the token in clear, and once concealed,
its value cannot be regained, requiring it to be deleted and recreated in case
it is lost.

Those tokens have no expiration, and provides irrestrict access to all instance
data, as long as it is obtainable from the API. Store service tokens securely.

## Revoking Service Tokens

Service Tokens can be revoked at any time by an administrator through Adminland.
Once revoked, the token is immediately rendered unusable, and applications or
integrations using it will have any access denied.
