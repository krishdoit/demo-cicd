#!/bin/bash
set -e

export KUB_GPG="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
export LINUX_DIST="amd64"
export AWS_IAM_AUTH_URL="https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05"
export DOCKER_GPG="https://download.docker.com/linux/ubuntu/gpg"
export DOCKER_REPO="https://download.docker.com/linux/ubuntu"
export HELM_REPO="https://baltocdn.com/helm/signing.asc"


sudo apt-get update && sudo apt-get install -y apt-utils apt-transport-https gnupg2 curl
curl -s ${KUB_GPG} | sudo apt-key add -
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
curl -o aws-iam-authenticator ${AWS_IAM_AUTH_URL}/bin/linux/${LIUX_DIST}/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install aws-iam-authenticator software"
  exit $EXIT_STATUS
else
  echo "successfully installed aws-iam-authenticator"
fi

echo "installing docker client"
sudo apt-get update

curl -fsSL ${DOCKER_GPG} | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64]  ${DOCKER_REPO} $(lsb_release -cs) stable"

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
curl ${HELM_REPO} | sudo apt-key add - && \
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

echo docker client installed version is `docker -v`
echo kubectl installed version is `kubectl version --client`
echo Helm Version installed is `helm version`