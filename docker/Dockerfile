# Use the official PHP Apache image (highly optimized, runs mod_php natively so no 503 errors)
FROM php:8.2-apache

# Install the required MySQL extensions for the PHP app to function properly
RUN docker-php-ext-install mysqli pdo pdo_mysql

# We use the local tarball downloaded into the docker/ directory.
# Docker's 'ADD' instruction automatically extracts local tarballs.
ADD lab-app.tgz /var/www/html/

# Update ownership of the specific config file per the task requirement
# Note: Debian-based Apache images use the 'www-data' user natively, not 'apache'
RUN chown www-data:root /var/www/html/rds.conf.php

# Expose HTTP port
EXPOSE 80
