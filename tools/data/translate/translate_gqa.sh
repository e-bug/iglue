#!/bin/bash

LANGS="bn de id ko pt ru zh"

mkdir -p ../../dataset_dir/xGQA/annotations_machine-translate/zero_shot

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/xGQA/zero_shot/testdev_balanced_questions_${lang}.json"
  OUT_FN="../../dataset_dir/xGQA/annotations_machine-translate/zero_shot/testdev_balanced_questions_${lang}.json"
  python translate_gqa.py \
    --field_name "question" \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done

mkdir -p ../../dataset_dir/xGQA/annotations_machine-translate/few_shot

for lang in $LANGS; do
  echo "Translating from ${lang}..."
  IN_FN="../../dataset_dir/xGQA/few_shot/${lang}/test.json"
  OUT_FN="../../dataset_dir/xGQA/annotations_machine-translate/few_shot/${lang}/test.json"
  mkdir ../../dataset_dir/xGQA/annotations_machine-translate/few_shot/${lang}
  python translate_gqa.py \
    --field_name "question" \
    --in_lang $lang --out_lang "en" \
    --in_file $IN_FN --out_file $OUT_FN
done
