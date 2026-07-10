sudo apt-get update
sudo apt-get install -y curl software-properties-common gnupg

curl -sSL https://packages.microsoft.com/keys/microsoft.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" | \
sudo tee /etc/apt/sources.list.d/microsoft-prod.list

sudo apt-get update
