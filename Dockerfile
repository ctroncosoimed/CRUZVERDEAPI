FROM ruby:2.5

RUN mkdir -p /cruzverdeapi
WORKDIR /cruzverdeapi

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN apt-get update && apt-get install -y nodejs postgresql-client vim --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY Gemfile /cruzverdeapi
COPY Gemfile.lock /cruzverdeapi

RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /cruzverdeapi

EXPOSE 4000
CMD ["rails", "server", "-b", "0.0.0.0"]