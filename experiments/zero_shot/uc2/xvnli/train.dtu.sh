#!/bin/bash

TASK=19
MODEL=uc2
MODEL_CONFIG=uc2_base
TASKS_CONFIG=iglue_trainval_tasks_boxes36.dtu
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/pretrain/${MODEL}/${MODEL_CONFIG}/uc2_checkpoint_200000.bin
OUTPUT_DIR=/home/projects/ku_00062/checkpoints/iglue/zero_shot/xvnli/${MODEL}
LOGGING_DIR=/home/projects/ku_00062/logs/iglue/xvnli/${MODEL_CONFIG}

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python train_task.py \
  --bert_model /home/projects/ku_00062/huggingface/xlm-roberta-base --config_file config/${MODEL_CONFIG}.json \
  --from_pretrained ${PRETRAINED} \
  --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --gradient_accumulation_steps 4 \
  --adam_epsilon 1e-6 --adam_betas 0.9 0.999 --adam_correct_bias --weight_decay 0.0001 --warmup_proportion 0.1 --clip_grad_norm 1.0 \
  --output_dir ${OUTPUT_DIR} \
  --logdir ${LOGGING_DIR} \
deactivate
