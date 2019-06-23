FROM python:3.7-alpine

#FROM ubuntu:16.04

COPY ./ /app
WORKDIR /app

#RUN apt-get update && \
#        apt-get install -y software-properties-common vim && \
#        add-apt-repository ppa:jonathonf/python-3.6
#
#RUN apt-get update -y
#
#RUN apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv && \
#        apt-get install -y git
#
## update pip
#RUN python3.6 -m pip install pip --upgrade && \
#        python3.6 -m pip install wheel

RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["/bin/sh"]

#ENTRYPOINT [ "python" ]
#CMD [ "jaredchung_blog.py" ]
