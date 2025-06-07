from sonar.inference_pipelines.text import EmbeddingToTextModelPipeline, TextToEmbeddingModelPipeline
from fairseq2.generation import TopPSampler, TopKSampler
import torch 

embeddings = torch.rand((1,1024))/100 - 0.05 

embedder = TextToEmbeddingModelPipeline(
  encoder="text_sonar_basic_encoder", 
  tokenizer="text_sonar_basic_encoder", 
  device=torch.device("cuda"),
  dtype=torch.float16,
)
samp_emb = embedder.predict(
  ["My name is SONAR.", "I can embed the sentences into vector space."],
  source_lang="eng_Latn",
)

print("SAMP EMBS:") 
print(samp_emb[0]) 
print(samp_emb[1])
print(samp_emb[0].dtype)
print("MYEMB") 
print(embeddings)

samp_emb = [samp_emb[i].to(torch.float32) for i in range(len(samp_emb))]

vec2text_model = EmbeddingToTextModelPipeline(decoder="text_sonar_basic_decoder",
                                              tokenizer="text_sonar_basic_encoder")

reconstructed = vec2text_model.predict(embeddings, target_lang="eng_Latn", sampler=TopPSampler(0.99), max_seq_len=10)
# max_seq_len is a keyword argument passed to the fairseq2 BeamSearchSeq2SeqGenerator.
print("RECONSTRUCTED:")
print(reconstructed)
# ['My name is SONAR.', 'I can embed the sentences into vector space.']


print("SAMP RECONSTRUCTED:")
sreconstructed = vec2text_model.predict(samp_emb, target_lang="eng_Latn", sampler=TopPSampler(0.99), max_seq_len=10)
print(sreconstructed)


import pandas as pd 
import matplotlib.pyplot as plt
print("SAMP STATS:")
for i in range(len(samp_emb)): 
    print(i) 
    print(pd.Series(samp_emb[i].clone().detach().cpu().numpy()).describe())
    plt.hist(samp_emb[i].clone().detach().cpu().numpy(), bins=100)
    plt.show()

print("MYEMB:")
print(pd.Series(embeddings[0].clone().detach().cpu().numpy()).describe())
plt.hist(embeddings[0].clone().detach().cpu().numpy(), bins=100)
plt.show()


