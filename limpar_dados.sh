#!/bin/bash

file=${1}

echo -e "request\n$(grep 'Request' ${file} | cut -d' ' -f 2)" > arq01.txt
echo -e "time\n$(grep 'Time:' ${file} | cut -d' ' -f 2)" > arq02.txt
echo -e "time_namelookup\n$(grep 'time_namelookup:' ${file} | tr '\t' ' ' | cut -d' ' -f 3)" > arq03.txt
echo -e "time_connect\n$(grep  'time_connect:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq04.txt
echo -e "time_appconnect\n$(grep 'time_appconnect:' ${file} | tr '\t' ' ' | cut -d' ' -f 3)" > arq05.txt
echo -e "time_redirect\n$(grep 'time_redirect:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq06.txt
echo -e "time_pretransfer\n$(grep 'time_pretransfer:' ${file} | tr '\t' ' ' | cut -d' ' -f 3)" > arq07.txt
echo -e "time_starttransfer\n$(grep 'time_starttransfer:' ${file} | tr '\t' ' ' | cut -d' ' -f 3)" > arq08.txt
echo -e "time_total\n$(grep 'time_total:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq09.txt
echo -e "size_download\n$(grep 'size_download:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq10.txt 
echo -e "size_header\n$(grep 'size_header:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq11.txt 
echo -e "speed_download\n$(grep 'speed_download:' ${file} | tr '\t' ' ' | cut -d' ' -f 4)" > arq12.txt 

paste arq01.txt arq02.txt arq03.txt arq04.txt arq05.txt arq06.txt arq07.txt arq08.txt arq09.txt arq10.txt arq11.txt arq12.txt > quic_normal-l.txt
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12}' quic_normal-l.txt > ${file}-formatado.txt

rm arq01.txt arq02.txt arq03.txt arq04.txt arq05.txt arq06.txt arq07.txt arq08.txt arq09.txt arq10.txt arq11.txt arq12.txt quic_normal-l.txt