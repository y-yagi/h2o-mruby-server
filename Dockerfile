FROM lkwg82/h2o-http2-server

RUN mkdir /etc/h2o/scripts
ADD scripts/* /etc/h2o/scripts/
ADD h2o.conf /etc/h2o/
CMD h2o --conf h2o.conf
