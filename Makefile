define getDeploymentType
$(shell if [ -f .canary ]; then cat .canary | xargs; fi)
endef

minikube:
	minikube start --memory=10240 --cpus=4 --kubernetes-version=v1.25.2
	minikube addons enable metrics-server

istio:
	@echo "install istio"
	curl -s -L https://git.io/getLatestIstio | sh -
	@cd istio-* && \
	istioctl install --skip-confirmation && \
	istioctl manifest install --set profile=default --skip-confirmation

	@echo "\n=== Apply Kiali for istio ==="
	@cd istio-* && \
	kubectl apply -f samples/addons/kiali.yaml

	@echo "\n=== Apply Prometheus for istio ==="
	@cd istio-* && \
	kubectl apply -f samples/addons/prometheus.yaml

flagger:
	@echo "Setup Flagger"
	kubectl apply -k github.com/fluxcd/flagger//kustomize/istio
	kubectl apply -f ./analysis-templates/flagger -n istio-system
	@echo "flagger" > .canary 

argo:
	kubectl create namespace argo-rollouts
	kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
	kubectl apply -n argo-rollouts -f ./analysis-templates/argo
	@echo "argo" > .canary 

deploy:
	$(eval ROLLOUT_TYPE=$(getDeploymentType))
ifeq "$(getDeploymentType)" "flagger"
	$(eval APP_PATH=apps/mhs/flagger)
else ifeq "$(getDeploymentType)" "argo"
	$(eval APP_PATH=apps/mhs/argo)
else
	@echo "Can't find rollout type"
	@exit 1
endif
	@echo "Deploy version ${version} -- ${ROLLOUT_TYPE} - ${APP_PATH}"
	@bash -c "cd ${APP_PATH} && echo APP_VERSION=${version} > version.env && kustomize edit set image peerapach/mirror-http-server:${version} && kubectl apply -k ./"

destroy:
	minikube delete
