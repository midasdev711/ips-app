FROM ruby:2.2.3

RUN apt-get update -q && apt-get install -y build-essential

# for postgresql
RUN apt-get install -y libpq-dev

# for wkhtmltopdf
RUN apt-get install -y xfonts-base xfonts-75dpi

# wkhtmltopdf
RUN FILE=wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
  && wget -q http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/$FILE \
  && dpkg -i $FILE \
  && rm $FILE

# phantomjs
RUN mkdir drivers
RUN wget -q -P drivers https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
RUN tar -C drivers -xjf /drivers/phantomjs-1.9.8-linux-x86_64.tar.bz2
RUN rm -Rf /drivers/phantomjs-1.9.8-linux-x86_64.tar.bz2
RUN ln -s /drivers/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
RUN chmod 755 /usr/bin/phantomjs

ENV APP_PATH /app/user/

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* $APP_PATH
RUN bundle install

ADD . $APP_PATH

CMD ["puma", "--config", "config/puma.rb"]

EXPOSE 9292
