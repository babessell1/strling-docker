# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential

# Install micromamba
RUN curl micro.mamba.pm/install.sh | bash
ENV PATH="${PATH}:/home/ubuntu/mamba/bin/micromamba"


# Create and activate a new virtual environment named 'env'
RUN micromamba create -y -c conda-forge -c bioconda -n env snakemake-minimal=5.3.0 python=3.11.3
ENV PATH="/home/ubuntu/mamba/envs/env/bin:${PATH}"

# Install strling
RUN curl https://nim-lang.org/choosenim/init.sh -sSf > init.sh && sh init.sh
ENV PATH="/home/ubuntu/.nimble/bin:${PATH}"
RUN git clone https://github.com/quinlan-lab/STRling.git && \
    cd STRling && \
    nimble install && \
    nim c -d:danger -d:release src/strling.nim && \
    cd ../

# Set the working directory
WORKDIR /home/ubuntu/

# Copy your application code into the container
COPY run_strling.sh .

# Set the entrypoint command
CMD ["run_strling.sh"]