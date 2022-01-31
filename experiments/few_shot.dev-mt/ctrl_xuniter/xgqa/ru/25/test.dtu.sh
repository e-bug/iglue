#!/bin/bash

TASK=15
SHOT=25
LANG=ru
MODEL=ctrl_xuniter
MODEL_CONFIG=ctrl_xuniter_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=xGQA${LANG}_${SHOT}
TETASK=xGQA${LANG}
TEXT_PATH=/home/projects/ku_00062/data/xGQA/annotations/few_shot/${LANG}/test.json

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
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/few_shot.mt/xgqa/${TRTASK}/${MODEL}/${best_lr}/GQA_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/few_shot.mt/xgqa/${MODEL}/${best_lr}/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/xlm-roberta-base --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK \
  --split test_${LANG} --val_annotations_jsonpath ${TEXT_PATH} \
  --output_dir ${OUTPUT_DIR} --val_annotations_jsonpath ${TEXT_PATH} \

python scripts/GQA_score.py \
  --preds_file ${OUTPUT_DIR}/pytorch_model_best.bin-/test_${LANG}_result.json \
  --truth_file $TEXT_PATH \
deactivate
