ARG VOLTA_VERSION=2.0.1

# build the app via volta to use the correct node version
FROM --platform=$BUILDPLATFORM debian:bookworm AS build-app
RUN apt update -y && apt upgrade -y
RUN apt install -y curl
WORKDIR /app

# install volta to install correct node version
RUN curl -o install-volta.sh -L --proto "=https" --tlsv1.2 -sSf https://get.volta.sh
ARG VOLTA_VERSION
ENV VOLTA_HOME="/.volta"
RUN bash install-volta.sh --version ${VOLTA_VERSION}
ENV PATH="$VOLTA_HOME/bin:$PATH"

# install node
COPY --link package.json .
RUN volta run node --version


# install dependencies
COPY --link package-lock.json .
RUN volta run npm ci