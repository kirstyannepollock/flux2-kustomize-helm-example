GITHUB_TOKEN=$(cat ../.secrets/github-pat.txt);
GITHUB_USER=kirstyannepollock
GITHUB_REPO=flux2-kustomize-helm-example
kind create cluster --name dev

# staging
kubectl config use-context kind-dev

flux bootstrap github \
    --context=kind-dev \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/dev

flux get kustomizations --watch
# checks

kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80 & \
curl -H "Host: podinfo.dev" http://localhost:8080

