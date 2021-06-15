FROM nginx:alpine
COPY application/index.html /usr/share/nginx/html
EXPOSE 80