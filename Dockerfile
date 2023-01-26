# syntax=docker/dockerfile:1
ARG PYTHON_VERSION="3.11"
FROM mcr.microsoft.com/devcontainers/python:${PYTHON_VERSION}

LABEL org.opencontainers.image.authors="Ryan Boehning <1250684+ryboe@users.noreply.github.com>"

RUN <<-EOT
  apt update
  apt full-upgrade
  rm -rf /var/lib/apt/lists/*
EOT

# Enable pipefail to catch errors.
SHELL ["/bin/zsh", "-o", "pipefail", "-c"]

# Change the vscode user's default shell to zsh.
RUN sed -i 's/\/home\/vscode:\/bin\/bash/\/home\/vscode:\/bin\/zsh/' /etc/passwd
USER vscode

# Create local bin directory for gh, poetry, and other command line tools.
RUN mkdir -p /home/vscode/.local/bin
ENV PATH="/home/vscode/.local/bin:$PATH"

# Remove shell configs from the base image.
RUN rm -rf ~/.bash_logout ~/.bashrc ~/.oh-my-zsh ~/.profile

# Install the latest gh CLI tool. The first request fetches the URL for the
# latest release tarball. The second request downloads the tarball.
RUN <<-EOT
  wget --quiet --timeout=30 --output-document=- 'https://api.github.com/repos/cli/cli/releases/latest' |
  jq -r ".assets[] | select(.name | test(\"gh_.*?_linux_amd64.tar.gz\")).browser_download_url" |
  wget --quiet --timeout=180 --input-file=- --output-document=- |
  tar -xvz -C /home/vscode/.local/ --strip-components=1
EOT

# Install poetry and enable its completions.
RUN <<-EOT
  curl -sSL https://install.python-poetry.org | python -
  mkdir -p ~/.zfunc
  poetry completions zsh > ~/.zfunc/_poetrywhic
  fpath+=~/.zfunc
EOT
