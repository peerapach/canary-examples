
## Prepare K8S for test (minikube)

```
make minikube
```

## Setup istio
```
make istio
```

## Setup flagger
```
make flagger
```

## Setup Argo
```
make argo
```

## Deploy application
```
make deploy version=1.1.1
```
This example is used the image from https://hub.docker.com/r/peerapach/mirror-http-server 


## Load test
Forward port 
```
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

Test by curl (200 OK)
```
while true; do curl -s -H "Host: api.example.com" localhost:8080/api; done
```

Test by curl (500 Internal Server Error)
```
while true; do curl -s -H 'X-Mirror-Code:500' -H "Host: api.example.com" localhost:8080/api; done
```

# Monitoring 
## Argo rollout

by command
```
kubectl argo rollouts get rollout api-argo
```
by Dashboard UI
```
kubectl argo rollouts dashboard
```

## Flagger
Logging
```
kubectl -n istio-system logs deployment/flagger --tail=100 | jq .msg
```
Grafana dashboard
```
kubectl port-forward -n istio-system svc/flagger-grafana 3000:80
```
access by http://localhost:3000

user: admin / pass: change-me
