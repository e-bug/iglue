import time
import argparse
import json
from tqdm import tqdm

from translate_utils import TRANSLATOR_TO_OBJECT, Translator


LANG_MAP = {"zh": "zh-cn"}


def get_text(filename, field_name):
    items = json.load(open(filename))
    texts = [items[k][field_name] for k in items]
    return items, texts


def save_text(items, sentences, filename, field_name):
    for ix, k in enumerate(items):
        items[k][field_name] = sentences[ix]
    with open(filename, 'w') as f:
        json.dump(items, f)


def main(args):
    if args.engine == 'google':
        engine = Translator.GOOGLE
    elif args.engine == 'bing':
        engine = Translator.BING
    elif args.engine == 'google_cloud':
        engine = Translator.GOOGLE_CLOUD
    in_lang = LANG_MAP.get(args.in_lang, args.in_lang)
    out_lang = LANG_MAP.get(args.out_lang, args.out_lang)
    items, source_texts = get_text(args.in_file, args.field_name)
    translator = TRANSLATOR_TO_OBJECT[engine]
    target_texts = []
    for text in tqdm(source_texts, total=len(source_texts)):
        time.sleep(0.2)
        output = translator.translate(text, in_lang, out_lang)
        target_texts.append(output)
    save_text(items, target_texts, args.out_file, args.field_name)


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
