#!/bin/bash
#SBATCH --nodes=50

# Install required packages on all nodes
echo $(hostname -i)
srun --nodes=50 bash -c 'pip install torch numpy transformers datasets tokenizers wandb tqdm'

