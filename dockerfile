FROM nginx:alpine

# Copy static website files into the container
COPY sample.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
