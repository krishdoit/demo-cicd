#!/bin/bash
set -e
export KUBE_GPG="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
export DOCKER_GPG="https://download.docker.com/linux/ubuntu/gpg"
export DOCKER_REPO="https://download.docker.com/linux/ubuntu"
export IAM_AUTH_URL="https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02"
export HELM_URL="https://baltocdn.com/helm/signing.asc"
export LOCAL_BIN="/usr/local/bin"

sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s ${KUBE_GPG} | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

  EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install kubectl client"
  exit $EXIT_STATUS
else
  echo "successfully installed kubectl client"
fi

echo "installing aws-iam-authenticator to enable auth to eks"
LINUX_DIST="amd64"
curl -Lo aws-iam-authenticator ${IAM_AUTH_URL}/bin/linux/${LINUX_DIST}/aws-iam-authenticator && \
chmod +x ./aws-iam-authenticator && \
sudo mv aws-iam-authenticator /usr/local/bin/ && \
export PATH=$PATH:${LOCAL_BIN}

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install aws-iam-authenticator software"
  exit $EXIT_STATUS
else
  echo "successfully installed aws-iam-authenticator"
fi

echo "install docker client"
sudo apt-get update

## Add Dockers official GPG key & stable repo

curl -fsSL ${DOCKER_GPG} | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] ${DOCKER_REPO} $(lsb_release -cs) stable"

## Install Docker latest

sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl status docker

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install docker client"
  exit $EXIT_STATUS
else
  echo "successfully installed docker client"
fi

# Install Helm to deploy the Nginx Ingress
curl ${HELM_URL} | sudo apt-key add - && \
sudo apt-get install apt-transport-https --yes && \
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && \
sudo apt-get update && \
sudo apt-get install helm

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install helm"
  exit $EXIT_STATUS
else
  echo "successfully installed helm"
fi

echo "################################################################"
echo "##########  pre-requisite softwares installed  #################"
echo "################################################################"

echo `docker -v`
echo `kubectl version --client`
echo 'helm version'
