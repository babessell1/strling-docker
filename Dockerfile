# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set the working directory
WORKDIR /home/ubuntu/

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential

# Install nim
RUN curl https://nim-lang.org/choosenim/init.sh -sSf > init.sh \
    && chmod +x init.sh \
    && init.sh \
    && rm init.sh

ENV PATH="/home/ubuntu/.nimble/bin:${PATH}"


#install strling
RUN git clone https://github.com/quinlan-lab/STRling.git && \
    cd STRling && \
    nimble install && \
    nim c -d:danger -d:release src/strling.nim && \
    cd ..

# Copy your application code into the container
COPY run_strling.sh .

# Set the entrypoint command
CMD ["run_strling.sh"]