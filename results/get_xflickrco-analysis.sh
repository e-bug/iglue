#!/bin/bash

#source /home/projects/ku_00062/envs/iglue/bin/activate

models="ctrl_xuniter,uc2"

exp_dir="../experiments/translate_train"
python get_xflickrco_translate-train.py --models $models --exp_dir $exp_dir

few_dir="../experiments/few_shot"
python get_xflickrco_many.py --models $models --exp_dir $few_dir

# deactivate
