#!/bin/bash

LANGS="ar es fr ru"

for lang in $LANGS; do
  echo "Translating into ${lang}..."
  IN_FN="../../dataset_dir/XVNLI/annotations/en/dev.jsonl"
  OUT_FN="../../dataset_dir/XVNLI/annotations/en/dev-${lang}_gmt.jsonl"
  python translate_xvnli.py \
    --in_lang "en" --out_lang $lang \
    --in_file $IN_FN --out_file $OUT_FN
done
