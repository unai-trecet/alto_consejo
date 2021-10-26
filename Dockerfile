FROM ruby:3.0.2
RUN apt-get update -qq \ 
&& apt-get install -y nodejs sqlite3 libsqlite3-dev yarn \
&& apt-get clean

ADD . /alto_consejo
WORKDIR /alto_consejo
RUN bundle install

EXPOSE 3000

CMD ["bash"]

