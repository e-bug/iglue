#!/bin/bash

LANGS="ar es fr ru"

mkdir ../../dataset_dir/XVNLI/annotations_machine-translate

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/XVNLI/annotations/${lang}/test.jsonl"
  OUT_FN="../../dataset_dir/XVNLI/annotations_machine-translate/${lang}/test.jsonl"
  mkdir ../../dataset_dir/XVNLI/annotations_machine-translate/${lang}
  python translate_xvnli.py \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done
