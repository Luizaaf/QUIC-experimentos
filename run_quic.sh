#!/bin/bash

taxa=${1}
taxa=$(expr ${taxa} \* 1024)

clean () {
  tc qdisc del dev enp0s3 root
}

setTaxa () {
  wondershaper enp0s3 ${taxa} ${taxa}
}

quic_normal () {
  echo "Run normal"

  for i in {1..100}
  do
    echo -e "Request ${i}\nTime: $(date +"%T")\n$(docker run -it --rm ymuski/curl-http3 curl -s -w 'time_namelookup:\t\t%{time_namelookup} s\ntime_connect:\t\t\t%{time_connect} s\ntime_appconnect:\t\t%{time_appconnect} s\ntime_redirect:\t\t\t%{time_redirect} s\ntime_pretransfer:\t\t%{time_pretransfer} s\ntime_starttransfer:\t\t%{time_starttransfer} s\ntime_total:\t\t\t%{time_total} s\n\nsize_download:\t\t\t%{size_download} bytes\nsize_header:\t\t\t%{size_header} bytes\n\nspeed_download:\t\t\t%{speed_download} bytes/s\n' -o /dev/null https://www.youtube.com/ --http3)" >> /home/luiz/quic_normal.txt
  done
}

quic_delay () {
  echo "Run delay"
  tc qdisc add dev enp0s3 root netem delay 10ms
  
  for i in {0..100}
  do
    echo -e "Request ${i}\nTime: $(date +"%T")\n$(docker run -it --rm ymuski/curl-http3 curl -s -w 'time_namelookup:\t\t%{time_namelookup} s\ntime_connect:\t\t\t%{time_connect} s\ntime_appconnect:\t\t%{time_appconnect} s\ntime_redirect:\t\t\t%{time_redirect} s\ntime_pretransfer:\t\t%{time_pretransfer} s\ntime_starttransfer:\t\t%{time_starttransfer} s\ntime_total:\t\t\t%{time_total} s\n\nsize_download:\t\t\t%{size_download} bytes\nsize_header:\t\t\t%{size_header} bytes\n\nspeed_download:\t\t\t%{speed_download} bytes/s\n' -o /dev/null https://www.youtube.com/ --http3)" >> /home/luiz/quic_delay.txt
  done
}


setTaxa
quic_normal
clean
quic_delay
clean