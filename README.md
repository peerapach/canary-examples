
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
This example is used the image from https://hub.docker.com/r/eexit/mirror-http-server 


## Load test
Forward port 
```
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

Test by curl (200 OK)
```
while true; do curl -s localhost:8080; done
```

Test by curl (500 Internal Server Error)
```
while true; do curl -s -H 'X-Mirror-Code:500' localhost:8080; done
```