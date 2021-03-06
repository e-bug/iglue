#!/bin/bash

TASK=19
MODEL=ctrl_uniter
MODEL_CONFIG=ctrl_uniter_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=XVNLI
TETASK=XVNLIes
TEXT_PATH=/home/projects/ku_00062/data/XVNLI/annotations_machine-translate/es/test_gmt.jsonl
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/xvnli/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/xvnli/${MODEL}_gmt/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/bert-base-uncased --do_lower_case \
  --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --split test \
  --output_dir ${OUTPUT_DIR} --val_annotations_jsonpath ${TEXT_PATH}

deactivate
