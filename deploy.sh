#!/bin/bash
echo "🚀 DÉPLOIEMENT AUTOMATIQUE"

cd infra/ansible

ansible-playbook -i inventory/hosts.ini playbooks/01-docker.yml -K
ansible-playbook -i inventory/hosts.ini playbooks/02-cleanup-kubeadm.yml -K
ansible-playbook -i inventory/hosts.ini playbooks/03-microk8s-setup-fixed.yml -K
ansible-playbook -i inventory/hosts.ini playbooks/04-deploy-vote-app-complete.yml -K \
  -e "frontend_image=$1/vote-frontend:latest" \
  -e "backend_image=$1/vote-backend:latest" \
  -e "master_ip=192.168.1.32"
ansible-playbook -i inventory/hosts.ini playbooks/05-hpa-backend.yml -K
ansible-playbook -i inventory/hosts.ini playbooks/07-supervision.yml -K

echo "✅ DÉPLOIEMENT TERMINÉ"