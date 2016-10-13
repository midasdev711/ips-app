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

ENV APP_PATH /app/user/

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* $APP_PATH
RUN bundle install

ADD . $APP_PATH

CMD ["puma", "--config", "config/puma.rb"]

EXPOSE 9292
