#!/bin/bash

LANGS="ja id tr zh es ru de bn ko"

for lang in $LANGS; do
  echo "Translating into ${lang}..."
  IN_FN="../../dataset_dir/flickr30k/annotations/valid_ann.jsonl"
  OUT_FN="../../dataset_dir/flickr30k/annotations/valid-${lang}_gmt.jsonl"
  python translate.py \
    --field_name "sentences" \
    --in_lang "en" --out_lang $lang \
    --in_file $IN_FN --out_file $OUT_FN
done
