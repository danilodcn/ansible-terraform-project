
export ANSIBLE_PRIVATE_KEY_FILE=/home/danilodcn/Downloads/infra-dev-services.pem

#Set Ansible Inventory configuration
export ANSIBLE_INVENTORY=$(pwd)/project/inventory.aws_ec2.yml

export ANSIBLE_HOST_KEY_CHECKING=0

echo ANSIBLE_PRIVATE_KEY_FILE=$ANSIBLE_PRIVATE_KEY_FILE
echo ANSIBLE_INVENTORY=$ANSIBLE_INVENTORY
echo ANSIBLE_HOST_KEY_CHECKING=$ANSIBLE_HOST_KEY_CHECKING