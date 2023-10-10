nohup gunicorn --bind 0.0.0.0:8000 newspaper.wsgi --workers=4 &
nohup sudo -u postgres /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/data -c config_file=/etc/postgresql/14/main/postgresql.conf &
nginx -g 'daemon off;'
