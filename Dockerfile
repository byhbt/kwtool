FROM hexpm/elixir:1.11.3-erlang-23.1.5-alpine-3.12.1 AS build

# install build dependencies
RUN apk add --no-cache build-base npm git && \
    mix local.hex --force && \
    mix local.rebar --force

# prepare build dir
WORKDIR /app

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.12.1 AS app

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

# Setup non-root user
RUN addgroup -S app_group && \
    adduser -s /bin/sh -G app_group -D app_user && \
    chown app_user:app_group /app

COPY --from=build --chown=app_user:app_group /app/_build/prod/rel/kwtool ./
COPY bin/start.sh ./bin/start.sh

ENV HOME=/app

USER app_user

CMD bin/start.sh
