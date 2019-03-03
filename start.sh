#!/bin/sh

# create a served file for testing (...the cheezy way)
HEAD="
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>test page</title>
  </head>
  <body>
    Hello from hostname:<br/>
"
TAIL="
  </body>
</html>
"
echo "$HEAD$(hostname)$TAIL" > /var/www/localhost/htdocs/hostname.html

# this launcher script tails the access and error logs
# to the stdout and stderr, so that `docker logs -f lighthttpd` works.

tail -F /var/log/lighttpd/access.log 2>/dev/null &
tail -F /var/log/lighttpd/error.log 2>/dev/null 1>&2 &

# launch server
lighttpd -D -f /etc/lighttpd/lighttpd.conf
