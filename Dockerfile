FROM --platform=$BUILDPLATFORM ruby:2.7.7
ARG REST_API_KEY
ARG RAILS_LTS
ENV APP_HOME /app
RUN apt-get update -qq && apt-get install -y build-essential

# Install the newest version of NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install development tools
RUN apt-get -y install vim

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY . $APP_HOME
RUN gem install ruby-debug-ide --pre
RUN gem install bundler -v 2.3.14 && bundle config set gems.railslts.com $RAILS_LTS && bundle install
