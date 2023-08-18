---
title: "Configuration Options"
id: "configuration-options"
layout: documentation
toc: true
---

## General Configuration Options

These settings determine basic behaviour of the application. Make sure that in
case the value for `MAX_PACKAGE_SIZE_BYTES` is either zero or a relatively big
number, make sure any proxies in front of the Cache service are able to handle
big payloads as well.

| Variable Name             | Description                          |
|---------------------------|--------------------------------------|
| `BIND_ADDRESS`            | The address the server will listen for requests. Defaults to `0.0.0.0:5000` |
| `MAX_PACKAGE_SIZE_BYTES`  | The maximum size, in bytes, that a single artifact may have. Payloads whose size is larger than the one defined are automatically rejected by the server and are not stored. A zero value indicates no maximum size. Defaults to `0` |


## Redis Configuration

Redis Configuration connects Cache instances to the primary Redis instance used
by the platform. The Cache service requires it to handle asynchronous requests
from the API.

| Variable Name             | Description                          |
|---------------------------|--------------------------------------|
| `REDIS_URL`               | The URL for the Primary Redis Database used by the platform. This value must be the same as provided to `COCOV_REDIS_URL` on {% doclink "API/Configuration Options", title: "API's Configuration Options" %}. |

## Storage Configuration

Storage Configuration configures where the Cache service keeps artifacts and
tools. Although those options look like the same as the Git storage options from
the {% doclink "API/Configuration Options", title: "API" %} and
{% doclink "Worker/Configuration Options", title: "Worker" %}, this storage has
no relation to those services and must be placed in another volume/bucket.

| Variable Name              | Description                          |
|----------------------------|--------------------------------------|
| `CACHE_STORAGE_MODE`       | Which storage mode to use. Must be either `local` or `s3`. |

Then, depending on the chosen mode, one of the following extra variables must
also be defined:

### Local Storage Mode

The Local Storage mode stores cache data in a local directory.
Although the path must exist locally, it may point to an NFS share, for instance.

| Variable Name                          | Description                          |
|----------------------------------------|--------------------------------------|
| `CACHE_LOCAL_STORAGE_PATH`             | The local path to use to store cache data |

### S3 Storage Mode

The S3 storage mode stores shared data within a S3 bucket, and only takes the
target bucket name. All other configuration options are processed by the AWS
SDK. Refer to its documentation for further information.

| Variable Name                              | Description                          |
|--------------------------------------------|--------------------------------------|
| `CACHE_S3_BUCKET_NAME` | The bucket name to be used to store cache data |

## API Connection Configuration

Just like other services, Cache requires both the internal API URL and a service
token to authenticate requests made to it.

| Variable Name             | Description                          |
|---------------------------|--------------------------------------|
| `API_URL`                 | Base URL to the system's API. Can be an internal URL, if desired. Format is `http[s]://api_hostname[:port]` |
| `API_TOKEN`               | A {% doclink "Service Tokens", title: "Service Token" %} created by the API to allow the Worker connections. |
