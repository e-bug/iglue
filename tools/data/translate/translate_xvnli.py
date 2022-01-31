import time
import argparse
import jsonlines
from tqdm import tqdm

from translate_utils import TRANSLATOR_TO_OBJECT, Translator


LANG_MAP = {"zh": "zh-cn"}


def get_text(filename):
    items = [item for item in jsonlines.open(filename)]
    texts1 = [item["sentence1"] for item in items]
    texts2 = [item["sentence2"] for item in items]
    return items, texts1, texts2


def save_text(items, sentences1, sentences2, filename):
    for ix, sent1 in enumerate(sentences1):
        items[ix]["sentence1"] = sent1
        items[ix]["sentence2"] = sentences2[ix]
    with jsonlines.open(filename, 'w') as writer:
        writer.write_all(items)


def main(args):
    if args.engine == 'google':
        engine = Translator.GOOGLE
    elif args.engine == 'bing':
        engine = Translator.BING
    elif args.engine == 'google_cloud':
        engine = Translator.GOOGLE_CLOUD
    in_lang = LANG_MAP.get(args.in_lang, args.in_lang)
    out_lang = LANG_MAP.get(args.out_lang, args.out_lang)
    items, source_texts1, source_texts2 = get_text(args.in_file)
    translator = TRANSLATOR_TO_OBJECT[engine]
    target_texts1 = []
    for text in tqdm(source_texts1, total=len(source_texts1)):
        output = translator.translate(text, in_lang, out_lang)
        target_texts1.append(output)
    target_texts2 = []
    for text in tqdm(source_texts2, total=len(source_texts2)):
        output = translator.translate(text, args.in_lang, args.out_lang)
        target_texts2.append(output)
    save_text(items, target_texts1, target_texts2, args.out_file)


if __name__ == "__main__":
  
  parser = argparse.ArgumentParser()
  parser.add_argument("--in_file", help="path to the model for evaluation", default="example.txt")
  parser.add_argument("--out_file", help="path to the model for evaluation", default="example.txt")
  parser.add_argument("--engine", help="Translation API", choices=["google", "bing", "google_cloud"], default="google_cloud")
  parser.add_argument("--in_lang", help="Language to translate from", default="en")
  parser.add_argument("--out_lang", help="Language to translate into", default="es")
  parser.add_argument("--field_name", help="caption field name", default="caption")
  args = parser.parse_args()
  main(args)
