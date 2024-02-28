GITHUB_TOKEN=$(cat ../.secrets/github-pat.txt);
GITHUB_USER=kirstyannepollock
GITHUB_REPO=flux2-kustomize-helm-example
kind create cluster
flux check --pre

# staging
kubectl config use-context kind-staging

flux bootstrap github \
    --context=staging \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/staging

watch flux get helmreleases --all-namespaces
# checks

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80 & \
curl -H "Host: podinfo.staging" http://localhost:8080

# production
kubectl config use-context kind-production
flux bootstrap github \
    --context=kind-production \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/production

flux get kustomizations --watch


#clone 
cd /home/kpollock/learning
git clone git@github.com:$GITHUB_USER/$GITHUB_REPO.git
