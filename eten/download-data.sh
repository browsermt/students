#!/bin/bash
mkdir -p data
cd data
wget -nc https://object.pouta.csc.fi/OPUS-Tatoeba/v20190709/moses/en-et.txt.zip
unzip en-et.txt.zip
cd ..
