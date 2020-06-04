FROM python:3.7

RUN apt-get update

COPY ./app /

RUN pip install -r requirements.txt
RUN python create_table.py

EXPOSE 8000

CMD ["uvicorn", "urls:app", "--host", "0.0.0.0", "--port", "8000"]

# on your terminal, please run below commands for docker
# $ docker image build -t myimage .
# $ docker container run --rm --name mycontainer -p 8000:8000 myimage
