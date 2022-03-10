#!/usr/bin/env bash

ingressIP=$(kubectl get service ingress-nginx-controller \
  -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[].ip}')

demos=(rolling bluegreen canary)

for i in "${demos[@]}"; do
  kubectl create ns guestbook-${i}
  argocd app create guestbook-${i} \
    --repo https://github.com/brk3/k8s-guestbook-go/ \
    --path helm/guestbook-go \
    --dest-namespace guestbook-${i} \
    --dest-server https://kubernetes.default.svc \
    --helm-set ingressIP="${ingressIP}" \
    --helm-set updateStrategy="${i}"
done
