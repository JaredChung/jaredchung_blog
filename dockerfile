FROM python:3.6.4-alpine

WORKDIR /app

COPY . /app

RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

EXPOSE 8888

#ENTRYPOINT [ "python" ]
#CMD [ "jaredchung_blog.py" ]
