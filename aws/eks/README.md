

For detailed usage of secrets csi driver with AWS, see [here](https://aws.amazon.com/blogs/security/how-to-use-aws-secrets-configuration-provider-with-kubernetes-secrets-store-csi-driver/)


Deployment steps
1. Build cloud resources and populate env variables. If this step fails, make sure secret.json is in secrets directory
```
source cfn/set_vars.sh
```
2. start eks cluster with eksctl using commands
```
eksctl create cluster --config-file eksctl_config.yml --profile night 
```
3. apply secrets
```

```
4. deploy microservices
. deploy ALB
6. install ngnix controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install nginx-ingress ingress-nginx/ingress-nginx \
--set-string controller.service.externalTrafficPolicy=Local \
--set-string controller.service.type=NodePort \
--set controller.publishService.enabled=true \
--set serviceAccount.create=true --set rbac.create=true \
--set-string controller.config.server-tokens=false \
--set-string controller.config.use-proxy-protocol=false \
--set-string controller.config.compute-full-forwarded-for=true \
--set-string controller.config.use-forwarded-headers=true \
--set controller.metrics.enabled=true --set controller.autoscaling.maxReplicas=1 \
--set controller.autoscaling.minReplicas=1 --set controller.autoscaling.enabled=true \
--namespace kube-system -f nginx-values.yaml 
```
7. Connect ngnix controller to ALB
```
kubectl apply -f alb-ingress-connect-nginx.yaml
```
8. Optional: validate install with: `kubectl get ingress -n kube-system`
9. 