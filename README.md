# 1. Find Duplicates
## How to run
```
    python3 ./find-duplicates/duplicate.py <file_path>
```

# 2. Deploy Script
## How to run
Before using deploy script you need the login to gcloud: 
`gcloud auth login`

```
./deploy.sh
```

# 3. Resources
* gcloud: 
  - https://cloud.google.com/compute/docs
* Github Action: 
  - https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-google-kubernetes-engine
  - https://github.com/google-github-actions/setup-gcloud
  - https://github.com/google-github-actions/get-gke-credentials  

* kustomization :
  - https://github.com/kubernetes-sigs/kustomize#usage