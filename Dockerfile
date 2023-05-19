# pull official base image
FROM python:3.10-alpine

# set work directory
WORKDIR /app

# set environment variables
ENV PORT=8000
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

# Env. variables defined as arguments
ARG arg_secret_key
ENV SECRET_KEY=$arg_secret_key

# install dependencies
COPY ./requirements.txt /app/
RUN pip install -r requirements.txt
EXPOSE 8000

# copy project
COPY . /app/

# collect static files
RUN python manage.py collectstatic --noinput

# add and run as non-root user
RUN adduser -D myuser
USER myuser

# run gunicorn
CMD gunicorn oc_lettings_site.wsgi:application --bind 0.0.0.0:$PORT
