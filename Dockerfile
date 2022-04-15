FROM ruby:3.1.2

RUN apt-get update -qq \
  && apt-get install -y nodejs \
  && mkdir /ttms
WORKDIR /ttms
COPY Gemfile /ttms/Gemfile
COPY Gemfile.lock /ttms/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
