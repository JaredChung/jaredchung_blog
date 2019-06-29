FROM python:3.7-alpine
#FROM ubuntu:16.04

#COPY ./ /app
#WORKDIR /app

RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

# Port for App
EXPOSE 5000

# Run Command Line
CMD ["/bin/sh"]

#ENTRYPOINT [ "python" ]
#CMD [ "jaredchung_blog.py" ]
