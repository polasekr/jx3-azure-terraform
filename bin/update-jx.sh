#!/bin/bash

# Run this script to update local cli & plugins, gitops upgrade the boot repository,
# commit changes and push them to the cluster for a complete upgrade.
# There can be some merge conflicts needing manual fix, commit and push.
set -e

jx upgrade cli
jx upgrade plugins

jx gitops upgrade

git add helmfile.yaml
git add versionStream
git commit -m "chore(jx): gitops upgrade" && git push
