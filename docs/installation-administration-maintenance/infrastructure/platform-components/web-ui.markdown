---
title: "Web UI"
id: "web-ui"
layout: documentation
---

The Web UI is a [Next.js](https://nextjs.org) [React](https://react.dev)
application that allows users and administrators to use Cocov. The application
itself leverage Cocov's API endpoints to interface with the system's API, and
it simply authenticates as a known user, using their token to perform actions
on their behalf. The only configuration it requires is its own base URL, and the
internal URL to the system's API. The UI does not require the API to be exposed,
as it transparently proxies all requests internally.

## Configuration Parameters

| Variable Name   | Description                          |
|-----------------|--------------------------------------|
| `COCOV_API_URL` | The base URL to the internal API. Must be in the format `http[s]://host[:port]` |
| `COCOV_UI_URL`  | The complete base URL the users use to access Cocov. The URL may be hosted behind a VPN, but must be accessible to your users; the same URL is used to generate URLs used to direct users to internal pages, and/or generate redirect URLs provided to other services. Format is `http[s]://domain.for.cocov` |
