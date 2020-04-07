# https://www.pythonprogramming.in/generate-the-n-grams-for-the-given-sentence-using-nltk-or-textblob.html
# https://stackabuse.com/python-for-nlp-developing-an-automatic-text-filler-using-n-grams/

# ref
# https://www.jeddd.com/article/python-ngram-language-prediction.html
from collections import Counter

ngrams_list, prefix_list = [], []
words = ["hello worlds", "Nice to meet", "you how"]
n = len(words)
for word in words:
	sentence = ['<BOS>'] + word.split() + ['<EOS>']
	ngrams = list(zip(*[sentence[i:] for i in range(n)]))
	prefix = list(zip(*[sentence[i:] for i in range(n-1)]))
	ngrams_list += ngrams
	prefix_list += prefix

ngrams_counter = Counter(ngrams_list)
prefix_counter = Counter(prefix_list)

print(ngrams_counter)
print(prefix_counter)



# (w1 w2 w3) (w4 w5 w6 w7
# if scentence is completed
# https://cs.stackexchange.com/questions/33514/natural-language-parser-that-can-handle-syntactic-and-lexical-errors#33541

# ex0: LSTM: https://github.com/ottokart/punctuator/blob/master/src/trainer.py

# ex1/seperate scentence: http://bpraneeth.com/projects/deepsegment
# from deepsegment import DeepSegment
# # The default language is 'en'
# segmenter = DeepSegment('en')
# segmenter.segment('I am Batman i live in gotham')
# # ['I am Batman', 'i live in gotham']

# ex2/restore punctuation: http://bpraneeth.com/projects/deeppunct
# from deepcorrect import DeepCorrect
# corrector = DeepCorrect('params_path', 'checkpoint_path')
# corrector.correct('how are you')


# import nltk
# from nltk import CFG, load_parser
# sent = "Mary saw Bob".split()
# groucho_grammar = CFG.fromstring("""
# S -> NP VP
# PP -> P NP
# NP -> Det N | Det N PP | 'I'
# VP -> V NP | VP PP
# Det -> 'an' | 'my'
# N -> 'elephant' | 'pajamas'
# V -> 'shot'
# P -> 'in'
# """)

# parser = nltk.ChartParser(groucho_grammar)
# trees = parser.nbest_parse(sent)
# for tree in trees:
# 	print(tree)