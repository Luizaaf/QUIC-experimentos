#!/bin/bash

# tcpdump -i lo -wv port 6121 test.pcap

# Limita a taxa de tranferência para 100 mbits

clean () {
  sudo tc qdisc del dev eth0 root
  rm ~/download
}

quic_normal () {
  echo "Run normal"
  sudo tc qdisc add dev eth0 root tbf rate 100mbit burst 32kbit latency 400ms
  touch ~/download
  touch ~/quic_normal.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_normal.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    ./out/Default/quic_client -disable_certificate_verification --host=172.31.82.138 --port=6121 https://www.example.org/ > download &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_normal.pcap &> /dev/null &
  clean
  cd ~/
}
quic_delay () {
  echo "Run delay"
  sudo tc qdisc add dev eth0 root netem delay 10ms rate 100mbit
  touch ~/download
  touch ~/quic_delay.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_delay.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    ./out/Default/quic_client -disable_certificate_verification --host=172.31.82.138 --port=6121 https://www.example.org/ > download &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_normal.pcap &> /dev/null &  
  clean
  cd ~/
}

quic_delay_jitter () {
  echo "Run delay and jitter"
  sudo tc qdisc add dev eth0 root netem delay 10ms 10ms rate 100mbit 
  touch ~/download
  touch ~/quic_delay_jitter.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_delay_jitter.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    ./out/Default/quic_client -disable_certificate_verification --host=172.31.82.138 --port=6121 https://www.example.org/ > download &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_normal.pcap &> /dev/null &
  clean  
  cd ~/
}

quic_loss () {
  echo "Run loss"
  sudo tc qdisc add dev eth0 root netem loss 10% rate 100mbit
  touch ~/download
  touch ~/quic_loss.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_loss.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10};
  do
    ./out/Default/quic_client -disable_certificate_verification --host=172.31.82.138 --port=6121 https://www.example.org/ > download &> /dev/null; 
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/quic_normal.pcap &> /dev/null &
  clean
  cd ~/ 
}

quic_normal
quic_delay
quic_delay_jitter
quic_loss
