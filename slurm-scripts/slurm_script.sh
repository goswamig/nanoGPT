#!/bin/bash
#SBATCH --nodes=50

# Install required packages on all nodes
srun --nodes=50 bash -c 'pip install torch numpy transformers datasets tokenizers wandb tqdm'

# Define the directory to run the commands
WORKING_DIR="/fsx/users/gautam/nanoGPT/"

# Run the commands on each node
for NODE_RANK in $(seq 0 49); do
    # Get the IP of the master node
    if [ $NODE_RANK -eq 0 ]; then
        MASTER_NODE_IP=$(hostname -i)
    fi

    # Run the command based on the node rank
    srun --nodes=1 --ntasks-per-node=1 --nodelist=$(scontrol show hostname $SLURM_NODELIST | head -n $((NODE_RANK+1)) | tail -n 1) \
        bash -c "cd $WORKING_DIR && torchrun --nproc_per_node=8 --nnodes=50 --node_rank=$NODE_RANK --master_addr=$MASTER_NODE_IP --master_port=1234 train.py"
done

