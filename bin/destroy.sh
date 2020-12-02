#!/bin/bash

set -e

# in case we are in a clean git clone...
terraform init $TERRAFORM_INPUT

clusterName="$(terraform output cluster_name)"
clusterContext="$clusterName-admin"
clusterAdmin="clusterAdmin_$(terraform output cluster_resource_group)"

# we are about to remove the kubernetes cluster anyway so lets avoid having terraform try and remove k8s resources
terraform state list | grep -Ei "(.kubernetes_secret.|.kubernetes_namespace.|.kubernetes_config_map.|.helm_release.)" | while read line
do
if [ -z "$line" ]
then
      echo "ignoring empty line"
else
      echo "removing terraform state of $line"
      terraform state rm $line
fi
done

terraform destroy $TERRAFORM_APPROVE

# Remove the cluster, context & user from local ~/.kube/config
kubectl config unset users.$clusterAdmin
kubectl config delete-context $clusterContext
kubectl config delete-cluster $clusterName
