# For more information, please refer to https://aka.ms/vscode-docker-python
FROM continuumio/miniconda3

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
# COPY requirements.txt .
# RUN python -m pip install -r requirements.txt

# RUN apt-get -y update
# RUN apt-get -y install libgsl-dev
# RUN apt-get -y install libopenblas-dev
# RUN apt-get -y install file
# RUN apt-get -y install roary
RUN apt-get update && \
    apt-get -y install libgsl-dev libopenblas-dev file roary && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml
RUN conda create -n prokka_env -c bioconda -c conda-forge -c defaults "prokka>=1.14"

# Make RUN commands use the new environment:
RUN echo "conda activate myenv" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Install bioconda programs used
# RUN conda install -c bioconda shovill
# RUN conda install -c bioconda fastqc
# RUN conda install -c bioconda mlst
# RUN conda install -c bioconda abricate
# RUN conda install -c plotly plotly=5.10.0=py_0
# RUN conda install -c conda-forge dash=2.6.2=pyhd8ed1ab_0
# RUN conda install -c anaconda beautifulsoup4=4.11.1=py37h06a4308_0
# RUN conda install pandas=1.3.5=py37h8c16a72_0
# RUN conda install tqdm=4.64.1=py37h06a4308_0
# RUN conda install -c conda-forge pyfiglet
# RUN conda install -c anaconda networkx
# RUN conda install -c conda-forge pytest-shutil
RUN conda install -c bioconda shovill fastqc mlst abricate pandas tqdm networkx \
    && conda install -c plotly plotly=5.10.0=py_0 \
    && conda install -c conda-forge dash=2.6.2=pyhd8ed1ab_0 \
    && conda install -c anaconda beautifulsoup4=4.11.1=py37h06a4308_0 \
    && conda install -c conda-forge pyfiglet \
    && conda install -c conda-forge pytest-shutil

ARG INCUBATOR_VER=unknown
WORKDIR /app
RUN git clone https://github.com/liviurotiul/PeGAS.git /app
RUN mkdir /app/web/figures
WORKDIR /app/data
WORKDIR /app/database
WORKDIR /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN addgroup --gid 1024 mygroup
RUN adduser -u 5678 --disabled-password --gecos "" --force-badname --ingroup mygroup appuser && chown -R appuser /app
USER appuser

CMD ["conda", "run", "--no-capture-output", "-n", "myenv", "python", "main.py"]
# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug