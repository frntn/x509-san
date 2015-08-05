#!/bin/bash

:<<-USAGE
See https://github.com/frntn/x509-san/blob/master/README.md
USAGE

certname="${CRT_FILENAME:-"frntn-x509-san"}"
openssl x509 \
    -in <(
        openssl req \
            -days 3650 \
            -newkey rsa:4096 \
            -nodes \
            -keyout "${certname}.key" \
            -subj "/C=${CRT_C:-"FR"}/L=${CRT_L:-"Paris"}/O=${CRT_O:-"Ekino"}/OU=${CRT_OU:-"DevOps"}/CN=${CRT_CN:-"base.example.com"}"
        ) \
    -req \
    -signkey "${certname}.key" \
    -sha256 \
    -days 3650 \
    -out "${certname}.crt" \
    -extfile <(echo -e "basicConstraints=critical,CA:true,pathlen:0\nsubjectAltName=${CRT_SAN:-"DNS.1:logs.example.com,DNS.2:metrics.example.com,IP.1:192.168.0.1,IP.2:10.0.0.50"}")
