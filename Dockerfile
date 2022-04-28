FROM ruby:3.1.2

EXPOSE 3000

RUN apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /ttms

WORKDIR /ttms

COPY Gemfile /ttms/Gemfile
COPY Gemfile.lock /ttms/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
