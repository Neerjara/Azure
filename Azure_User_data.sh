#cloud-config
# User data to install docker, azure cli & kubectl on Ubuntu 24
package_update: true
package_upgrade: false

write_files:
  - path: /usr/local/sbin/install-tools.sh
    permissions: "0755"
    content: |
      #!/usr/bin/env bash
      set -euxo pipefail
      export DEBIAN_FRONTEND=noninteractive

      apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

      install -m 0755 -d /etc/apt/keyrings

      # Docker
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo ${VERSION_CODENAME}) stable" > /etc/apt/sources.list.d/docker.list

      # kubectl
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

      # Azure CLI
      curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
      chmod go+r /etc/apt/keyrings/microsoft.gpg
      AZ_REPO="$(lsb_release -cs)"
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main" > /etc/apt/sources.list.d/azure-cli.list

      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin kubectl azure-cli

      systemctl enable --now docker

      # Add typical default admin user to docker group if it exists
      if id -u azureuser >/dev/null 2>&1; then
        usermod -aG docker azureuser
      fi

      docker --version
      kubectl version --client
      az version

runcmd:
  - [ bash, -lc, "/usr/local/sbin/install-tools.sh > /var/log/install-tools.log 2>&1" ]
