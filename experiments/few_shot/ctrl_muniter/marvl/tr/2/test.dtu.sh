#!/bin/bash

TASK=12
SHOT=2
LANG=tr
MODEL=ctrl_muniter
MODEL_CONFIG=ctrl_muniter_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=MaRVL${LANG}_${SHOT}
TETASK=MaRVL${LANG}
TEXT_PATH=/home/projects/ku_00062/data/marvl/zero_shot/annotations/marvl-${LANG}.jsonl
FEAT_PATH=/home/projects/ku_00062/data/marvl/zero_shot/features/marvl-${LANG}_boxes36.lmdb

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
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/few_shot/marvl/${TRTASK}/${MODEL}/${best_lr}/NLVR2_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/few_shot/marvl/${MODEL}/${best_lr}/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/bert-base-multilingual-cased \
  --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --val_annotations_jsonpath ${TEXT_PATH} --val_features_lmdbpath ${FEAT_PATH} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --split test \
  --output_dir ${OUTPUT_DIR} \

deactivate
