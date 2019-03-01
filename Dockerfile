# Dockerfile for lighttpd
#
# docker build -t lighttpd .
#
# docker run -p 8082:80 --rm -t --name lighttpd -h lighttpd -v `pwd`/htdocs:/var/www/localhost/htdocs -v `pwd`/etc/lighttpd:/etc/lighttpd lighttpd

FROM alpine

# lighttpd
RUN apk update --no-cache
RUN apk add --no-cache lighttpd
RUN apk add --no-cache lighttpd-mod_auth

# some net utils
RUN apk --no-cache add iputils
RUN apk --no-cache add bind-tools
RUN apk --no-cache add curl

# cleanup
RUN  rm -rf /var/cache/apk/*

## workaround for bug preventing sync between VirtualBox and host
# http://serverfault.com/questions/240038/lighttpd-broken-when-serving-from-virtualbox-shared-folder
RUN echo server.network-backend = \"writev\" >> /etc/lighttpd/lighttpd.conf

COPY etc/lighttpd/* /etc/lighttpd/
COPY htdocs/* /var/www/localhost/htdocs/
COPY start.sh /usr/local/bin/

EXPOSE 80

VOLUME /var/www/localhost/htdocs
VOLUME /etc/lighttpd

CMD ["start.sh"]
