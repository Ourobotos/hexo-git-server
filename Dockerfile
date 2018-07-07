FROM alpine:3.7

LABEL maintainer "ourob@qq.com"

RUN apk add --no-cache \
  openssh \
  git

RUN ssh-keygen -A

WORKDIR /hexo-server/

COPY git-shell-commands /home/git/git-shell-commands

RUN mkdir /hexo-server/keys \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:12345 | chpasswd \
  && mkdir /home/git/.ssh \
  && chmod +x /home/git/git-shell-commands/no-interractive-login

COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh
COPY hexo.git /home/git/hexo.git

VOLUME [ "/hexo-server/repos" ]
VOLUME [ "/hexo-server/html" ]

EXPOSE 22

CMD ["start.sh"]
ENTRYPOINT ["ash"]