FROM ruby:3.1.2

RUN apt-get update -qq \
  && apt-get install -y nodejs \
  && mkdir /ttms

WORKDIR /ttms

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN gem install bundler \
  && bundle install

COPY . /ttms
