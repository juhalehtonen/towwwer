FROM ubuntu:16.04

ENV REFRESHED_AT=2018-08-16 \
    LANG=en_US.UTF-8 \
    HOME=/opt/build \
    TERM=xterm

WORKDIR /opt/build

RUN \
  apt-get update -y && \
  apt-get install -y git wget locales && \
  locale-gen en_US.UTF-8 && \
  apt-get purge -y --auto-remove nodejs && \
  apt-get install -y curl && \
  curl -s https://deb.nodesource.com/setup_11.x | bash && \
  apt-get install -y nodejs && \
  which nodejs && \
  nodejs --version

RUN \
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  rm erlang-solutions_1.0_all.deb && \
  apt-get update -y && \
  apt-get install -y erlang elixir

CMD ["/bin/bash"]