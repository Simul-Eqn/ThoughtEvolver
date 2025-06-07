from sonar.inference_pipelines.text import EmbeddingToTextModelPipeline
import torch 

embeddings = torch.rand((1,1024))

vec2text_model = EmbeddingToTextModelPipeline(decoder="text_sonar_basic_decoder",
                                              tokenizer="text_sonar_basic_encoder")

reconstructed = vec2text_model.predict(embeddings, target_lang="eng_Latn", max_seq_len=512)
# max_seq_len is a keyword argument passed to the fairseq2 BeamSearchSeq2SeqGenerator.
print(reconstructed)
# ['My name is SONAR.', 'I can embed the sentences into vector space.']