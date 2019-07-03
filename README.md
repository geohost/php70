# php70
Dockerfile for DockerHub: geohost/php70
Container based on Ubuntu 18.04 with php7.0-fpm or corn
If the container was started with the env IS_CRON=1 make it only run the cron daemon
or with env IS_SUPERVISOR=1 will start the supervisord.
