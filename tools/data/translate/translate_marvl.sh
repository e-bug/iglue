#!/bin/bash

LANGS="id tr zh"

mkdir ../../dataset_dir/marvl/annotations_machine-translate

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/marvl/annotations/marvl-${lang}.jsonl"
  OUT_FN="../../dataset_dir/marvl/annotations_machine-translate/marvl-${lang}_gmt.jsonl"
  python translate.py \
    --field_name "caption" \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done
