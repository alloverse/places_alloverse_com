FROM elixir:1.11

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    apt-get clean && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.3 --force && \
    mix local.rebar --force && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV APP_HOME /app
EXPOSE 4000 
ENV MIX_ENV=prod
ENV DATABASE_URL=ecto://user:pass@localhost/db_name 
ENV SECRET_KEY_BASE="0I7OIsK/bUWKn1q9Qj54cYjHnWPhsU/c2S/g9eWSMqLvRYsWTIX9u9Wkf5ZsyH3W"

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY mix.exs .
COPY mix.lock .

RUN mkdir assets

COPY assets/package.json assets
COPY assets/package-lock.json assets

RUN mix do deps.get, deps.compile && \
    cd assets && npm install

ADD . $APP_HOME

RUN mix compile && \
    cd assets && \
    npm run deploy

CMD mix phx.server