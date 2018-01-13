FROM gliderlabs/alpine:latest

LABEL maintainer=dansta

ARG BIND_CONF
ENV BIND_CONF ${BIND_CONF:-/etc/named/named.conf}
ARG BIND_PORT
ENV BIND_PORT ${BIND_PORT:-56}
ARG BIND_EFFECTIVE_USER
ENV BIND_EFFECTIVE_USER ${BIND_EFFECTIVE_USER:-named}
ARG BIND_EFFECTIVE_GROUP
ENV BIND_EFFECTIVE_GROUP ${BIND_EFFECTIVE_GROUP:-named}

# Healthcheck is not working, disabling for now
#HEALTHCHECK --interval=10s --timeout=3s CMD dig @localhost www.kvantmekanik.se || exit 1

# Update and install packages
RUN apk --no-cache add bind
RUN apk --no-cache add python3
RUN apk --no-cache add bind-utils

ADD files/named.conf ${BIND_CONF} 
ADD files/replace.py /usr/local/bin/replace_conf
ADD files/hosts /etc/hosts
RUN chmod +rx /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf ${BIND_CONF} BIND
RUN rm -f /usr/local/bin/replace_conf

# Mount volumes to keep store and logs away from the thin layer overlay
# This is important for performance and memory footprint
VOLUME /var/log/named/
VOLUME /var/named/

# Remove this line if you want to be able to rerun replace_conf
# to enable runtime environment variables being read into the application
# Otherwise we do not need this package for runtime activities
# Replace_conf might become a standalone binary in the future
RUN apk del python3
# Document port usage for docker in case you are going to use it as a service
EXPOSE ${BIND_PORT}/tcp \
       ${BIND_PORT}/udp

# Test squid for build
CMD bind
