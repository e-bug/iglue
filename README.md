# IGLUE: The Image-Grounded Language Understanding Evaluation Benchmark

This is the implementation of the approaches described in the paper:
> Emanuele Bugliarello, Fangyu Liu, Jonas Pfeiffer, Siva Reddy, Desmond Elliott, Edoardo Maria Ponti, Ivan Vulić. [IGLUE: A Benchmark for Transfer Learning across Modalities, Tasks, and Languages](https://arxiv.org/abs/2201.11732). arXiv 2022; abs/2201.11732.

We provide the code for reproducing our results, preprocessed data and pretrained models.

IGLUE models and tasks will also be integrated into [VOLTA](https://github.com/e-bug/volta), upon which our repository was origally built.


## Repository Setup

To set the environment to reproduce our results, see "Repository Setup" in the [VOLTA's README](volta/README.md).


## Data

[`datasets/`](datasets) contains the textual data for each dataset.

Check out its [README](datasets/README.md) for links to preprocessed data  

Features extraction steps for each of dataset and backbone can be found under [`features_extraction/`](features_extraction). 


## Models

The checkpoints of all the pretrained V&L models can be downloaded from [ERDA](https://sid.erda.dk/sharelink/b1Rge0DwwW).

For more details on defining new models in VOLTA, see [`volta/MODELS.md`](volta/MODELS.md).

Model configuration files are stored in [`volta/config/`](volta/config). 


## Training and Evaluation

We provide the scripts we used to train and evaluate models in [`experiments/`](experiments):
- [`zero_shot/`](experiments/zero_shot): English fine-tuning and zero-shot/`translate test' evaluation
- [`few_shot/`](experiments/few_shot): Few-shot experiments for each dataset-language-shots triplet
- [`few_shot.dev-mt/`](experiments/few_shot.dev-mt): Few-shot experiments when using dev sets in the target languages (MT)
- [`translate_train.de/`](experiments/translate_train.de): `Translate train' experiments on xFLickr&CO in German
- [`translate_train.ja/`](experiments/translate_train.ja): `Translate train' experiments on xFLickr&CO in Japanese

Task configuration files are stored in [config_tasks/](config_tasks).


## License

This work is licensed under the MIT license. See [`LICENSE`](LICENSE) for details. 
Third-party software and data are subject to their respective licenses. <br>
If you find our code/data/models or ideas useful in your research, please consider citing the paper:
```
@article{bugliarello-etal-2022-iglue,
    title = "{IGLUE}: {A} Benchmark for Transfer Learning across Modalities, Tasks, and Languages",
    author="Bugliarello, Emanuele and 
        Liu, Fangyu and 
        Pfeiffer, Jonas and 
        Reddy, Siva and 
        Elliott, Desmond and 
        Ponti, Edoardo Maria and 
        Vuli{\'c}, Ivan",
    journal = "arXiv preprint arXiv:2201.11732"
    year = "2022",
    url = "https://arxiv.org/abs/2201.11732",
}
```
