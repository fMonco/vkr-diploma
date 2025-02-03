terraform plan
terraform apply -auto-approve
cat <<EOF > ../ansible/inventory.ini
[gitlab-server]
gitlab-server ansible_host=$(terraform output -raw external_ip_address_gitlab_server)

[stage]
stage ansible_host=$(terraform output -raw external_ip_address_stage)
EOF