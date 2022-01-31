import os
import argparse
import numpy as np
import pandas as pd

TASK = "xflickrco"
LANGS = ['en', 'de', 'es', 'id', 'ja', 'ru', 'tr', 'zh']


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--models', type=str)
    parser.add_argument('--exp_dir', type=str)
    parser.add_argument('--is_mt', action='store_true')
    args = parser.parse_args()

    models = args.models.split(",")
    res_ir_df = pd.DataFrame(columns=['model']+LANGS+['avg'])
    res_tr_df = pd.DataFrame(columns=['model']+LANGS+['avg'])
    for model in models:
        res_ir = dict()
        res_tr = dict()
        res_ir['model'] = model
        res_tr['model'] = model
        for lang in LANGS:
            fn = f"test.{lang}.out" if (not args.is_mt) or (lang == "en") else f"test.{lang}_mt.out"
            fn = os.path.join(args.exp_dir, model, TASK, fn)
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
        avg_ir = np.mean([res_ir[lang] for lang in LANGS[1:]])
        avg_tr = np.mean([res_tr[lang] for lang in LANGS[1:]])
        res_ir['avg'] = avg_ir
        res_tr['avg'] = avg_tr
        res_ir_df = res_ir_df.append(res_ir, ignore_index=True)
        res_tr_df = res_tr_df.append(res_tr, ignore_index=True)

    out_fn = "xFlickrCO_ir_0.csv" if not args.is_mt else "xFlickrCO_ir_0.mt.csv"
    res_ir_df.to_csv(f"{TASK}/{out_fn}", index=False)
    out_fn = "xFlickrCO_tr_0.csv" if not args.is_mt else "xFlickrCO_tr_0.mt.csv"
    res_tr_df.to_csv(f"{TASK}/{out_fn}", index=False)
