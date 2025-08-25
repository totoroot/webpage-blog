---
title: "Container Images - What is latest pointing to?"
date: 2024-11-19T10:16:57+01:00
draft: false
categories: "TIL"
tags: [
    "Kubernetes",
    "K8s",
    "kubectl",
    "Containerisation",
    "Containers",
    "Images",
    "Digest"
]
slug: "k8s-image-digest"
---

# Container Images - What is latest pointing to?

Sometimes you might have a Kubernetes deployment set to the "latest" tag of a container image.

Whether all pods are already using the image, that "latest" is now pointing to, depends on which `RestartPolicy` you have set.

To actually view the image digest of the container run the following:

```sh
kubectl get pods $(kubectl get pods -l=app=<SOME-APPLICATION> -o jsonpath="{.items[0].metadata.name}") -o jsonpath="{.status.containerStatuses[0].imageID}"
```

I have used the app label here, but you can use any label or just get the pod directly by its name.

The result will be something like this:

```
europe-west1-docker.pkg.dev/<XXX>/<YYY>/<IMAGE_NAME>@sha256:51dbfc749ec3018c7d4bf8b9ee65299ff9a908e38918ce163b0acfcd5dd931d9
```

You can now use the image digest to compare it to the containers in the registry.
