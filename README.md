- Para obter e construir o chromium a partir do codigo fonte execute os seguintes comandos.

```bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
export PATH="$PATH:$(pwd)"

mkdir ~/chromium && cd ~/chromium
fetch --nohooks --no-history chromium

cd src
./build/install-build-deps.sh
gclient runhooks
gn gen out/Default
```

- Para instruções mais detalhadas visite [Build instructions](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md)

- Construa o cliente e o servidor

```bash
ninja -C out/Default quic_server quic_client
```

- Gere uma chave TLS para o servidor

```bash
cd net/tools/quic/certs
./generate-certs.sh
cd -
```

- Adicione a chave para o espaço root do sistema

```bash
certutil -d sql:$HOME/.pki/nssdb -A -t "C,P," -n quic_cert -i net/tools/quic/certs/out/2048-sha256-root.pem
```

- Instalando a ultima versão do tshark

```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt-get update
sudo apt-get install tshark -y

sudo usermod -a -G wireshark $USER
```

curl -I -L --http2 --insecure https://localhost