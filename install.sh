#!/bin/bash

KUBECONFIG="" //K8S congih 路徑

helm upgrade istio-operator ./istio-operator --install --create-namespace  \
--set serviceMonitor.enabled="true" \
--set dashboards.enabled="true" \
--set istioNamespace="istio-system" \
--kubeconfig $KUBECONFIG \
-n istio-operator

kubectl apply -f istio-demp-profile.yaml --kubeconfig $KUBECONFIG
kubectl apply -f istio-1.12.1/samples/addons/prometheus.yaml --kubeconfig $KUBECONFIG
kubectl label namespace thanos istio-injection=enabled --kubeconfig $KUBECONFIG

helm upgrade kiali-operator ./kiali-operator --install --create-namespace  \
--set cr.create=true \
--set cr.namespace=istio-system \
--kubeconfig $KUBECONFIG \
-n istio-operator

kubectl apply -f kiali-cr.yaml -n istio-system --kubeconfig $KUBECONFIG

kubectl apply -f istio-1.12.1/samples/addons/kiali.yaml -n istio-system --kubeconfig $KUBECONFIG

