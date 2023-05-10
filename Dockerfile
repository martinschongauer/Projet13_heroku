# pull official base image
FROM python:3.10-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

# Env. variables used to hide infos in GitHub
ARG secret_key_arg
ARG sentry_addr_arg

# # install psycopg2
# RUN apk update \
#     && apk add --virtual build-essential gcc python3-dev musl-dev \
#     && apk add postgresql-dev \
#     && pip install psycopg2

# install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy project
COPY . .

# store env. variables in the dedicated local file
RUN echo "SECRET_KEY=$secret_key_arg" >> .env
RUN echo "SENTRY_ADDR=$sentry_addr_arg" >> .env

# collect static files
RUN python manage.py collectstatic --noinput

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
# CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT

