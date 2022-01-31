#!/bin/bash

for l in 1e-4 5e-5 1e-5; do cd $l; for d in */; do lang=`echo $d | cut -d '_' -f 1 | tail -c 3`; num=`echo $d | cut -d '_' -f 2`; mv $d/*/test/pytorch_model_best.bin-/test_${lang}_result.json ../test_${lang}_${num}_result.json; done; cd ..; done
