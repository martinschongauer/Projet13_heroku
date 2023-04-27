# pull official base image - TROUVE DANS LE NOUVEAU TUTORIAL (on enleve juste les installs de postgresql)
FROM python:3.10-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

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

# collect static files
RUN python manage.py collectstatic --noinput

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
# CMD gunicorn hello_django.wsgi:application --bind 0.0.0.0:$PORT


# VERSION DU TUTORIAL PRECEDENT

# FROM node:14-alpine
#
# RUN apk add --no-cache --update curl bash
# WORKDIR /app
#
# ARG NODE_ENV=development
# ARG PORT=3000
# ENV PORT=$PORT
#
# COPY package* ./
# # Install the npm packages
# RUN npm install && npm update
#
# COPY . .
#
# # Run the image as a non-root user
# RUN adduser -D myuser
# USER myuser
#
# EXPOSE $PORT
#
# CMD ["npm", "run", "start"]