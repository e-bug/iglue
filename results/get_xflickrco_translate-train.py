import os
import argparse
import numpy as np
import pandas as pd

TASK = "xflickrco"
LANGS = ['de', 'ja']


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--models', type=str)
    parser.add_argument('--exp_dir', type=str)
    args = parser.parse_args()

    models = args.models.split(",")
    res_ir_df = pd.DataFrame(columns=['model']+LANGS)
    res_tr_df = pd.DataFrame(columns=['model']+LANGS)
    for model in models:
        res_ir = dict()
        res_tr = dict()
        res_ir['model'] = model
        res_tr['model'] = model
        for lang in LANGS:
            fn = os.path.join(args.exp_dir + f".{lang}", model, TASK, f"test.{lang}.out")
            try:
                lines = [l.strip() for l in open(fn).readlines() if l.startswith("Final")] #[-1]
                ir1 = float(lines[-2].split()[1].split(",")[0].split(':')[1])
                tr1 = float(lines[-1].split()[1].split(",")[0].split(':')[1])
                # val = (ir1 + tr1) / 2
                # res[lang] = val
                res_ir[lang] = ir1
                res_tr[lang] = tr1
            except:
                print(fn)
                # print(model, TASK, fn)
                res_ir[lang] = -1.0
                res_tr[lang] = -1.0
        # avg = np.mean([res[lang] for lang in LANGS[1:]])
        # avg_ir = np.mean([res_ir[lang] for lang in LANGS[1:]])
        # avg_tr = np.mean([res_tr[lang] for lang in LANGS[1:]])
        # res_ir['avg'] = avg_ir
        # res_tr['avg'] = avg_tr
        res_ir_df = res_ir_df.append(res_ir, ignore_index=True)
        res_tr_df = res_tr_df.append(res_tr, ignore_index=True)

    out_fn = "xFlickrCO_ir_0.translate-train.csv"
    res_ir_df.to_csv(f"{TASK}/{out_fn}", index=False)
    out_fn = "xFlickrCO_tr_0.translate-train.csv"
    res_tr_df.to_csv(f"{TASK}/{out_fn}", index=False)
