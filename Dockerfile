FROM alpine
RUN apk add git bash curl
RUN git clone https://github.com/holyketzer/heroku-buildpack-vault.git
RUN sed -i s/0.9.0/1.3.4/g /heroku-buildpack-vault/bin/compile
RUN /heroku-buildpack-vault/bin/compile /opt /tmp
RUN mv /opt/vendor/vault/vault /usr/local/bin/
COPY start.sh start.sh
RUN chmod +x start.sh
CMD ./start.sh
