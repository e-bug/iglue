#!/bin/bash

TASK=20
lang=ko
MODEL=m3p
MODEL_CONFIG=m3p_base
TASKS_CONFIG=iglue_test_tasks_X101.dtu
TRTASK=RetrievalWIT
TETASK=RetrievalWIT${lang}
TEXT_PATH=/home/projects/ku_00062/data/wit/annotations_machine-translate/test_${lang}_gmt.jsonl
FEAT_PATH=/home/projects/ku_00062/data/wit/features/wit_test_X101.lmdb
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/wit/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/wit/${MODEL}_gmt/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_retrieval.py \
  --bert_model /home/projects/ku_00062/huggingface/xlm-roberta-base --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} --is_m3p \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --caps_per_image 1 --split test_${lang} --batch_size 1 --num_subiters 4 \
  --output_dir ${OUTPUT_DIR} --val_annotations_jsonpath ${TEXT_PATH} --val_features_lmdbpath ${FEAT_PATH} --num_val_workers 0
deactivate
