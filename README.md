# Ubuntu LAMP stack para Wordpress

## Ubuntu: 20.04 Nginx : nginx/1.18.0 (Ubuntu) PHP : 7.4.3 FMP MySql : 8.0.21

### Volumenes

* Unidad de persistencia para mysql "/var/lib/mysql",
* Unidad de persistencia para workpress content "/app/wp-content"
  
### Setup inicial de workpress

* Copiar wordpress a la carpeta __/www__ _( wp-config.php debe existir en la carpeta raiz de wordpress )_
* Reemplazar la base de datos __docker/mysql/init_db.sql__ con el archivo sql de una copia ya instalada y configurada de wordpress, renombrar a __init_db.sql__
* Configurar el script __init_db.sh__ con los valores de la base de datos de wordpress, nombre de usuario, contraseña, nombre base de datos..
  
### Compilación

* Compilar la imagen utilizando el comando __docker build . -t wordpressTag:latest__
* Ejecutar con el comando __docker run 8080:80 wordpressTag:latest__
