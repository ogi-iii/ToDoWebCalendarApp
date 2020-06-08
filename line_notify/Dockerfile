FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y cron
RUN apt-get install -y wget
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_linux_x86_64.tgz
RUN rm entrykit_0.4.0_linux_x86_64.tgz
RUN mv entrykit /usr/local/bin/
RUN entrykit --symlink

COPY line_notify.py /usr/local/bin/
COPY line_notify.sh.tmpl /usr/local/bin/
COPY cronjob /etc/cron.d/

RUN chmod 0644 /etc/cron.d/cronjob

ENTRYPOINT [ \
    "render", \
        "/usr/local/bin/line_notify.sh", \
        "--" \
]

CMD [ "cron", "-f"]
