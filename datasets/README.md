# Datasets

### Text
The textual data of each dataset in our benchmark can be found here.

### Images
The raw images can be downloaded from the original websites:
- [COCO 2014 Val](https://cocodataset.org/#download)
- [Flickr30K](https://www.kaggle.com/hsankesara/flickr-image-dataset)
- [GQA](https://cs.stanford.edu/people/dorarad/gqa/download.html)
- [MaRVL](https://dataverse.scholarsportal.info/dataset.xhtml?persistentId=doi:10.5683/SP3/42VZ4P)
- [NLVR2](https://github.com/lil-lab/nlvr/tree/master/nlvr2#direct-image-download)

We are trying to define Terms of Use that will allow us to collect and re-distribute all the images used in IGLUE in a single site.

### Image Features
We also provide access to our processed image data (i.e. image features):
- [Flickr30K](https://sid.erda.dk/sharelink/aW8MWVSlK1)
- [GQA](https://sid.erda.dk/sharelink/FtoWxwitOz)
- [MaRVL zero-shot](https://sid.erda.dk/sharelink/GYPEryxpVk) | [MaRVL few-shot](https://sid.erda.dk/sharelink/fMNmRmJgQA)
- [NLVR2](https://sid.erda.dk/sharelink/FjJUsFbRWO)
- [xFlickr&CO](https://sid.erda.dk/sharelink/cCObmVenjI)
- [WIT](https://sid.erda.dk/sharelink/escPrWm3Tt)

As the size of `lmdb` directories increased significantly upon upload, 
we release the `H5` (36 boxes, ResNet-101) and (compressed) directories of `npy` files (10-100 boxes, ResNeXt-101).
After donwloading them, you can convert them into LMDB format by executing the [`h5_to_lmdb`](../features_extraction/h5_to_lmdb.py) or [`npy_to_lmdb`](../features_extraction/npy_to_lmdb.py) scripts.

You can find the scripts for features extraction under [`features_extraction/`](../features_extraction).
