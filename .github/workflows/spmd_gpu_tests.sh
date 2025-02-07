#!/bin/bash

set -x

# Print test options
echo "VERBOSE: ${VERBOSE}"
echo "SHARD: ${SHARD}"

nvidia-smi
nvcc --version
cat /etc/os-release
which python3
python3 --version
which pip3
pip3 --version

# Install dependencies
# Turn off progress bar to save logs
pip3 install --upgrade pip
if [ -f spmd/requirements.txt ]; then pip3 install -r spmd/requirements.txt; fi

# Install spmd
python3 spmd/setup.py install

set -ex

# Run all integration tests
pytest --shard-id=${SHARD} --num-shards=4 --cov=spmd test/spmd/ --ignore=test/spmd/tensor/test_dtensor_ops.py
