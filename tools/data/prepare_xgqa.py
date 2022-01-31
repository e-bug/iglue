import json
import pickle

basedir = "/home/projects/ku_00062/data/xGQA/few_shot/"

ans2label = pickle.load(open("/home/projects/ku_00062/data/gqa/annotations/trainval_ans2label.pkl", "rb"))

def preprocess(fn):
    j = json.load(open(fn))
    l = []
    for question_id, d in j.items():
        if d['answer'] not in ans2label:
            print(fn.split("/")[-2:], question_id, d['answer'])
        else:
            r = {
                'image_id': d['imageId'],
                'labels': [ans2label[d['answer']]],
                'scores': [1.0],
                'question_id': question_id,
                'question': d['question']
            }
            l.append(r)
    return l


for lang in ["bn", "de", "en", "id", "ko", "pt", "ru", "zh"]:
    # dev
    fn = basedir + lang + f"/dev.json"
    res = preprocess(fn)
    with open(basedir + lang + f"/dev.pkl", "wb") as f:
        pickle.dump(res, f)
    # train
    for shot in [1, 5, 10, 10, 20, 25, 48]:
        fn = basedir + lang + f"/train_{shot}.json"
        res = preprocess(fn)
        with open(basedir + lang + f"/train_{shot}.pkl", "wb") as f:
            pickle.dump(res, f)
