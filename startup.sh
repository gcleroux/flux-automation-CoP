#!/usr/bin/env sh

# ===================================
# ENV config
GITHUB_USER=gcleroux
GITHUB_REPOSITORY=flux-automation-CoP
GITHUB_BRANCH=main

# This key must be registered to your GitHub account.
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
PRIVATE_KEY_FILE=~/.ssh/id_ed25519
PRIVATE_KEY_PASSPHRASE=""
# ===================================

# Creating the kind cluster
kind create cluster --config ./kind-config.yaml

# Preparing the cluster for ingress (could also be done from flux)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
	--timeout=90s

# Bootstrapping the cluster using ssh
flux bootstrap git \
	--components=source-controller,kustomize-controller,notification-controller \
	--components-extra=image-reflector-controller,image-automation-controller \
	--url=ssh://git@github.com/$GITHUB_USER/$GITHUB_REPOSITORY \
	--private-key-file=$PRIVATE_KEY_FILE \
	--password=$PRIVATE_KEY_PASSPHRASE \
	--branch=$GITHUB_BRANCH \
	--path=clusters/kind-cluster
