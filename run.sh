#!/bin/bash

set -e

USERNAME=${USERNAME:-"super-user"}
PASSWORD=${PASSWORD:-"bord telefon lampa"}
PASS=$(echo $PASSWORD | openssl passwd -apr1 -stdin)
PASS_FILE=${PASS_FILE:-"/etc/nginx/pass"}
# separate with "|"
PROXYS=${PROXYS:-"url_path;proxy_pass;proxy_redirect;rewrite;userdefined;"}

generate_pass () {
  echo $USERNAME:$PASS > $PASS_FILE
  return 0
}

create_default_conf () {
  input=$*

  IFS="|"; read -a list <<<"$input"

  echo "server {" > /etc/nginx/conf.d/default.conf
  for item in ${list[*]}; do
    IFS=";"; read -r url_path proxy_pass proxy_redirect rewrite userdefined <<< "$item"

    url_path=${url_path:+/}$url_path$([[ $url_path != / ]] && echo /)
    extra=${proxy_pass:+$( \
      printf "\n    proxy_pass $proxy_pass;" \
    )}${proxy_redirect:+$( \
      printf "\n    proxy_redirect $proxy_redirect;" \
    )}${rewrite:+$( \
      printf "\n    rewrite $rewrite;" \
    )}

    for rule in $userdefined ; do
      extra=$(printf "$extra\n    $rule;")
    done

    cat <<EOF >> /etc/nginx/conf.d/default.conf

  location $url_path {$extra
    auth_basic "Restricted";
    auth_basic_user_file $PASS_FILE;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
    proxy_set_header Authorization "";
  }
EOF
  done

  echo "}" >> /etc/nginx/conf.d/default.conf
  return 0
}

generate_pass && create_default_conf $PROXYS
