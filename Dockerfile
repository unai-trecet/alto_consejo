FROM ruby:3.0.2
RUN apt-get update -qq \ 
&& apt-get install -y nodejs postgresql-client yarn \
&& apt-get clean

ADD . /alto_consejo
WORKDIR /alto_consejo
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["bash"]


