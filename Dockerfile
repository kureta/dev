# syntax=docker/dockerfile:1
# check=error=true

FROM python:3.12-slim AS builder

ENV PYTHONUNBUFFERED=1 \
  # python
  PYTHONDONTWRITEBYTECODE=1 \
  # pip
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # poetry
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

RUN --mount=type=cache,target=/root/.cache/pip \
  pip install "poetry==$POETRY_VERSION"

# ========================

FROM builder AS dependencies

WORKDIR /opt
COPY pyproject.toml poetry.lock /opt/
RUN --mount=type=cache,target=/opt/.cache \
  poetry install --no-root --only main

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

CMD [ "python", "src/dev/main.py" ]

# ========================

FROM builder AS dev-dependencies

WORKDIR /opt
COPY pyproject.toml poetry.lock README.md /opt/
RUN --mount=type=cache,target=/opt/.cache \
  poetry install

# ========================
# TODO: I need a home dir for dotfiles anyway.

FROM python:3.12-slim AS development

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update && apt-get install -y --no-install-recommends \
  # deps for installing poetry
  git=1:2.39.* \
  ssh=1:9.*

# Set the UID and GID to match the host user (e.g., UID 1000 and GID 1000)
ARG USER_ID=1000
ARG GROUP_ID=1000

# Create a group and a user with specific UID and GID
RUN groupadd -g ${GROUP_ID} developer \
  && useradd -ml -u ${USER_ID} -g developer developer \
  && mkdir -p /app \
  && chown developer:developer /app

WORKDIR /app
USER developer
COPY --from=dev-dependencies /opt/.venv /opt/.venv
ENV PATH="/opt/.venv/bin:$PATH"

CMD [ "python", "src/dev/main.py" ]
