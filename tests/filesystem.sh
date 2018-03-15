#/bin/bash
set -ex

echo "Mount Testing..."

docker run --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=vaultfstest' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200' -p 127.0.0.1:8200:8200 -d vault
curl -L https://releases.hashicorp.com/vault/0.9.5/vault_0.9.5_linux_amd64.zip > vault.zip && unzip vault.zip && rm vault.zip && mv vault tools/vault
echo 'vaultfstest' > ~/.vault-token
export VAULT_ADDR='http://127.0.0.1:8200' && vault write secret/hello value=world && vault secrets enable pki && vault write pki/root/generate/internal common_name=my-website.com ttl=8760h
mkdir $HOME/vaultfs_secret && mkdir $HOME/vaultfs_pki && mkdir $HOME/vaultfs_keyless
./vaultfs mount $HOME/vaultfs_secret -a http://127.0.0.1:8200 -i -r secret -t vaultfstest &
./vaultfs mount $HOME/vaultfs_pki -a http://127.0.0.1:8200 -i -r pki/certs -t vaultfstest &
./vaultfs mount $HOME/vaultfs_keyless -a http://127.0.0.1:8200 -i -r pki -t vaultfstest &
ls $HOME/vaultfs_secret
cat $HOME/vaultfs_secret/*
ls $HOME/vaultfs_pki
cat $HOME/vaultfs_pki/*
ls $HOME/vaultfs_keyless
