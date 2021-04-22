FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# https://github.com/sharkdp/bat/issues/938#issuecomment-646745610 for --force-overwrite
RUN apt-get update && apt-get -y install -o Dpkg::Options::="--force-overwrite" bat bash curl fd-find git ripgrep tree vim

WORKDIR /root
COPY vimrc .vim/vimrc
COPY init.sh /root/init.sh
RUN /root/init.sh
