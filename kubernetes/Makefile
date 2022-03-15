IMAGES=mysql adminer underwriter bank transaction user gateway --name kind

# it-so:

cluster:
	kind create cluster --config=cluster-config.yml

del:
	kind delete cluster

it-so: docker vars db ingress

vars:
	kubectl apply -f ./configmaps
	kubectl apply -f ./secrets

docker:
	kind load docker-image $(IMAGES)

db:
	kubectl apply -f ./db
.PHONY: db

ingress:
	kubectl apply -f aline-ingress.yml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# apply microservices
ms:
	kubectl apply -f ./microservices

.PHONY: ms
