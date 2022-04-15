FROM ruby:3.1.2

RUN apt-get update -qq \
  && curl https://deb.nodesource.com/setup_12.x | bash \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get install -y nodejs yarn \
  && mkdir /ttms
WORKDIR /ttms
COPY Gemfile /ttms/Gemfile
COPY Gemfile.lock /ttms/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["./bin/dev"]
