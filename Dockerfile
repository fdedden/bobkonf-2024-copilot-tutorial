FROM debian:testing

RUN apt-get update
RUN apt-get install --yes libghc-copilot-dev
RUN apt-get install --yes make

WORKDIR /share
