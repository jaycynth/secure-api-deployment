DOCKER_USER = jaycynth
IMAGE_NAME = flask-app
TAG ?= latest
FULL_IMAGE_NAME = $(DOCKER_USER)/$(IMAGE_NAME):$(TAG)
K8S_MANIFESTS = k8s/*.yaml
K8S_DEPLOYMENT = k8s/deployment.yaml
K8S_SERVICE = k8s/service.yaml


docker_build:
	docker build -t $(FULL_IMAGE_NAME) .

docker_push:
	docker push $(FULL_IMAGE_NAME)

build_service: docker_build docker_push

docker_run:
	docker run -p 8080:8080 $(FULL_IMAGE_NAME)


# Kubernetes setup and deployment
lint:
	kube-linter lint k8s/

validate:
	kubeval $(K8S_MANIFESTS)

k8s-setup:
	kind create cluster

k8s-deploy:
	kubectl apply -f $(K8S_DEPLOYMENT)
	kubectl apply -f $(K8S_SERVICE)

k8s-get-nodes:
	kubectl get pods

k8s-get-services:
	kubectl get services

k8s-access:
	kubectl port-forward service/flask-app 8080:8080

clean:
	kind delete cluster || true
	kubectl delete -f $(K8S_MANIFESTS) || true
	docker rmi $(FULL_IMAGE_NAME) || true

