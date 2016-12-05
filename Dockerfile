FROM ruby:2.2.3

RUN apt-get update -q && apt-get install -y build-essential \

  # postgresql dependencies
  libpq-dev \

  # wkhtmltopdf dependencies
  xfonts-base xfonts-75dpi \

  # phantomjs dependencies
  fontconfig

WORKDIR /tmp/

# wkhtmltopdf
RUN FILE=wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
  && wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/$FILE \
  && dpkg -i $FILE \
  && rm $FILE

# phantomjs
RUN FILE=phantomjs-2.1.1-linux-x86_64 \
  && wget -U "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14" https://bitbucket.org/ariya/phantomjs/downloads/$FILE.tar.bz2 \
  && tar -xjf $FILE.tar.bz2 \
  && mv $FILE/bin/phantomjs /usr/bin/ \
  && rm -r $FILE $FILE.tar.bz2

ENV APP_PATH /app/user/

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* $APP_PATH
RUN bundle install

ADD . $APP_PATH

CMD ["puma", "--config", "config/puma.rb"]

EXPOSE 9292
