FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY web.conf /etc/nginx/conf.d

VOLUME /var/log/nginx
