FROM python:3.7.6-alpine3.10

RUN apk update && apk --no-cache add --virtual .builds-deps \
  build-base \
  gcc \
  libffi-dev \
  openssl-dev \
  python3-dev \
  libpq \
  postgresql-dev

RUN pip install -U \
  pip \
  gunicorn \
  gevent \
  psycopg2 \
  Authlib==0.6 \
  Flask==0.12.2 \
  Flask-SQLAlchemy==2.3.2 \
  Flask-WTF==0.14.2 \
  Werkzeug==0.14.1

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

WORKDIR /app
COPY ./start.sh ./start.sh
RUN chmod +x start.sh
RUN cp ./conf/dev.config.py.sample ./conf/dev.config.py

CMD sh -c "export FLASK_APP=app.py && export FLASK_DEBUG=1 && flask run --host=0.0.0.0"
