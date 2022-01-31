import jsonlines

basedir = "/home/projects/ku_00062/data/XVNLI/annotations/"

few_imgs = [l.strip() for l in open(basedir+"few_imgs.lst").readlines()]

for lang in ['ar', 'en', 'es', 'fr', 'ru']:
    orig = [item for item in jsonlines.open(basedir+lang+"/old/test.jsonl")]
    
    test = [item for item in orig if item['Flikr30kID'] not in few_imgs]
    with jsonlines.open(basedir+lang+"/test.jsonl", "w") as writer:
        writer.write_all(test)

    for shot in [1, 5, 10, 20, 25, 48]:
        imgs = few_imgs[:shot]
        train = [item for item in orig if item['Flikr30kID'] in imgs]
        with jsonlines.open(basedir+lang+f"/train_{shot}.jsonl", "w") as writer:
            writer.write_all(train)
