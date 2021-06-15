#!/bin/bash
set -e

# Send the log output from this script to user-data.log, syslog, and the console
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

cat > $HOME/.bashrc <<EOF

export AWS_DEFAULT_REGION=${aws_region}
export KUBECONFIG=${kube_config}
export CONFIGMAP=${config_map}
EOF

export tf_ver="0.14.7"
export helm_ver="3"
export kub_ver="v1.20.4"

# yum update
yum update -y
yum install -y git curl go

# install terraform

curl -LO https://releases.hashicorp.com/terraform/${tf_ver}/terraform_${tf_ver}_linux_amd64.zip && \
unzip -q -o ./terraform_${tf_ver}_linux_amd64.zip -d /usr/local/bin && \
chmod a+x /usr/local/bin/terraform

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install terraform"
  exit $EXIT_STATUS
else
  echo "successfully installed terraform"
fi

# install kubectl

curl -LO https://dl.k8s.io//${kub_ver}/bin/linux/amd64/kubectl && \
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
export PATH=$PATH:/usr/local/bin

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install kubectl"
  exit $EXIT_STATUS
else
  echo "successfully installed kubectl"
fi
echo 'Kubectl installed version is ${kub_ver}'

echo "Installing aws-iam-authenticator to enable auth to eks"

curl -LO https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator && \
chmod +x ./aws-iam-authenticator && \
sudo cp aws-iam-authenticator /usr/local/bin && \
sudo mv aws-iam-authenticator $HOME/bin

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install aws-iam-authenticator"
  exit $EXIT_STATUS
else
  echo "successfully installed aws-iam-authenticator"
fi

echo "install docker client"
## install Docker latest

sudo yum update -y && \
sudo yum install -y docker && \
sudo yum install -y docker && \
sudo service start docker && \
sudo service enable docker

sudo groupadd docker
sudo usermod -aG docker ec2-user

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install docker"
  exit $EXIT_STATUS
else
  echo "successfully installed docker"
fi

echo "installing helm 3"

sudo curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-${helm_ver} | bash 
export PATH=$PATH:/usr/local/bin

EXIT_STATUS=$?
if [ $? != 0 ]; then
  echo "failed to install helm"
  exit $EXIT_STATUS
else
  echo "successfully installed helm"
fi

echo            "#####################################"
echo "##########  pre-requisite softwares installed  #################"
echo            "#####################################"

echo `terraform version`
echo `docker -v`
echo `kubectl version --client`
echo `helm version`
