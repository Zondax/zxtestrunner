FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -yy curl build-essential wget nano git && \ 
    apt-get install -yy bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev libltdl7 libnuma1

RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/h/hwloc/libhwloc5_1.11.9-1_amd64.deb && \
    dpkg -i libhwloc5_1.11.9-1_amd64.deb

RUN ln -s /usr/lib/x86_64-linux-gnu/libhwloc.so.1 /usr/lib/x86_64-linux-gnu/libhwloc.so

RUN wget http://ftp.us.debian.org/debian/pool/main/i/icu/libicu63_63.2-3_amd64.deb
RUN dpkg -i libicu63_63.2-3_amd64.deb

RUN useradd -ms /bin/bash runner
USER runner
WORKDIR /home/runner
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

COPY --chown=runner:runner ./install.sh .
COPY --chown=runner:runner ./config.sh .
COPY --chown=runner:runner ./start.sh .
