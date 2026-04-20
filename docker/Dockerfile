FROM ubuntu:20.04

# Metadata
LABEL software.name="kallistogrch38encode44"
LABEL software.version="0.52"
LABEL software.description="kallisto quant against Grch38 Gencode 44"
LABEL software.build-date=$BUILD_DATE
LABEL software.vcs-ref=$VCS_REF

RUN apt-get -y update && apt-get -y install wget bzip2 tar

RUN wget  https://github.com/pachterlab/kallisto/releases/download/v0.52.0/kallisto_linux-v0.52.0.tar.gz && \
  mv kallisto_linux-v0.52.0.tar.gz /opt && \
  cd /opt && \
  tar -zxvf kallisto_linux-v0.52.0.tar.gz && \
  mv kallisto kallisto_linux-v0.52.0 && \
  cp kallisto_linux-v0.52.0/kallisto .  && \
  rm kallisto_linux-v0.52.0.tar.gz 
  

ENV PATH=$PATH:/opt

# prevent docker from caching
RUN ls ./

COPY kallistogrch38encode44/src/run_kallisto.sh  /
COPY kallistogrch38encode44/src/run_kallisto.sh  /opt/run_kallisto.sh
RUN chmod +x /opt/run_kallisto.sh
COPY kallistogrch38encode44/ref/gencode_v44.idx /opt/index_grch38_encode44/gencode_v44.idx

ENTRYPOINT ["/bin/bash", "/opt/run_kallisto.sh"]

