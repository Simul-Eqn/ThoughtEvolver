#interpolate(args, ada_config, AdaVAE, tokenizer, device, batch,
#                                             num_interpolation_steps=args.num_interpolation_step)

import torch 

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

from adavae_utils import sample_sequence, init_para_frompretrained 
from adavae_stuff import AdapterConfig 
from adavae_vae import AdaVAEModel
from transformers import GPT2LMHeadModel, GPT2Tokenizer, GPT2Config 
import numpy as np 

seed = 10 



tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
gpt2_model = GPT2LMHeadModel.from_pretrained('gpt2')
tokenizer.pad_token = tokenizer.eos_token
# randomness
np.random.seed(seed)
prng = np.random.RandomState()
torch.random.manual_seed(seed)
if torch.cuda.is_available():
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
config = GPT2Config()
ada_config = AdapterConfig(hidden_size=768,
                            adapter_size=128,#args.adapter_size,
                            adapter_act='relu',
                            adapter_initializer_range=1e-2,
                            latent_size=32,#args.latent_size,
                            class_num=2,#args.class_num,
                            encoder_n_layer=8,#args.encoder_n_layer,
                            decoder_n_layer=12,#args.decoder_n_layer,
                            dis_emb=128, # hidden dimension for adversarial KLD discriminator
                            init='other',
                            adapter_scalar=1.0, #args.adapter_scalar,
                            ffn_option='parallel_ffn',#args.ffn_option,
                            attn_mode='none',#args.attn_mode,
                            latent_gen='latent_attn',#args.latent_gen,
                            attn_option='none',
                            mid_dim=30,
                            attn_bn=25,
                            prefix_dropout=0.1,
                            tune_enc=False,#args.finetune_enc,
                            tune_dec=False,#args.finetune_dec,
                            add_z2adapters=False,#args.add_z2adapters
                            )
AdaVAE = AdaVAEModel(config, ada_config, add_input=False, add_attn=False, add_softmax=False, add_mem=False,
                attn_proj_vary=False, learn_prior=False, reg_loss='kld')
## load pre-trained weights
init_para_frompretrained(AdaVAE.transformer, gpt2_model.transformer, share_para=False)
init_para_frompretrained(AdaVAE.encoder, gpt2_model.transformer, share_para=False)
AdaVAE.lm_head.weight = gpt2_model.lm_head.weight



def decode_adavae(latent_z, max_length=10): 

    endoftext = tokenizer.convert_tokens_to_ids("<|endoftext|>") 
    top_k=100 
    top_p=0.5

    sents, _ = sample_sequence(AdaVAE, max_length, latent_z.to(device),
                                        batch_size=1, top_k=top_k, top_p=top_p,
                                        device=device, sample=True, eos_token=endoftext)
    # Sample sentences
    sents = sents.tolist()
    sentences_list = []
    ## bsz == 1 only sample 1 sentence for each interpolation step
    sent = sents[0]
    sent = sent[sent.index(endoftext) + 1:]

    if endoftext in sent:
        idx = sent.index(endoftext)
        sent = sent[:idx]

    sent = tokenizer.decode(sent).strip()
    return sent


if __name__=="__main__": 
    print(decode_adavae(torch.rand((1,32))))