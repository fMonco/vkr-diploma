#!/bin/bash

# Check if the 'runner' argument is provided
if [[ "$1" == "runner" ]]; then
  ANSIBLE_CONFIG=./ansible/ansible.cfg ansible-playbook -i ./ansible/inventory.ini ./ansible/configure-servers.yaml --tags register_runner
  echo
  echo "GitLab runner успешно зарегистрирован"
  exit 0
fi

# Step 1: Generate SSH keys
echo "Генерация SSH ключей"
echo
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
else
  echo "SSH ключ уже существует, пропуск генерации"
fi
echo

# Step 2: Wait for user to confirm tokens are set
echo "Получение токенов для Yandex Cloud"
echo

# Step 3: Export tokens to the shell environment
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

# Step 4: Create infrastructure with Terraform
echo "Создание инфраструктуры с Terraform"
echo
cd ./terraform-code
terraform init
terraform plan
terraform apply -auto-approve
cd -

# Step 5: Create Ansible inventory
./terraform-code/create-inventory.sh

# Step 6: Prompt for GitLab root password and save to secret.txt
while true; do
  read -sp "Введите root пароль для GitLab (должен содержать спецсимволы, цифры и быть не менее 12 символов): " gitlab_root_password
  echo
  if [[ ${#gitlab_root_password} -ge 12 && "$gitlab_root_password" =~ [^a-zA-Z0-9] && "$gitlab_root_password" =~ [0-9] ]]; then
    echo $gitlab_root_password > ./ansible/secret.txt
    break
  else
    echo "Пароль не соответствует требованиям. Попробуйте еще раз."
  fi
done

# Step 7: Run Ansible playbook with specified configuration file
ANSIBLE_CONFIG=./ansible/ansible.cfg ansible-playbook -i ./ansible/inventory.ini ./ansible/configure-servers.yaml

echo "Настройка серверов завершена. Пожалуйста, проверьте результаты в браузере и зарегистрируйте GitLab Runner"
echo
echo "Для доступа к GitLab используйте логин root и пароль, введенный вами на предыдущем шаге"
echo
echo "Для доступа к Stage используйте логин ansible и SSH ключ"
echo
echo "Для регисстрации GitLab Runner выполните команду: 
source install.sh runner"