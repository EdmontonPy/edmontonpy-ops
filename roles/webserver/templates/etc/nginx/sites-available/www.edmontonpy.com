upstream edmontonpy {
    server unix:///var/run/uwsgi/app/www.edmontonpy.com/socket;
}

server {
    listen 80;
    server_name www.edmontonpy.com;

    access_log /var/log/nginx/www.edmontonpy.com.access.log;
    error_log /var/log/nginx/www.edmontonpy.com.error.log;

    root /var/www/www.edmontonpy.com/;

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

# For non-www to redirect to http://www.edmontonpy.com
server {
    listen 80 default_server;
    server_name _;
    return 302 http://www.edmontonpy.com$request_uri;
}
