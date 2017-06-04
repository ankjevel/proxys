FROM nginx:1.11

ENV USERNAME "super-user"
ENV PASSWORD "bord telefon lampa"
ENV PASS_FILE "/etc/nginx/pass"
ENV PROXYS "path;proxy_path;proxy_redirect;rewrite;|..."
WORKDIR /app

COPY run.sh /app/run.sh

CMD /bin/bash -c "/app/run.sh && nginx -g 'daemon off;'"
