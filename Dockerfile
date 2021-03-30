FROM ruby:2.2.5

RUN apt-get update -q && apt-get install -y build-essential \

  # postgresql dependencies
  libpq-dev \

  # wkhtmltopdf dependencies
  xfonts-base xfonts-75dpi \

  libpng16-16 \

  libjpeg-turbo8 \

  libssl1.1 \

  # phantomjs dependencies
  fontconfig

WORKDIR /tmp/

# wkhtmltopdf
RUN FILE=wkhtmltox_0.12.6-1.xenial_amd64.deb \
  && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/$FILE \
  && dpkg -i $FILE \
  && rm $FILE

# phantomjs
RUN FILE=phantomjs-2.1.1-linux-x86_64 \
  && wget https://cnpmjs.org/mirrors/phantomjs/$FILE.tar.bz2 \
  && tar -xjf $FILE.tar.bz2 \
  && mv $FILE/bin/phantomjs /usr/bin/ \
  && rm -r $FILE $FILE.tar.bz2

ENV APP_PATH /app/user/

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* $APP_PATH
RUN bundle install

ADD . $APP_PATH

ARG ASSETS_PRECOMPILE
RUN if [ -n "$ASSETS_PRECOMPILE" ]; then RAILS_ENV=production rake assets:precompile; else exit 0; fi

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["start"]
