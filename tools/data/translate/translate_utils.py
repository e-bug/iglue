import uuid
from enum import Enum

import numpy as np
import pandas as pd
import requests
from googletrans import Translator as GoogleTranslatorAPI
import six
from google.cloud import translate_v2 as translator


class Translator(Enum):
    GOOGLE = 'google'
    BING = 'bing'
    GOOGLE_CLOUD = 'google_cloud'
    OPUSMT = 'opus_mt'
    MBART50_EN2MULTILINGUAL = 'mbart50_en2m'
    M2M100_BIG = 'm2m100_big'


class GoogleTranslator():
    LANGUAGE_CODES_HEADER = "googletranslate"

    def translate(self, text, from_lang, to_lang):
        result = GoogleTranslatorAPI().translate(text,
                                                 src=from_lang,
                                                 dest=to_lang)
        return result.text


class BingTranslator():
    LANGUAGE_CODES_HEADER = "bing_BCP_47"
    BING_SUBSCRIPTION_KEY = ""
    BING_ENDPOINT = "https://api.cognitive.microsofttranslator.com/"

    def translate(self, text, from_lang, to_lang):
        path = '/translate?api-version=3.0'
        params = '&from={}&to={}'.format(from_lang, to_lang)
        constructed_url = BingTranslator.BING_ENDPOINT + path + params
        headers = {
            'Ocp-Apim-Subscription-Key': BingTranslator.BING_SUBSCRIPTION_KEY,
            'Content-type': 'application/json',
            'X-ClientTraceId': str(uuid.uuid4())
        }
        body = [{'text': text}]
        request = requests.post(constructed_url, headers=headers, json=body)
        response = request.json()
        return response[0]["translations"][0]["text"]


class GoogleCloudTranslator():
    """Translates text into the target language.

    Target must be an ISO 639-1 language code.
    See https://g.co/cloud/translate/v2/translate-reference#supported_languages
    """

    def translate(self, text, source, target):
        translate_client = translator.Client()
        if isinstance(text, six.binary_type):
            text = text.decode("utf-8")

        # Text can also be a sequence of strings, in which case this method
        # will return a sequence of results for each text.
        result = translate_client.translate(text, source_language=source, target_language=target)

        return result["translatedText"]


TRANSLATOR_TO_OBJECT = {
    Translator.GOOGLE: GoogleTranslator(),
    Translator.BING: BingTranslator(),
    Translator.GOOGLE_CLOUD: GoogleCloudTranslator(),
}
