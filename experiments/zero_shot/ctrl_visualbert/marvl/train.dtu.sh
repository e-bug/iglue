#!/bin/bash

TASK=12
MODEL=ctrl_visualbert
MODEL_CONFIG=ctrl_visualbert_base
TASKS_CONFIG=iglue_trainval_tasks_boxes36.dtu
PRETRAINED=/home/projects/ku_00062/checkpoints/iglue/pretrain/${MODEL}/${MODEL_CONFIG}/pytorch_model_9.bin
OUTPUT_DIR=/home/projects/ku_00062/checkpoints/iglue/zero_shot/marvl/${MODEL}
LOGGING_DIR=/home/projects/ku_00062/logs/iglue/marvl/${MODEL_CONFIG}

source /home/projects/ku_00062/envs/iglue/bin/activate

cd ../../../../volta
python train_task.py \
    --bert_model /home/projects/ku_00062/huggingface/bert-base-uncased --do_lower_case --config_file config/${MODEL_CONFIG}.json \
    --from_pretrained ${PRETRAINED} --cache 500 \
    --tasks_config_file config_tasks/${TASKS_CONFIG}.yml --task $TASK --gradient_accumulation_steps 2 --num_workers 10 --num_val_workers 10\
    --adam_epsilon 1e-6 --adam_betas 0.9 0.999 --adam_correct_bias --weight_decay 0.0001 --warmup_proportion 0.1 --clip_grad_norm 1.0 \
    --output_dir ${OUTPUT_DIR} \
    --logdir ${LOGGING_DIR} \
#    --resume_file ${OUTPUT_DIR}/RetrievalFlickr30k_${MODEL_CONFIG}/pytorch_ckpt_latest.tar

deactivate
