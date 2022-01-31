#!/bin/bash

TASK=8
SHOT=5
LANG=ru
MODEL=ctrl_muniter
MODEL_CONFIG=ctrl_muniter_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=RetrievalxFlickrCO${LANG}_${SHOT}
TETASK=RetrievalxFlickrCO${LANG}
TEXT_PATH=/home/projects/ku_00062/data/xFlickrCO/annotations/${LANG}/test.jsonl
FEAT_PATH=/home/projects/ku_00062/data/xFlickrCO/features/xflickrco-test_boxes36.lmdb

here=$(pwd)

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../../../volta

best=-1
best_lr=-1
for lr in 1e-4 5e-5 1e-5; do
  f=${here}/train.${lr}.log
  s=`tail -n1 $f | cut -d ' ' -f 4`
  d=$(echo "$s>$best" | bc)
  if [[ $d -eq 1 ]]; then
    best=$s
    best_lr=$lr
  fi
done
echo "Best lr: " $best_lr
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/few_shot.mt/xflickrco/${TRTASK}/${MODEL}/${best_lr}/RetrievalFlickr30k_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/few_shot.mt/xflickrco/${MODEL}/${best_lr}/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

python eval_retrieval.py \
  --bert_model /home/projects/ku_00062/huggingface/bert-base-multilingual-cased --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK \
  --split test_${LANG} --batch_size 1 \
  --caps_per_image 1 --val_annotations_jsonpath ${TEXT_PATH} --val_features_lmdbpath ${FEAT_PATH} \
  --output_dir ${OUTPUT_DIR} \

deactivate
