#!/bin/bash
echo "running cloudinit.sh script"


# Install needed packages
dnf -y install oraclelinux-developer-release-el8
dnf module -y install python39
alternatives --set python3 /usr/bin/python3.9
python3 -m pip install jupyter gradio

# Create models folder and download model in it
mkdir models
cd models/
python3 -m pip install -U "huggingface_hub[cli]"
huggingface-cli login --token ${hf_token}#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
huggingface-cli download hugging-quants/Meta-Llama-3.1-405B-Instruct-AWQ-INT4 --local-dir Meta-Llama-3.1-405B-Instruct-AWQ-INT4

# Install docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf remove -y runc
dnf install -y docker-ce --nobest
systemctl enable docker.service
dnf install -y nvidia-container-toolkit
systemctl start docker.service


# Config for Gradio
wget https://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64
mv frpc_linux_amd64 /usr/local/lib/python3.9/site-packages/gradio/frpc_linux_amd64_v0.2


#Set ports allowance
firewall-cmd --permanent --add-port=8888/tcp
firewall-cmd --permanent --add-port=7860/tcp
firewall-cmd —-reload



#sudo docker pull vllm/vllm-openai:latest
#nohup jupyter notebook --ip=0.0.0.0 --port=8888 > /home/opc/jupyter.log 2>&1 &
#cat /home/opc/jupyter.log
#sudo docker run --gpus all -v "/home/opc/models/Meta-Llama-3.1-405B-Instruct-AWQ-INT4:/mnt/model" -p 8000:8000 --env "TRANSFORMERS_OFFLINE=1" --env "HF_DATASETS_OFFLINE=1" --ipc=host vllm/vllm-openai:latest --tensor-parallel-size 8

