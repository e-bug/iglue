#!/bin/bash

TASK=12
MODEL=m3p
MODEL_CONFIG=m3p_base
TASKS_CONFIG=iglue_test_tasks_X101.dtu
TRTASK=NLVR2
TETASK=NLVR2
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/marvl/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/marvl/${MODEL}/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/xlm-roberta-base \
  --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} --is_m3p \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK \
  --output_dir ${OUTPUT_DIR} \
deactivate
