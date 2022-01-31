#!/bin/bash

FAMILY=joint
MODEL=ctrl_xuniter
MODEL_CONFIG=ctrl_xuniter_base
DATA=/science/image/nlp-datasets/emanuele/data
ANNOS=$DATA/conceptual_captions/annotations
WIKIS=$DATA/wikipedia/txt
FEATS=$DATA/conceptual_captions/resnet101_faster_rcnn_genome_imgfeats/volta
OUTPUT_DIR=/science/image/nlp-datasets/emanuele/checkpoints/mc-bert/${FAMILY}/${MODEL}/conceptual_captions_wikipedia
LOGGING_DIR=$HOME/projects/mc-bert/logs/${FAMILY}/${MODEL_CONFIG}/conceptual_captions_wikipedia

source activate /science/image/nlp-datasets/emanuele/envs/mc-bert

cd ../../../../code/volta
python train_concap_wiki.py \
  --bert_model xlm-roberta-base --config_file config/${MODEL_CONFIG}.json \
  --train_x_batch_size 256 --train_m_batch_size 256 --gradient_accumulation_steps 4 \
  --max_x_seq_length 66 --max_m_seq_length 66 --m_pretrained xlm-roberta-base \
  --learning_rate 1e-4 --adam_epsilon 1e-6 --adam_betas 0.9 0.999 --weight_decay 0.01 --warmup_proportion 0.1 --clip_grad_norm 5.0 \
  --objective 1 \
  --annotations_path $ANNOS --features_path $FEATS \
  --dataroot $WIKIS --lgs ALL --lg_sampling_factor 0.7 \
  --output_dir ${OUTPUT_DIR} \
  --logdir ${LOGGING_DIR} \
  --num_train_epochs 10 \
  --resume_file ${OUTPUT_DIR}/${MODEL_CONFIG}/pytorch_ckpt_latest.tar

conda deactivate
