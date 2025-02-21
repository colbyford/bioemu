FROM pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime

LABEL authors="Colby T. Ford <colby@tuple.xyz>"

## Install system requirements
RUN apt update && \
    apt-get install -y --reinstall \
        ca-certificates && \
    apt install -y \
        git \
        wget \
        gcc \
        g++

## Set working directory
RUN mkdir -p /software/bioemu
WORKDIR /software/bioemu

## Clone project
RUN git clone https://github.com/microsoft/bioemu.git /software/bioemu

## Set up BioEmu conda environment
ENV CONDA_PREFIX=/opt/conda/envs/bioemu
RUN bash /software/bioemu/setup.sh
RUN /opt/conda/envs/bioemu/bin/python -m pip install \
        openmm==8.2.0 \
        pdb2pqr==3.4.1

## Automatically activate BioEmu conda environment
RUN echo "source activate bioemu" >> /etc/profile.d/conda.sh && \
    echo "source /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate bioemu" >> ~/.bashrc