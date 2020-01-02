FROM python:3.8

ENV user dev 
 
RUN useradd -m -d /home/${user} ${user} \
    && chown -R ${user} /home/${user}
 
USER ${user}

WORKDIR /home/${user}
ENV PATH="/home/${user}/.local/bin:${PATH}"

USER root
RUN apt-get update && apt-get install -y \
    curl \
    git \
    silversearcher-ag \
&& rm -rf /var/lib/apt/lists/*
RUN curl -sL install-node.now.sh/lts | bash -s -- -y

USER ${user}
RUN curl -sLO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && rm nvim.appimage 

USER root
RUN ln -s /home/${user}/squashfs-root/usr/bin/nvim /usr/local/bin/nvim

USER ${user}
RUN curl -fsLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p .config/nvim
COPY ./init.vim /home/${user}/.config/nvim/init.vim
COPY ./entrypoint.sh /


RUN ["/entrypoint.sh"]
