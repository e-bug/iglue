#!/bin/bash

TASK=15
LANG=bn
MODEL=ctrl_xuniter
MODEL_CONFIG=ctrl_xuniter_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=GQA
TETASK=xGQA${LANG}
TEXT_PATH=/home/projects/ku_00062/data/xGQA/annotations/few_shot/${LANG}/test.json
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/xgqa/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/xgqa/${MODEL}/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/xlm-roberta-base --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK \
  --split test_${LANG} \
  --output_dir ${OUTPUT_DIR} --val_annotations_jsonpath ${TEXT_PATH}
python scripts/GQA_score.py \
  --preds_file ${OUTPUT_DIR}/pytorch_model_best.bin-/test_${LANG}_result.json \
  --truth_file $TEXT_PATH

deactivate
