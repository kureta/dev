# syntax=docker/dockerfile:1
# check=error=true

# ========================
# Builder should have dependencies that are independent of the
# specific project. This includes installing poetry, which is
# used to manage the project's dependencies.
# ========================
FROM python:3.12-slim AS builder

# Set global environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.8 \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=1 \
  POETRY_CACHE_DIR=/opt/.cache

# Install pip
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y --no-install-recommends \
  # deps for installing poetry
  python3-pip=23.*

# Don't know why hadolint doesn't like mount cache with pip
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install "poetry==$POETRY_VERSION"

# ========================
# The dependencies stage installs the project's runtime dependencies.
# ========================

FROM builder AS dependencies

WORKDIR /opt
COPY pyproject.toml poetry.lock /opt/
RUN --mount=type=cache,target=/opt/.cache \
  poetry install --no-root --only main

# ========================
# Runtime stage copies everything necessary to run the applicationfrom
# from previous stages, and sets up the runtime environment.
# ========================

FROM python:3.12-slim AS runtime

# Set the UID and GID to match the host user (e.g., UID 1000 and GID 1000)
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a group and a user with specific UID and GID
RUN groupadd -g ${GROUP_ID} developer \
  && useradd -ml -u ${USER_ID} -g developer developer

WORKDIR /app
USER developer
ENV XDG_CACHE_HOME=/app/.cache
COPY --from=dependencies /opt/.venv /opt/.venv
ENV PATH="/opt/.venv/bin:$PATH"
COPY . /app

ENV PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONPATH=/app/src
CMD [ "python", "-m", "dev.main" ]

# ========================
# dev-dependencies stage installs all dependencies, including development
# dependencies, of the project such as pre-commit hooks and testing libraries.
# ========================

FROM builder AS dev-dependencies

WORKDIR /opt
COPY pyproject.toml poetry.lock README.md /opt/
RUN --mount=type=cache,target=/opt/.cache \
  poetry install

# ========================
# development stage, copies everything necessary for development from
# previous stages, and sets up the development environment.
# ========================

FROM python:3.12-slim AS development

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y --no-install-recommends \
  # deps for installing poetry
  git=1:2.39.* \
  ssh=1:9.* \
  wget=1.21.* \
  build-essential=12.* \
  npm=9.* \
  unzip=6.*

# Set the UID and GID to match the host user (e.g., UID 1000 and GID 1000)
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a group and a user with specific UID and GID
RUN groupadd -g ${GROUP_ID} developer \
  && useradd -ml -u ${USER_ID} -g developer developer \
  && mkdir -p /app \
  && chown developer:developer /app

USER developer

# Setup neovim
WORKDIR /home/developer
RUN wget -q https://github.com/neovim/neovim-releases/releases/download/v0.10.1/nvim-linux64.tar.gz \
  && tar xzf nvim-linux64.tar.gz \
  && mkdir -p /home/developer/.local/bin \
  && mkdir -p /home/developer/.config/nvim \
  && mkdir -p /home/developer/.ssh \
  && ln -s /home/developer/nvim-linux64/bin/nvim /home/developer/.local/bin/nvim \
  && rm nvim-linux64.tar.gz
ENV PATH="/home/developer/.local/bin:$PATH"

COPY --chown=developer:developer ./dotfiles/config/nvim /home/developer/.config/nvim
RUN nvim --headless +'Lazy! install' +'qall'

COPY --chown=developer:developer ./install.lua /home/developer/install.lua
COPY --chown=developer:developer ./install.sh /home/developer/install.sh
RUN '/home/developer/install.sh'

WORKDIR /app
COPY --from=dev-dependencies /opt/.venv /opt/.venv
ENV PATH="/opt/.venv/bin:$PATH"

ENV PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONPATH=/app/src
CMD [ "python", "-m", "dev.main" ]
