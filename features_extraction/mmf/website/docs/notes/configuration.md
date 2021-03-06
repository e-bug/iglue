---
id: configuration
title: MMF's Configuration System
sidebar_label: Configuration System
---

MMF relies on [OmegaConf](https://omegaconf.readthedocs.io/en/latest/) for its configuration system and adds some sugar on top of it. We have developed MMF as a config-first framework. Most of the parameters/settings in MMF are configurable. MMF defines some default configuration settings for its system including datasets and models. Users can then update these values via their own config or a command line dotlist.

**TL;DR**

- MMF uses OmegaConf for its configuration system with some sugar on top.
- MMF defines [base defaults config](#base-defaults-config) containing all MMF specific parameters and then each dataset and model define their own configs (example configs: [[model]](https://github.com/facebookresearch/mmf/blob/master/mmf/configs/models/mmbt/defaults.yaml) [[dataset]](https://github.com/facebookresearch/mmf/blob/master/mmf/configs/datasets/hateful_memes/defaults.yaml)).
- The user can define its own config specified by `config=<x>` at command line for each unique experiment or training setup. This has higher priority then base, model and dataset default configs and can override anything in those.
- Finally, user can override (highest priority) the final config generated by merge of all above configs by specifying config parameters as [dotlist](https://omegaconf.readthedocs.io/en/latest/usage.html#from-a-dot-list) in their command. This is the **recommended** way of overriding the config parameters in MMF.
- How MMF knows which config to pick for dataset and model? The user needs to specify those in his command as `model=x` and `dataset=y`.
- Some of the MMF config parameters under `env` field can be overridden by environment variable. Have a look at them.

## OmegaConf

For understanding and using the MMF configuration system to its full extent having a look at [OmegaConf docs](https://omegaconf.readthedocs.io/en/latest/) especially the sections on [interpolation](https://omegaconf.readthedocs.io/en/latest/usage.html#variable-interpolation), [access](https://omegaconf.readthedocs.io/en/latest/usage.html#access-and-manipulation) and [configuration flags](https://omegaconf.readthedocs.io/en/latest/usage.html#configuration-flags). MMF's config currently is by default in struct mode and we plan to make it readonly in future.

## Hierarchy

MMF follows set hierarchy rules to determine the final configuration values. Following list shows the building blocks of MMF's configuration in an increasing order of priority (higher rank will override lower rank).

- [Base Defaults Config](#base-defaults-config)
- Dataset's Config (defined in dataset's `config_path` classmethod)
- Model's Config (defined in model's `config_path` classmethod)
- User's Config (Passed by user as `config=x` in command)
- Command Line DotList (Passed by user as `x.y.z=v` dotlist in command)

:::tip

Configs other than base defaults can still add new nodes that are not in base defaults config, so user can add their own config parameters if they need to without changing the base defaults. If a node has same path, nodes in higher priority config will override the lower priority nodes.

:::

## Base Defaults

Full base defaults config can be seen [below](#base-defaults-config). This config is base of MMF's configuration system and is included in all of the experiments. It sets up nodes for training related configuration and those that need to be filled by other configs which are specified by user. Main configuration parameters that base defaults define:

- training parameters
- distributed training parameters
- env parameters
- evaluation parameters
- checkpoint parameters
- run_type parameters

## Dataset Config

Each dataset [registered](https://mmf.sh/api/lib/common/registry.html) to MMF can define its defaults config by specifying it in classmethod `config_path` ([example](https://github.com/facebookresearch/mmf/blob/ae1689c0e2f9d8f51f337676495057168751c5ea/mmf/datasets/builders/ocrvqa/builder.py#L15)). If `processors` key whose value is a dictionary is specified, processors will be initialized by the dataset builder. If dataset builder inherits from MMFDatasetBuilder, it will look for `annotations`, `features` and `images` field as well in the configuration. A sample config for a builder inheriting MMFDatasetBuilder would look like:

```yaml
dataset_config:
  dataset_registry_key:
    use_images: true
    use_features: true
    annotations:
      train:
        - ...
      val:
        - ...
      test:
        - ...
    images:
      train:
        - ...
      val:
        - ...
      test:
        - ...
    features:
      train:
        - ...
      val:
        - ...
      test:
        - ...
    processors:
      text_processor:
        type: x
        params: ...
```

Configs for datasets packages with MMF are present at [mmf/configs/datasets](https://github.com/facebookresearch/mmf/tree/ae1689c0e2f9d8f51f337676495057168751c5ea/mmf/configs/datasets). Each dataset also provides composable configs which can be used to use some different from default but standard variation of the datasets. These can be directly included into user config by using [includes](#includes) directive.

User needs to specify the dataset they are using by adding `dataset=<dataset_key>` option to their command.

## Model Config

Similar to dataset config, each model [registered](https://mmf.sh/api/lib/common/registry.html) to MMF can define its config. this is defined by model's `config_path` classmethod ([example](https://github.com/facebookresearch/mmf/blob/ae1689c0e2f9d8f51f337676495057168751c5ea/mmf/models/cnn_lstm.py#L40)). Configs for models live at [mmf/configs/models](https://github.com/facebookresearch/mmf/tree/ae1689c0e2f9d8f51f337676495057168751c5ea/mmf/configs/models). Again, like datasets models also provide some variations which can be used by including configs for those variations in the user config.

User needs to specify the model they want to use by adding `model=<model_key>` option to their command. A sample model config would look like:

```yaml
model_config:
  model_key:
    random_module: ...
```

## User Config

User can specify their configuration specific to an experiment or training setup by adding `config=<config_path>` argument to their command. User config can specify for e.g. training parameters according to their experiment such as batch size using `training.batch_size`. Most common use case for user config is to specify optimizer, scheduler and training parameters. Other than that user config can also include configs for variations of models and datasets they want to test on. Have a look at an example user config [here](https://github.com/facebookresearch/mmf/blob/master/projects/hateful_memes/configs/mmbt/defaults.yaml).

## Command Line Dot List Override

Updating the configuration through [dot list](https://omegaconf.readthedocs.io/en/latest/usage.html#from-a-dot-list) syntax is very helpful when running multiple versions of an experiment without actually updating a config. For example, to override batch size from command line you can add `training.batch_size=x` at the end of your command. Similarly, for overriding an annotation in the hateful memes dataset, you can do `dataset_config.hateful_memes.annotations.train[0]=x`.

:::tip

Command Line Dot List overrides are our recommended way of updating config parameters instead of manually updating them in config for every other change.

:::

## Includes

MMF's configuration system on top of OmegaConf allows building user configs by including composable configs provided by the datasets and models. You can include it following the syntax

```yaml
includes:
  - path/to/first/yaml/to/be/included.yaml
  - second.yaml
```

The configs will override in the sequence of how they appear in the directive. Finally, the config parameters defined in the current config will override what is present in the includes. So, for e.g.

First file, `a.yaml`:

```yaml
# a.yaml
dataset_config:
  hateful_memes:
    max_features: 80
    use_features: true
  vqa2:
    use_features: true

model_config:
  mmbt:
    num_classes: 4
    features_dim: 2048
```

Second file, `b.yaml`:

```yaml
# b.yaml
optimizer:
  type: adam

dataset_config:
  hateful_memes:
    max_features: 90
    use_features: false
    use_images: true
  vqa2:
    depth_first: false
```

And final user config, `user.yaml`:

```yaml
# user.yaml
includes:
  - a.yaml
  - b.yaml

dataset_config:
  hateful_memes:
    max_features: 100
  vqa2:
    annotations:
      train: x.npy

model_config:
  mmbt:
    num_classes: 2
```

would result in final config:

```yaml
dataset_config:
  hateful_memes:
    max_features: 100
    use_features: false
    use_images: true
  vqa2:
    use_features: true
    depth_first: false
    annotations:
      train: x.npy

model_config:
  mmbt:
    num_classes: 2
    features_dim: 2048

optimizer:
  type: adam
```

## Other overrides

We also support some useful overrides schemes at the same level of command line dot list override. For example, user can specify their overrides in form of [demjson](https://pypi.org/project/demjson/) as value to argument `--config_override` which will them override each part of config accordingly. To use this feature, you will need to install `demjson` package.

## Environment Variables

MMF supports overriding some of the config parameters through environment variables. Have a look at them in [base default config](#base-defaults-config)'s `env` parameters.

## Base Defaults Config

Have a look at the [defaults config of MMF](https://github.com/facebookresearch/mmf/blob/master/mmf/configs/defaults.yaml) along with description of parameters from which you may need to override parameters for your experiments.
