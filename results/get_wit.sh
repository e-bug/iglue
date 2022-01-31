#!/bin/bash

# source /home/projects/ku_00062/envs/iglue/bin/activate

zero_dir="../experiments/zero_shot"

models="ctrl_muniter,ctrl_xuniter,uc2,m3p"
python get_wit_zero.py --models $models --exp_dir $zero_dir

models="ctrl_muniter,ctrl_xuniter,uc2,m3p,ctrl_lxmert,ctrl_uniter,ctrl_vilbert,ctrl_visualbert,ctrl_vl-bert"
python get_wit_zero.py --models $models --exp_dir $zero_dir --is_mt

# deactivate
