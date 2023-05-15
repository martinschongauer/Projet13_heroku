
setup:
  config:
    APP_NAME: heroku-oc-projet-baptiste
build:
  docker:
    web: Dockerfile
run:
    web: gunicorn oc_lettings_site.wsgi:application --bind 0.0.0.0:$PORT
