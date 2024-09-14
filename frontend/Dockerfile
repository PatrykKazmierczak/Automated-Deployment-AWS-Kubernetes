# Use an official nginx image
FROM nginx:alpine

# Copy the static files into NGINX web server directory
COPY . /usr/share/nginx/html

# Copy custom NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf
