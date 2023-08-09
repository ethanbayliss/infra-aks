# AKS Private Cluster Init
This module will take input of a list of kubernetes manifests to apply against a private AKS cluster.
An Azure function will then apply these manifests to the Kubernetes cluster

This is useful for init of a Kubernetes cluster and installing tooling like ArgoCD.
