FROM nginx:alpine
RUN mkdir /app
COPY nginx.conf /etc/nginx/nginx.conf.template

CMD ["sh", "-c", "envsubst '$UPSTREAMS $CA' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"]
