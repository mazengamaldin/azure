FROM nginx:alpine

# Copy static website files into the container
COPY ./html /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]