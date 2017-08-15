FROM nginx:1.11

ENV USERNAME "super-user"
ENV PASSWORD "bord telefon lampa"
ENV PASS_FILE "/etc/nginx/pass"
ENV PROXYS "url_path;proxy_pass;proxy_redirect;rewrite;"
  # Add more proxys with "|" as separator at end
WORKDIR /app

COPY run.sh /app/run.sh

CMD /bin/bash -c "/app/run.sh && nginx -g 'daemon off;'"
