FROM elixir:alpine
#
ARG PORT=4000
ENV PORT=${PORT}
#
ARG CONFIG_PATH=/config
ENV CONFIG_PATH=${CONFIG_PATH}
#
ARG APP_ENV=prod
ENV MIX_ENV=${APP_ENV}
#
#
RUN apk update && apk upgrade
RUN apk add inotify-tools
#
#
ADD src/ /app/
WORKDIR /app
