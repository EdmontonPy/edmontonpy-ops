upstream edmontonpy {
    server unix:///var/run/uwsgi/app/www.edmontonpy.com/socket;
}

server {
    listen 80 default_server;
    server_name _;
    return 301 https://www.edmontonpy.com$request_uri;
}

server {
    server_name www.edmontonpy.com;

    access_log /var/log/nginx/www.edmontonpy.com.access.log;
    error_log /var/log/nginx/www.edmontonpy.com.error.log;

    root /var/www/www.edmontonpy.com/;

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.edmontonpy.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.edmontonpy.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location / {
        include /etc/nginx/uwsgi_params;
        proxy_redirect     off;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;

        add_header X-Frame-Options SAMEORIGIN;

        uwsgi_pass  edmontonpy;
    }

    location /static/ {
        autoindex off;
    }
}
