server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    root        %docroot%;
    index       index.php index.html index.htm;
    access_log  /var/log/nginx/domains/%domain%.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;

    location ~* .(jpg|jpeg|gif|png|ico|svg|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|txt|odt|ods|odp|odf|tar|wav|bmp|rtf|js|mp3|avi|mpeg|flv|html|htm|woff2|json)$ {
        add_header Pragma "public";
        add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        access_log off;
        log_not_found off;
        expires   360d;
    }

    # Block access to protected, framework
    location ~ /(protected|framework) {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Block access to theme-folder views directories
        location ~ /themes/\w+/views {
        deny all;
        access_log off;
        log_not_found off;
    }

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~* \.php$ {
        include        /etc/nginx/fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_param  SCRIPT_NAME $fastcgi_script_name;
        fastcgi_param  PATH_INFO $fastcgi_path_info;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_buffering off;
        fastcgi_index  index.php;
        fastcgi_pass   %backend_lsnr%;
    }

    error_page  403 /error/404.html;
    error_page  404 /error/404.html;
    error_page  500 502 503 504 /error/50x.html;

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location ~* "/\.(htaccess|htpasswd)$" {
        deny    all;
        return  404;
    }

    location /vstats/ {
        alias   %home%/%user%/web/%domain%/stats/;
        include %home%/%user%/web/%domain%/stats/auth.conf*;
    }

    include     /etc/nginx/conf.d/phpmyadmin.inc*;
    include     /etc/nginx/conf.d/phppgadmin.inc*;
    include     /etc/nginx/conf.d/webmail.inc*;

    include     %home%/%user%/conf/web/nginx.%domain_idn%.conf*;
}
