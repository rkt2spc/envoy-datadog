FROM envoyproxy/envoy:v1.14.2

RUN apt-get update \
    && apt-get install -y vim gettext dnsutils netcat

COPY envoy.yaml /etc/envoy/envoy.yaml
COPY clusters.yaml /etc/envoy/clusters.yaml
COPY listeners.yaml /etc/envoy/listeners.yaml
COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 8080 8081

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]
