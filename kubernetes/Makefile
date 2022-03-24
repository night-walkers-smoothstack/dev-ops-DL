IMAGES=mysql adminer aline-underwriter aline-bank aline-transaction aline-user --name kind
# build new cluster 
cluster:
	kind create cluster --config=cluster-config.yml

# destroy cluster 
del:
	kind delete cluster

# load and apply everything to cluster
it-so: docker vars db ingress ms

# apply configmaps and secrets
vars:
	kubectl apply -f ./configmaps
	kubectl apply -f ./secrets

# load docker images
docker:
	kind load docker-image $(IMAGES)
.PHONY: docker

# apply db
db:
	kubectl apply -f ./db
.PHONY: db

# apply ingress model and install driver
ingress:
	kubectl apply -f aline-ingress.yml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# apply microservices
ms:
	kubectl apply -f ./microservices

.PHONY: ms
