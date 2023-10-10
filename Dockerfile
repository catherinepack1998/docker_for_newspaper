FROM ubuntu:22.04
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SUPERUSER_PASSWORD=admin
ENV PGDATA /var/lib/postgresql/data
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y nginx python3 python3-pip postgresql-client nginx postgresql-common postgresql sudo 
COPY ./site.conf /etc/nginx/sites-enabled/default
RUN pip install django psycopg2-binary gunicorn tzdata
WORKDIR /newspaper
VOLUME /newspaper /var/lib/postgresql/data
COPY ./runscript.sh /tmp/run.sh
EXPOSE 80 8000 5432
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"
USER postgres
RUN /etc/init.d/postgresql start && psql --command "ALTER USER postgres PASSWORD 'postgres';"
USER root
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/14/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/14/main/postgresql.conf
RUN /usr/local/bin/django-admin startproject newspaper .
RUN python3 manage.py migrate
RUN python3 manage.py createsuperuser --noinput --username admin --email skillfactorytest18@yandex.ry
ENTRYPOINT ["sh", "/tmp/run.sh"]