#! /bin/bash
echo "[1/2] cron image push to registry"
cd line_notify/
docker image build -t cronjob/line_notify:latest .
docker image tag cronjob/line_notify:latest localhost:5000/cronjob/line_notify:latest
docker image push localhost:5000/cronjob/line_notify:latest

echo "[2/2] deploy cron"
cd ..
cp yml/cron.yml stack/
docker container exec -it manager docker stack deploy -c stack/cron.yml todo_cron
docker container exec -it manager chmod +x /usr/local/bin/line_notify.sh