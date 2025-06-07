import tkinter as tk
import random

# connect to sonar 
import requests

def generate_embedding(text, server_url="http://127.0.0.1:5000"):
    #print(f"Generating embedding for text: {text}")
    """
    Sends a request to the server to generate an embedding for the given text.
    
    :param text: The input text to embed.
    :param server_url: The base URL of the server.
    :return: A list of floating-point numbers representing the embedding.
    """
    url = f"{server_url}/get_embedding"
    response = requests.post(url, json={"text": text})

    if response.status_code == 200:
        return response.json().get("embedding")#, [])
    else:
        raise Exception(f"Error {response.status_code}: {response.text}")

def reconstruct_text(embedding, server_url="http://127.0.0.1:5000"):
    """
    Sends a request to the server to reconstruct text from the given embedding.
    
    :param embedding: The input embedding to reconstruct text from.
    :param server_url: The base URL of the server.
    :return: The reconstructed text.
    """
    url = f"{server_url}/reconstruct_text"
    response = requests.post(url, json={"embedding": embedding})

    if response.status_code == 200:
        return response.json().get("text")#, "")
    else:
        raise Exception(f"Error {response.status_code}: {response.text}")
    



# GUI for assigning fitness
def fitness_gui(population):

    p = [reconstruct_text(ind) for ind in population]  # Convert embeddings to text

    fitness_scores = []

    def assign_fitness(index, score):
        fitness_scores.append(score)
        if len(fitness_scores) == len(p):
            root.destroy()

    root = tk.Tk()
    root.title("Assign Fitness")

    for i, individual in enumerate(p):
        frame = tk.Frame(root)
        frame.pack(pady=5)

        label = tk.Label(frame, text=f"Individual {i}: {individual}")
        label.pack(side=tk.LEFT, padx=5)

        button_0 = tk.Button(frame, text="0", command=lambda i=i: assign_fitness(i, 0))
        button_0.pack(side=tk.LEFT, padx=5)

        button_1 = tk.Button(frame, text="1", command=lambda i=i: assign_fitness(i, 1))
        button_1.pack(side=tk.LEFT, padx=5)

    root.mainloop()
    return fitness_scores



# initial ones 
init_texts = ['good afternoon', 'hello world', 'this is a test', 'how are you?', 'nice to meet you']  # Initial texts for embeddings

population = [generate_embedding(t) for t in init_texts]  # Generate initial embeddings from texts
#print(len(population[0]))

from custom_diff_evo import minimize 

bounds = [(-0.1,0.1) for _ in range(1024)]            # bounds [(x1_min, x1_max), (x2_min, x2_max),...]
popsize = 5                        # population size, must be >= 4
mutate = 0.5                        # mutation factor [0,2]
recombination = 0.7                 # recombination rate [0,1]
maxiter = 20                        # max number of generations

minimize(fitness_gui, bounds, popsize, mutate, recombination, maxiter, population)





