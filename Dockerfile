FROM thehyve/ohdsi-r-base:3.6.3

WORKDIR /opt/app
COPY . /opt/app

RUN install.r . \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && mv docker-etl-synthea /usr/local/bin/etl-synthea \
  && chmod +x /usr/local/bin/etl-synthea

CMD ["etl-synthea"]
