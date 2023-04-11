
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
