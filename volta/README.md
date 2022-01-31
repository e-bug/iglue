# VOLTA: Visiolinguistic Transformer Architectures

This is the implementation of the framework described in the paper:
> Emanuele Bugliarello, Ryan Cotterell, Naoaki Okazaki and Desmond Elliott. [Multimodal Pretraining Unmasked: A Meta-Analysis and a Unified Framework of Vision-and-Language BERTs](https://arxiv.org/abs/2011.15124). _Transactions of the Association for Computational Linguistics_ 2021; 9 978–994.

We provide the code for reproducing our results, preprocessed data and pretrained models.


## Repository Setup (IGLUE)

1\. Create a fresh virtual environment, and install all dependencies.
```text
python -m venv /path/to/iglue/virtual/environment
source /path/to/iglue/virtual/environment/bin/activate
pip install -r requirements.txt
```

2\. Install [apex](https://github.com/NVIDIA/apex).
If you use a cluster, you may want to first run commands like the following:
```text
module load cuda/10.1.105
module load gcc/8.3.0-cuda
```
and then:
```text
cd apex
pip install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
cd ..
```

3\. Setup the `refer` submodule for Referring Expression Comprehension:
```
cd tools/refer; make
```

4\. Install this codebase as a package in this environment.
```text
python setup.py develop
```

## Data

Check out [`data/README.md`](data/README.md) for links to preprocessed data and data preparation steps. 


## Models

Check out [`MODELS.md`](MODELS.md) for links to pretrained models and how to define new ones in VOLTA.

Model configuration files are stored in [config/](config). 


## Training and Evaluation

We provide sample scripts to train (i.e. pretrain or fine-tune) and evaluate models in [examples/](examples).
These include ViLBERT, LXMERT and VL-BERT as detailed in the original papers, 
as well as ViLBERT, LXMERT, VL-BERT, VisualBERT and UNITER as specified in our controlled study.

Task configuration files are stored in [config_tasks/](config_tasks).


## License

This work is licensed under the MIT license. See [`LICENSE`](LICENSE) for details. 
Third-party software and data sets are subject to their respective licenses. <br>
If you find our code/data/models or ideas useful in your research, please consider citing the paper:
```
@article{bugliarello-etal-2021-multimodal,
    author = {Bugliarello, Emanuele and Cotterell, Ryan and Okazaki, Naoaki and Elliott, Desmond},
    title = "{Multimodal Pretraining Unmasked: {A} Meta-Analysis and a Unified Framework of Vision-and-Language {BERT}s}",
    journal = {Transactions of the Association for Computational Linguistics},
    volume = {9},
    pages = {978-994},
    year = {2021},
    month = {09},
    issn = {2307-387X},
    doi = {10.1162/tacl_a_00408},
    url = {https://doi.org/10.1162/tacl\_a\_00408},
}
```


## Acknowledgement

Our codebase heavily relies on these excellent repositories:
- [vilbert-multi-task](https://github.com/facebookresearch/vilbert-multi-task)
- [vilbert_beta](https://github.com/jiasenlu/vilbert_beta)
- [lxmert](https://github.com/airsplay/lxmert)
- [VL-BERT](https://github.com/jackroos/VL-BERT)
- [visualbert](https://github.com/uclanlp/visualbert)
- [UNITER](https://github.com/ChenRocks/UNITER)
- [pytorch-transformers](https://github.com/huggingface/pytorch-transformers)
- [bottom-up-attention](https://github.com/peteanderson80/bottom-up-attention)
