FROM ubuntu:latest 

ARG DEBIAN_FRONTEND=noninteractive

USER root

WORKDIR /var/www/html  

RUN apt update -y && apt install --no-install-recommends git  apache2-utils apache2 -y software-properties-common supervisor && apt clean && rm -fr /var/lib/apt/lists/*                                                                                                        

RUN LC_ALL=fr_CH.UTF-8 add-apt-repository ppa:ondrej/php                                       

RUN apt install curl  php8.0 php8.0-gd php8.0-xml php8.0-soap php8.0-mbstring php8.0-mysql libapache2-mod-php8.0 php8.0-cli php8.0-curl unzip -y &&   apt clean &&  rm -rf /var/lib/apt/lists/*                                                                  

RUN a2enmod php8.0 && a2enmod rewrite


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN git clone https://github.com/laravel/laravel.git website

RUN cd website &&  composer install

RUN  chmod -R 777 website/storage/
COPY default.conf /etc/apache2/sites-available/000-default.conf	
EXPOSE 80 

CMD ["apache2ctl", "-D","FOREGROUND"]
