---
title: "Badger"
id: "badger"
layout: documentation
---

Badger is a small application responsible for creating badges with counters like
the ones commonly found on GitHub READMEs:

<table>
    <thead>
        <tr>
            <th>Coverage Badge</th>
            <th>Issues Counter Badge</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="90.34601" height="18" role="img" aria-label="coverage: 97%"><title>coverage: 97%</title><linearGradient id="s" x2="0" y2="100%"><stop offset="0" stop-color="#fff" stop-opacity=".7"/><stop offset=".1" stop-color="#aaa" stop-opacity=".1"/><stop offset=".9" stop-color="#000" stop-opacity=".3"/><stop offset="1" stop-color="#000" stop-opacity=".5"/></linearGradient><clipPath id="r"><rect fill="#fff" width="90.34601" height="18" rx="4"/></clipPath><g clip-path="url(#r)"><rect width="56.5525" height="18" fill="rgba(85,85,85,1)"/><rect x="56.5525" width="33.793503" height="18" fill="rgba(68,204,17,1)"/><rect fill="url(#s)" width="90.34601" height="18"/></g><g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" text-rendering="geometricPrecision" font-size="110"><text aria-hidden="true" fill="#010101" x="292.7625" y="140" fill-opacity=".3" transform="scale(.1)" textLength="465.52502">coverage</text><text fill="#fff" x="292.7625" y="130" transform="scale(.1)" textLength="465.52502">coverage</text><text aria-hidden="true" fill="#010101" x="724.4925" y="140" fill-opacity=".3" transform="scale(.1)" textLength="237.93501">97%</text><text fill="#fff" x="724.4925" y="130" transform="scale(.1)" textLength="237.93501">97%</text></g></svg></td>
            <td><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="59.311" height="18" role="img" aria-label="issues: 4"><title>issues: 4</title><linearGradient id="s" x2="0" y2="100%"><stop offset="0" stop-color="#fff" stop-opacity=".7"/><stop offset=".1" stop-color="#aaa" stop-opacity=".1"/><stop offset=".9" stop-color="#000" stop-opacity=".3"/><stop offset="1" stop-color="#000" stop-opacity=".5"/></linearGradient><clipPath id="r"><rect fill="#fff" width="59.311" height="18" rx="4"/></clipPath><g clip-path="url(#r)"><rect width="42.0695" height="18" fill="rgba(85,85,85,1)"/><rect x="42.0695" width="17.2415" height="18" fill="rgba(254,125,55,1)"/><rect fill="url(#s)" width="59.311" height="18"/></g><g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" text-rendering="geometricPrecision" font-size="110"><text aria-hidden="true" fill="#010101" x="220.3475" y="140" fill-opacity=".3" transform="scale(.1)" textLength="320.695">issues</text><text fill="#fff" x="220.3475" y="130" transform="scale(.1)" textLength="320.695">issues</text><text aria-hidden="true" fill="#010101" x="496.9025" y="140" fill-opacity=".3" transform="scale(.1)" textLength="72.415">4</text><text fill="#fff" x="496.9025" y="130" transform="scale(.1)" textLength="72.415">4</text></g></svg></td>
        </tr>
    </tbody>
</table>

This service is expected to be exposed to the internet. For instance, if users
attempt to embed this on a README hosted on GitHub, GitHub will attempt to proxy
it, meaning it won't be able to access it in case the service is behind a VPN,
firewall, or the likes.

Currently, Badger only allows badges to be created for a repository's default
branch, and exposes only two routes:

| Route                         | Description |
|-------------------------------|-------------|
| `/{repository-name}/coverage` | Returns an SVG image showing the coverage percentage for the repository's default branch |
| `/{repository-name}/issues`   | Returns an SVG image showing the amount of issues present in the repository's default branch |

## Configuration Options

Badger is as simple as the {% doclink "Web UI" %} component, requiring only the
API URL and a {% doclink "Service Tokens", title: "Service Token" %}:

| Variable Name                    | Description                          |
|----------------------------------|--------------------------------------|
| `COCOV_BADGER_BIND_ADDRESS`      | The address to bind the HTTP server to. Defaults to `127.0.0.1` |
| `COCOV_BADGER_BIND_PORT`         | The port to bing the HTTP server to. Defaults to `4000` |
| `COCOV_BADGER_API_URL`           | Base URL to the system's API. Can be an internal URL, if desired. Format is `http[s]://api_hostname[:port]` |
| `COCOV_BADGER_API_SERVICE_TOKEN` | A Service Token created by the API to allow Badger requests. |
