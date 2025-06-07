from sonar.inference_pipelines.text import EmbeddingToTextModelPipeline, TextToEmbeddingModelPipeline
from fairseq2.generation import TopPSampler, TopKSampler
import torch 

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

embedder = TextToEmbeddingModelPipeline(
  encoder="text_sonar_basic_encoder", 
  tokenizer="text_sonar_basic_encoder", 
  device=device,
  dtype=torch.float16,
)

vec2text_model = EmbeddingToTextModelPipeline(decoder="text_sonar_basic_decoder",
                                              tokenizer="text_sonar_basic_encoder", 
                                              device=device, 
                                              dtype=torch.float16)



def generate_embedding(text):
    return embedder.predict(
        [text],
        source_lang="eng_Latn",
    )[0].tolist() 
    


def reconstruct_text(embedding):
    return vec2text_model.predict(
        [torch.tensor(embedding, device=device, dtype=torch.float16)], 
        target_lang="eng_Latn", sampler=TopPSampler(0.99), max_seq_len=10)


# test it out 
if __name__ == "__main__":
    text = "This is a test sentence."
    embedding = generate_embedding(text)
    print("Generated Embedding:", embedding)

    reconstructed_text = reconstruct_text(embedding)
    print("Reconstructed Text:", reconstructed_text)
