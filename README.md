# envoy-datadog

Test envoy datadog stats sink

## Usage

1. Build the image
  
```sh
docker build envoy-datadog
```

2. Run the image with environment variables

```sh
docker run --rm \
  -e 'DOGSTATSD_ADDRESS=127.0.0.1' \
  -e 'UPSTREAM_HOST=mydomain.com' \
  -name envoy-datadog \
  -p 8080:8080 \
  envoy-datadog
```

3. Test the container

```sh
# If you're using the default supplied UPSTREAM_HOST
curl -D - -H 'Host: 5ff35ccd28c3980017b193a2.mockapi.io' http://localhost:8080/users
```
