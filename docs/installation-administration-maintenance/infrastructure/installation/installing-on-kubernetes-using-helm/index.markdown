---
title: "Installing on Kubernetes using Helm"
id: "installing-on-kubernetes-using-helm"
layout: documentation
---

This section aims to provide a walkthrough of setting up a Cocov instance on an
Kubernetes cluster by leveraging [Cocov's Helm Chart](https://github.com/cocov-ci/helm).

It is assumed you understand Kubernetes concepts, Helm, have a live cluster,
understands {% doclink "Requirements", title: "Cocov's requirements" %} and
have prepared required dependencies (PostgreSQL, Redis, Storage, DNS, etc).
Before continuing, one may also want to get familiarised with Cocov Chart's
values, and the documentation present there. Take a couple of minutes to check
the `values.yaml` file in the aforementioned chart.

It is important to notice that the contains common structures for all components
to allow replicas, sources, annotations, and the horizontal pod autoscaler to be
enabled. The following keys are common to all components:

- `replicaCount`
- `hpa`
    - `enabled`
    - `labels`
    - `minReplicas`
    - `maxReplicas`
    - `targetCPUUtilizationPercentage`
    - `targetMemoryUtilizationPercentage`
    - `metrics`
- `resources`
- `nodeSelector`
- `tolerations`
- `affinity`
- `podAnnotations`
- `podSecurityContext`
- `securityContext`
- `labels`

Also, an extra subobject of the chart allows common data to be defined for all
components. Keys defined on the `general` object will be merged into all objects
unless the object itself overrides it. The following keys may be set to the
`general` object of the chart:

- `nodeSelector`
- `tolerations`
- `affinity`
- `podAnnotations`
- `podSecurityContext`
- `securityContext`
- `labels`
- `revisionHistoryLimit`
- `imagePullPolicy`

## On this Section

- {% doclink "Choosing a Storage Medium" %}
- {% doclink "Initializing the API and Web UI" %}
- {% doclink "Initializing the Worker instance" %}
- {% doclink "Enabling the Badger" %}
- {% doclink "Enabling Worker Cache" %}
