# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    samtools \
    parallel

# rebuild

# Install nim
#RUN apt-get update && \
#  apt-get install -y curl xz-utils gcc openssl ca-certificates git && \
#  curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y && \
#  apt -y autoremove && \
#  apt -y clean

#ENV PATH=/home/ubuntu/.nimble/bin:$PATH

#install strling
#RUN git clone https://github.com/quinlan-lab/STRling.git && \
#    cd STRling && \
#    nimble install -y && \
#    nim c -d:danger -d:release src/strling.nim && \
#    cd ..

# Copy your application code into the container
WORKDIR /usr/local/bin

RUN wget https://github.com/quinlan-lab/STRling/releases/download/v0.5.2/strling && \
    chmod +x strling

COPY run_strling.sh .
RUN chmod +x run_strling.sh

RUN chmod -R 777 /var/lib/

# Set the entrypoint command
CMD ["run_strling.sh"]
