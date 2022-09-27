#!/bin/bash

# tcpdump -i lo -wv port 6121 test.pcap

# Limita a taxa de tranferência para 100 mbits

clean () {
  sudo tc qdisc del dev eth0 root
  rm ~/index.html
}

tcp_normal () {
  echo "Run normal"
  sudo tc qdisc add dev eth0 root tbf rate 100mbit burst 32kbit latency 400ms
  touch ~/index.html
  touch ~/tcp_normal.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_normal.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    wget -O ~/index.html https://172.31.82.138/ --no-check-certificate &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_normal.pcap &> /dev/null &
  clean
  cd ~/
}
tcp_delay () {
  echo "Run delay"
  sudo tc qdisc add dev eth0 root netem delay 10ms rate 100mbit
  touch ~/index.html
  touch ~/tcp_delay.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_delay.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    wget -O ~/index.html https://172.31.82.138/ --no-check-certificate &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_normal.pcap &> /dev/null &  
  clean
  cd ~/
}

tcp_delay_jitter () {
  echo "Run delay and jitter"
  sudo tc qdisc add dev eth0 root netem delay 10ms 10ms rate 100mbit 
  touch ~/index.html
  touch ~/tcp_delay_jitter.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_delay_jitter.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10}
  do
    wget -O ~/index.html https://172.31.82.138/ --no-check-certificate &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_normal.pcap &> /dev/null &
  clean  
  cd ~/
}

tcp_loss () {
  echo "Run loss"
  sudo tc qdisc add dev eth0 root netem loss 10% rate 100mbit
  touch ~/index.html
  touch ~/tcp_loss.pcap

  tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_loss.pcap &> /dev/null &

  cd ~/chromium/src
  for i in {0..10};
  do
    wget -O ~/index.html https://172.31.82.138/ --no-check-certificate &> /dev/null
  done
  kill tshark -i eth0 -f "host 172.31.82.138" -w ~/tcp_normal.pcap &> /dev/null &
  clean
  cd ~/ 
}

tcp_normal
tcp_delay
tcp_delay_jitter
tcp_loss
