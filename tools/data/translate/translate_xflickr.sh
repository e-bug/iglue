#!/bin/bash

LANGS="ja id tr zh es ru de"

mkdir ../../dataset_dir/xFlickr/annotations_machine-translate

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/xFlickr/annotations/${lang}/test.jsonl"
  OUT_FN="../../dataset_dir/xFlickr/annotations_machine-translate/${lang}/test.jsonl"
  mkdir ../../dataset_dir/xFlickr/annotations_machine-translate/${lang}
  python translate.py \
    --field_name "sentences" \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done
