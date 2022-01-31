import os
import argparse
import numpy as np
import pandas as pd

TASK = "xflickrco"
LANGS = ['de', 'ja']
SHOTS = [200, 500, 1000, 1500, '100x5', '200x5']


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
        res_ir_df = pd.DataFrame(columns=['model']+LANGS)
        res_tr_df = pd.DataFrame(columns=['model']+LANGS)
        for model in models:
            res_ir = dict()
            res_tr = dict()
            res_ir['model'] = model
            res_tr['model'] = model
            for lang in LANGS:
                fn = os.path.join(exp_dir, model, TASK, lang, str(shot), f"test.out")
                try:
                    lines = [l.strip() for l in open(fn).readlines() if l.startswith("Final")] #[-1]
                    ir1 = float(lines[-2].split()[1].split(",")[0].split(':')[1])
                    tr1 = float(lines[-1].split()[1].split(",")[0].split(':')[1])
                    res_ir[lang] = ir1
                    res_tr[lang] = tr1
                except:
                    print(fn)
                    res_ir[lang] = -1.0
                    res_tr[lang] = -1.0

            # avg_ir = np.mean([res_ir[lang] for lang in LANGS])
            # avg_tr = np.mean([res_tr[lang] for lang in LANGS])
            # res_ir['avg'] = avg_ir
            # res_tr['avg'] = avg_tr
            res_ir_df = res_ir_df.append(res_ir, ignore_index=True)
            res_tr_df = res_tr_df.append(res_tr, ignore_index=True)
            
        res_ir_df.to_csv(f"{TASK}/xFlickrCO-many_ir_{shot}{version}.csv", index=False)
        res_tr_df.to_csv(f"{TASK}/xFlickrCO-many_tr_{shot}{version}.csv", index=False)
