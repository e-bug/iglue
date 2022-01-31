#!/bin/bash

LANGS="id sw ta tr zh"
IN_FN="../../dataset_dir/nlvr2/annotations/dev.jsonl"

for lang in $LANGS; do
  echo "Translating into ${lang}..."
  OUT_FN="../../dataset_dir/nlvr2/annotations/dev-${lang}_gmt.jsonl"
  python translate.py \
    --field_name "sentence" \
    --in_lang "en" --out_lang $lang \
    --in_file $IN_FN --out_file $OUT_FN
done
