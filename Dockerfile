FROM alpine:3.9

LABEL MAINTAINER="Vlad Rusu <vlad.rusu11@gmail.com>"

ARG KUBE_LATEST_VERSION="v1.15.2"

ARG HELM_VERSION="v2.14.3"

ARG GHC_BUILD_TYPE=gmp
ARG GHC_VERSION=8.6.5

ENV TERM=xterm-256color
ENV TMUX_PLUGIN_MANAGER_PATH /home/vladrusu/.tmux/plugins
ENV SHELL /bin/zsh

RUN adduser -Ds /bin/zsh vladrusu
WORKDIR /home/vladrusu
ENV HOME /home/vladrusu

RUN apk add --no-cache bash zsh git tmux vim curl python3 nodejs clang-libs docker cmake make python3-dev g++ npm su-exec which python-dev libffi-dev openssl-dev gcc libc-dev py-pip

RUN pip install docker-compose

ENV GHCUP_INSTALL_BASE_PREFIX=/
ENV PATH=/.ghcup/bin:$PATH

COPY --from=marcfreiheit/ghcup:latest /.ghcup /.ghcup
COPY --from-marcfreiheit/haskell-stack:latest /usr/bin/stack /usr/bin/stack

ARG GHC_BUILD_TYPE

ARG GHC_VERSION=8.6.5

ENV GHCUP_INSTALL_BASE_PREFIX=/
ENV PATH=/.ghcup/bin:$PATH

ENV GHCUP_VERSION=0.0.7
ENV GHCUP_SHA256="b4b200d896eb45b56c89d0cfadfcf544a24759a6ffac029982821cc96b2faedb  ghcup"

RUN apk upgrade --no-cache &&\
    apk add --no-cache \
    curl \
    git \
    xz &&\
    if [ "${GHC_BUILD_TYPE}" = "gmp" ]; then '
        echo "Installing 'libgmp'" &&\
        apk add --no-cache gmp-dev; \
    fi

RUN mkdir -p /home/vladrusu/.stack && echo " allow-different-user: true" >> /home/vladrusu/.stack/config.yaml
RUN ghcup set ${GHC_VERSION} && \
    stack config set system-ghc --global true

RUN apk add --no-cache --virtual .build-deps ca-certificates openssh \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && apk del --no-cache .build-deps

RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz && \
    mkdir -p /usr/local/gcloud && \
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz && \
    /usr/local/gcloud/google-cloud-sdk/install.sh && \
    chown -R vladrusu: /usr/local/gcloud

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN git clone https:/github.com/powerline/fonts.git --depth=1 && \
    cd fonts && \
    ./install.sh && \
    cd .. && \
    rm -rf fonts

RUN apk --no-cache gmp-dev
USER vladrusu
RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm && .tmux/plugins/tpm/install_plugins
USER root
RUN git clone https://github.com/olivierverdier/zsh-git-prompt.git zsh/git-prompt && \
    stack init && \
    stack setup && \
    stack build && stack install \
    touch /home/vladrusu/zsh/git-prompt/src/.bin/gitstatus && \
    chmod 777 /home/vladrusu/zsh/git-prompt/src/.bin/gitstatus

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/bundle/ycm && \

RUN git clone https://github.com/ycm-core/YouCompleteMe.git .vim/bundle/ycm && \
    cd .vim/bundle/ycm && \
    git submodule update --init --recursive && \
    python3 install.py --clang-completer --ts-completer --java-completer

RUN git clone https://github.com/vim-airline/vim-airline.git .vim/bundle/vim-airline && \
    git clone https://github.com/kien/ctrlp.vim.git ./vim/bundle/ctrlp.vim

COPY --chown=vladrusu:vladrusu zsh/ zsh
COPY --chown=vladrusu:vladrusu zsh/.zshrc .zshrc

COPY --chown=vladrusu:vladrusu vim/.vimrc .vimrc
COPY --chown=vladrusu:vladrusu vim/colors .vim/colors

COPY --chown=vladrusu:vladrusu tmux/.tmux.conf .tmux.conf
COPY --chown=vladrusu:vladrusu tmux/.remote.tmux.conf .remote.tmux.conf

RUN ln -sf zsh/.zshrc .zshrc

RUN apk add --no-cache openssh-client
RUN chown vladrusu: /home/vladrusu/.tmux
USER vladrusu
RUN /home/vladrusu/.tmux/plugins/tpm/bin/install_plugins
USER root
COPY entrypoint.sh .
RUN apk add --no-cache shadow grep
ENTRYPOINT ["/home/vladrusu/entrypoint.sh"]

