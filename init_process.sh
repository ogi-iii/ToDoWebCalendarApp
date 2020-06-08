#! /bin/bash
echo "[1/6] create swarm nodes as docker in docker"
docker-compose up -d
docker container exec -it manager docker swarm init | sed 1,4d | sed '2,$d' >> tmp.txt
# pick up swarm token
token=$(cat tmp.txt | awk '{print $5}')
rm tmp.txt
# join to swarm
for i in $(seq 1 3)
do
    docker container exec -it worker0${i} docker swarm join --token $token manager:2377
done

# make swarm network
docker container exec -it manager docker network create --driver=overlay --attachable todoapp

# check nodes status
docker container exec -it manager docker node ls

echo "[2/6] build & run visualizer"
cp yml/visualizer.yml stack/
docker container exec -it manager docker stack deploy -c /stack/visualizer.yml visualizer

echo "[3/6] api image push to registry"
cd main/
docker image build -t todowebcalendarapp/todoapi:latest .
docker image tag todowebcalendarapp/todoapi:latest localhost:5000/todowebcalendarapp/todoapi:latest
docker image push localhost:5000/todowebcalendarapp/todoapi:latest

echo "[4/6] nginx image push to registry"
cd ../nginx/
docker image build -t todowebcalendarapp/nginx:latest .
docker image tag todowebcalendarapp/nginx:latest localhost:5000/todowebcalendarapp/nginx:latest
docker image push localhost:5000/todowebcalendarapp/nginx:latest

echo "[5/6] deploy app"
cd ..
cp yml/todo/app.yml stack/
docker container exec -it manager docker stack deploy -c stack/app.yml todo_app

echo "[6/6] deploy ingress"
cp yml/todo/ingress.yml stack/
docker container exec -it manager docker stack deploy -c stack/ingress.yml todo_ingress

echo -e "\n Visualizer running on http://localhost:9000/"
echo -e "\n App running on http://localhost:8000/\n"
