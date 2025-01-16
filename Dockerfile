# syntax = edrevo/dockerfile-plus

FROM ubuntu:22.04 AS builder
WORKDIR /root

# Language
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

SHELL [ "/bin/bash", "-c" ]

# Change apt source to local mirror
RUN sed -ri.bak -e 's/\/\/.*?(archive.ubuntu.com|mirrors.*?)\/ubuntu/\/\/mirrors.pku.edu.cn\/ubuntu/g' -e '/security.ubuntu.com\/ubuntu/d' /etc/apt/sources.list

# Install dependent packages
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf bison build-essential ccache flex help2man libfl2 libfl-dev libgoogle-perftools-dev \
    numactl perl perl-doc curl wget git sudo ca-certificates keyboard-configuration console-setup \
    libreadline-dev gawk tcl-dev libffi-dev graphviz xdot libboost-system-dev python3-pip \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev time device-tree-compiler libelf-dev \
    bc unzip zlib1g zlib1g-dev libtcl8.6 iverilog pkg-config clang verilator vim ripgrep cmake openjdk-8-jre && \
    apt-get clean

# Install utils
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install rich parse scipy seaborn matplotlib
RUN apt-get update && apt-get install -y cloc zip ssh ninja-build gperf openssh-server

# Set proxy
INCLUDE+ Dockerfile.proxy

# Install Java and SBT
RUN \
    curl -s "https://get.sdkman.io" | bash && \
    source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk install java $(sdk list java | grep -o "\b8\.[0-9]*\.[0-9]*\-tem" | head -1) && \
    sdk install sbt

# Install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# cp ./repos to /root/repos
COPY repos /root/repos

# add /root/.local/bin to PATH in bash
RUN echo "export PATH=\"/root/.cargo/bin:/root/.local/bin:\$PATH\"" >> /root/.bashrc

# echo export POPAPATH=/root/repos/popa/install
RUN echo "export POPAPATH=\"/root/repos/popa/install\"" >> /root/.bashrc

CMD [ "/bin/bash", "-l" ]