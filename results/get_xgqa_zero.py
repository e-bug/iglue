import os
import argparse
import numpy as np
import pandas as pd

TASK = "xgqa"
LANGS = ['en', 'bn', 'de', 'id', 'ko', 'pt', 'ru', 'zh']


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--models', type=str)
    parser.add_argument('--exp_dir', type=str)
    parser.add_argument('--is_mt', action='store_true')
    args = parser.parse_args()

    models = args.models.split(",")
    res_df = pd.DataFrame(columns=['model']+LANGS+['avg'])
    for model in models:
        res = dict()
        res['model'] = model
        for lang in LANGS:
            fn = f"test.{lang}.out" if (not args.is_mt) or (lang == "en") else f"test.{lang}_mt.out"
            fn = os.path.join(args.exp_dir, model, TASK, fn)
            try:
                line = open(fn).readlines()[-1].strip()
                val = float(line)
            except:
                print(fn)
                val = -1.0
            res[lang] = val
        avg = np.mean([res[lang] for lang in LANGS[1:]])
        res['avg'] = avg
        res_df = res_df.append(res, ignore_index=True)

    out_fn = "xGQA_0.csv" if not args.is_mt else "xGQA_0.mt.csv"
    res_df.to_csv(f"{TASK}/{out_fn}", index=False)
