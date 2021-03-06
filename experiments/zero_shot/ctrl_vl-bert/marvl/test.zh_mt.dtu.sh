#!/bin/bash

TASK=12
MODEL=ctrl_vl-bert
MODEL_CONFIG=ctrl_vl-bert_base
TRTASK=NLVR2
TETASK=MaRVLzh
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TEXT_PATH=/home/projects/ku_00062/data/marvl/zero_shot/annotations_machine-translate/marvl-zh_gmt.jsonl
FEAT_PATH=/home/projects/ku_00062/data/marvl/zero_shot/features/marvl-zh_boxes36.lmdb
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/marvl/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/marvl/${MODEL}_gmt/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_task.py \
  --bert_model /home/projects/ku_00062/huggingface/bert-base-uncased --do_lower_case \
  --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --val_annotations_jsonpath ${TEXT_PATH} --val_features_lmdbpath ${FEAT_PATH} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --split test \
  --output_dir ${OUTPUT_DIR}

deactivate
