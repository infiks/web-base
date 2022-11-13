# web-base

Base image for PHP websites.

The `PORT` environment variable can be used to set the HTTP port.
The documument root is located at `/public`.

## Usage


```Dockerfile
FROM docker.io/infiks/web-base:latest

COPY --chown=www-data:www-data src/ /public/
```

Run the following command to run the docker image.

```bash
$ docker run -it --rm -e PORT=5000 -p 80:5000 docker.io/infiks/web-base:latest
```
