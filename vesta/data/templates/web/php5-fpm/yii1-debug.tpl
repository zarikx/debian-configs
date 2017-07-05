[%backend%]
listen = 127.0.0.1:%backend_port%
listen.allowed_clients = 127.0.0.1

user = %user%
group = %user%

pm = dynamic
pm.max_children = 50
pm.start_servers = 3
pm.min_spare_servers = 2
pm.max_spare_servers = 10

env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

catch_workers_output = yes

php_admin_value[error_reporting] = E_ALL
php_admin_flag[log_errors] = on
php_admin_flag[display_errors] = on
