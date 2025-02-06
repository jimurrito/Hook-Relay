FROM elixir:alpine
#
#
ARG PORT=4000
ENV PORT=${PORT}
#
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
ADD config/ /config/
WORKDIR /app
#
#
RUN mix deps.get
RUN mix compile
#
#
CMD ["mix", "hook-relay"]
#