#!/bin/bash
#SBATCH --nodes=32
#SBATCH --partition=benchmark 
#SBATCH --job-name=install_run_
#SBATCH --output=logs/%x_%j.out  # Redirects outputs to file in current_dir/logs
#SBATCH --error=logs/%x_%j.out  # Redirects err to same file in current_dir/logs
# Load necessary modules (if any)
# module load <module_name> 

# Install required packages on all nodes
srun bash -c 'pip install torch numpy transformers datasets tokenizers wandb tqdm'

# Define the directory to run the commands
WORKING_DIR="/fsx/users/gautam/nanoGPT/"

MASTER_NODE_IP=None

# Run the commands on each node
for NODE_RANK in $(seq 0 1); do
    # Get the IP of the master node
    if [ $NODE_RANK -eq 0 ]; then
        MASTER_NODE_IP=$(hostname -i)
    fi
done

echo $MASTER_NODE_IP
echo hostname 
CMD="cd $WORKING_DIR && torchrun --nproc_per_node=8 --nnodes=32 --rdzv_endpoint=$MASTER_NODE_IP:29400 --rdzv_id=100 --rdzv_backend=c10d train.py"
echo "$CMD"
srun bash -c "cd $WORKING_DIR && torchrun --nproc_per_node=8 --nnodes=32 --rdzv_endpoint=$MASTER_NODE_IP:29400 --rdzv_id=100 --rdzv_backend=c10d train.py"

srun bash -c "hostname"
