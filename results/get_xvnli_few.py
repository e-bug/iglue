import os
import argparse
import numpy as np
import pandas as pd

TASK = "xvnli"
LANGS = ['ar', 'es', 'fr', 'ru']
SHOTS = [1, 5, 10, 20, 25, 48]


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--models', type=str)
    parser.add_argument('--exp_dir', type=str)
    parser.add_argument('--version', type=str, default=None)
    args = parser.parse_args()

    version = f".{args.version}" if args.version is not None else ""
    exp_dir = args.exp_dir + version
    
    models = args.models.split(",")
    for shot in SHOTS:
        res_df = pd.DataFrame(columns=['model']+LANGS+['avg'])
        for model in models:
            res = dict()
            res['model'] = model
            for lang in LANGS:
                fn = os.path.join(exp_dir, model, TASK, lang, str(shot), f"test.err")
                try:
                    line = [l.strip() for l in open(fn).readlines() if "Validation" in l][0]
                    val = float(line.split()[-1])
                except:
                    print(fn)
                    val = -1.0
                res[lang] = val
            avg = np.mean([res[lang] for lang in LANGS])
            res['avg'] = avg
            res_df = res_df.append(res, ignore_index=True)
        res_df.to_csv(f"{TASK}/XVNLI_{shot}{version}.csv", index=False)
