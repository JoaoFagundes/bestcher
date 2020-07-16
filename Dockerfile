FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y postgresql-client
RUN mkdir /bestcher

WORKDIR /bestcher
COPY Gemfile /bestcher/Gemfile
COPY Gemfile.lock /bestcher/Gemfile.lock
RUN bundle install

COPY . /bestcher
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
