import torch
from torch import nn
from transformers import GPT2LMHeadModel, GPT2Tokenizer

# Setup
device = "cuda" if torch.cuda.is_available() else "cpu"
tokenizer = GPT2Tokenizer.from_pretrained("gpt2")
gpt2 = GPT2LMHeadModel.from_pretrained("gpt2").to(device)
gpt2.eval()




# Example input: your embedding (replace this with your real vector)
embedding = torch.randn(1, 5, 768).to(device)


# Dummy input to GPT2 to satisfy generation interface
dummy_input = tokenizer("<eos>", return_tensors="pt").input_ids.to(device)
print(dummy_input)
dummy_embed = gpt2.transformer.wte(dummy_input)

# Combine: [projected vector as prefix] + [dummy token]
full_input = torch.cat([embedding, dummy_embed], dim=1)

# Generate
with torch.no_grad():
    output = gpt2.generate(inputs_embeds=full_input, max_new_tokens=50, do_sample=True, top_p=0.95)

# Decode and print
print(tokenizer.decode(output[0], skip_special_tokens=True))
