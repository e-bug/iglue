#!/bin/bash

#source /home/projects/ku_00062/envs/iglue/bin/activate

zero_dir="../experiments/zero_shot"

models="ctrl_muniter,ctrl_xuniter,uc2,m3p"
python get_marvl_zero.py --models $models --exp_dir $zero_dir
python get_marvl_zero-id_tr_zh.py --models $models --exp_dir $zero_dir

models="ctrl_muniter,ctrl_xuniter,uc2,m3p,ctrl_lxmert,ctrl_uniter,ctrl_vilbert,ctrl_visualbert,ctrl_vl-bert"
python get_marvl_zero.py --models $models --exp_dir $zero_dir --is_mt
python get_marvl_zero-id_tr_zh.py --models $models --exp_dir $zero_dir --is_mt

few_dir="../experiments/few_shot"

models="ctrl_muniter,ctrl_xuniter,uc2,m3p"
python get_marvl_few.py --models $models --exp_dir $few_dir

# deactivate
