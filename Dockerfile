FROM ubuntu:20.04

RUN apt-get update && apt-get install -y curl build-essential wget nano

RUN wget http://ftp.us.debian.org/debian/pool/main/i/icu/libicu63_63.2-3_amd64.deb
RUN dpkg -i libicu63_63.2-3_amd64.deb

RUN useradd -ms /bin/bash runner
USER runner
WORKDIR /home/runner
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

COPY --chown=runner:runner ./install.sh .
COPY --chown=runner:runner ./config.sh .
COPY --chown=runner:runner ./start.sh .
