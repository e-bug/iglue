#!/bin/bash

TASK=8
LANG=es
MODEL=ctrl_lxmert
MODEL_CONFIG=ctrl_lxmert_base
TASKS_CONFIG=iglue_test_tasks_boxes36.dtu
TRTASK=RetrievalFlickr30k
TETASK=RetrievalxFlickrCO${LANG}
TEXT_PATH=/home/projects/ku_00062/data/xFlickrCO/annotations_machine-translate/${LANG}/test_gmt.jsonl
FEAT_PATH=/home/projects/ku_00062/data/xFlickrCO/features/xflickrco-test_boxes36.lmdb
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/zero_shot/xflickrco/${MODEL}/${TRTASK}_${MODEL_CONFIG}/pytorch_model_best.bin
OUTPUT_DIR=/home/projects/ku_00062/results/iglue/zero_shot/xflickrco/${MODEL}_gmt/${TRTASK}_${MODEL_CONFIG}/$TETASK/test

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python eval_retrieval.py \
  --bert_model /home/projects/ku_00062/huggingface/bert-base-uncased --do_lower_case --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --split test_${LANG}_gmt --batch_size 1 \
  --caps_per_image 1 --val_annotations_jsonpath ${TEXT_PATH} --val_features_lmdbpath ${FEAT_PATH} \
  --output_dir ${OUTPUT_DIR}
deactivate
