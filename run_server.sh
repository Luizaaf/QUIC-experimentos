#!/bin/bash

cd ~/chromium/src

./out/Default/quic_server \
--quic_response_cache_dir=/home/ubuntu/html \
--certificate_file=net/tools/quic/certs/out/leaf_cert.pem \
--key_file=net/tools/quic/certs/out/leaf_cert.pkcs8 &