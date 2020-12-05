upstream photos {
    server 127.0.0.1:3000;
    server 127.0.0.1:3100;
    server 127.0.0.1:3101;
}

server {
    listen 80;
    server_name photos.example.com;


client_max_body_size 5m;

location / {
    proxy_pass http://photos;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}

location ~* \.(js|css|png|jpe?g|gif) {
    root /var/www/photos.example.com;
}

}

