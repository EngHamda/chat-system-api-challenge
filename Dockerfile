FROM ruby:2.6.3

ENV BUNDLER_VERSION=2.3.15


# install rails dependencies
RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 default-libmysqlclient-dev git libcurl3-dev cmake \
    libssl-dev pkg-config openssl imagemagick file nodejs yarn


RUN mkdir /app
WORKDIR /app
# ENV RAILS_ROOT /app
# RUN mkdir -p $RAILS_ROOT
# WORKDIR $RAILS_ROOT

# Adding gems
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
#COPY Gemfile Gemfile
#COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /app
#COPY . .

#NOTE COPY eq ADD when use add must add (/[dirName])


# Add a script to be executed every time the container starts.
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]