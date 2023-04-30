#!/bin/bash

git clone https://github.com/prometheus-operator/kube-prometheus.git /tmp/kube-prometheus
echo "Show manifests with differences:"
diff -q manifests/ /tmp/kube-prometheus/manifests/ | grep differ
echo "SYNC FILES..."
rsync -av --exclude "grafana-deployment.yaml" /tmp/kube-prometheus/manifests/ kube-prometheus/
