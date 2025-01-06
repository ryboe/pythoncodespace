# syntax=docker/dockerfile:1
ARG PYTHON_VERSION="3.13"
FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}

LABEL org.opencontainers.image.authors="Ryan Boehning <1250684+ryboe@users.noreply.github.com>"

RUN <<-EOT
    mkdir -p --mode=755 /etc/apt/keyrings
    wget --no-verbose --output-document=/etc/apt/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list
    apt update
    apt full-upgrade
    apt install gh --yes
    apt clean
    rm -rf /var/lib/apt/lists/*
EOT

# Change the vscode user's default shell to zsh.
RUN sed -i 's/\/home\/vscode:\/bin\/bash/\/home\/vscode:\/bin\/zsh/' /etc/passwd
USER vscode

# Remove shell configs from the base image.
RUN rm -rf ~/.bash_logout ~/.bashrc ~/.oh-my-zsh ~/.profile

# Enable pipefail to catch poetry install errors.
SHELL ["/bin/zsh", "-o", "pipefail", "-c"]

# Install poetry and enable its completions.
RUN <<-EOT
    mkdir -p /home/vscode/.local/bin
    curl -sSL https://install.python-poetry.org | python -
    mkdir -p ~/.zfunc
    poetry completions zsh > ~/.zfunc/_poetrywhic
    fpath+=~/.zfunc
EOT
