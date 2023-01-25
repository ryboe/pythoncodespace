# pythoncodespace

A codespace for Python development with poetry

## Features

Since it's based on the mcr.microsoft.com/vscode/devcontainers/python image, it
supports all Codespace features. In addition, it has these changes:

1. [`poetry`](https://github.com/python-poetry/poetry) is installed.
2. [`gh`](https://github.com/cli/cli), the official GitHub CLI, is installed.
3. The default user is `vscode`.
4. The `vscode` user's default shell is `/bin/zsh`.

## How To Build Locally

```sh
# Codespaces only run on linux/amd64, so we don't need to build multiplatform
# images.
docker buildx build --platform linux/amd64 --build-arg PYTHON_VERSION=3.11 - < Dockerfile
```

Only the minor version can be specified in `PYTHON_VERSION`. In other words, you
can pass `3.10`, `3.11`, etc., but not `3.10.9` or `3.11.1`.
