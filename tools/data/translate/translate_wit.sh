#!/bin/bash

LANGS="ar bg da el et id ja ko tr vi"

mkdir ../../dataset_dir/wit/annotations_machine-translate

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/wit/annotations/test_${lang}.jsonl"
  OUT_FN="../../dataset_dir/wit/annotations_machine-translate/test_${lang}_gmt.jsonl"
  python translate.py \
    --field_name "caption_reference_description" \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done
