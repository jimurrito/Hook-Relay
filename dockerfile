#FROM elixir:latest
FROM elixir:alpine
#
#
ARG PORT=4000
ENV PORT=${PORT}
#
ENV CONFIG_PATH=/config
#
ARG APP_ENV=prod
ENV MIX_ENV=${APP_ENV}
#
#
RUN apk update && apk upgrade
#RUN apt update && apt upgrade -y
RUN apk add inotify-tools
#RUN apt install inotify-tools -y
#
#
RUN mkdir /config
ADD src/ /app/
WORKDIR /app
#
#
RUN mix deps.get
RUN mix compile
#
#
CMD ["mix", "phx.server"]
#