FROM cruizba/ubuntu-dind:latest

ARG USER_NAME
ARG USER_EMAIL
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    git \
    openssh-server \
    libmysqlclient-dev \
    vim \
    unzip

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash
RUN apt install -y nodejs

# install oh-my-zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t https://github.com/romkatv/powerlevel10k.git \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions

# zsh syntax highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install render-cli
RUN curl -fsSL https://raw.githubusercontent.com/render-oss/cli/refs/heads/main/bin/install.sh | sh

RUN mkdir volume
WORKDIR /root/volume

# setup SSH Keys
COPY ssh/ /root/.ssh/
RUN chmod 0700 /root/.ssh && \
    chmod 600 /root/.ssh/* && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# p10k custom config
COPY p10k.zsh /root/.p10k.zsh

# zshrc custom config
COPY zshrc /root/.zshrc
RUN echo "git config --global user.name '${USER_NAME}'" >> /root/.zshrc
RUN echo "git config --global user.email '${USER_EMAIL}'" >> /root/.zshrc
RUN git config --global --add safe.directory '*'
