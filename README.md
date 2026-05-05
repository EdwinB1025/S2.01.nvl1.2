# Base de datos: Pizzeria 🍕
**Descripcion**: Este proyecto incorpora el proceso de creacion de la base de datos para una pizzeria, el repositorio contiene un unico script para la creacion del "schema" y la base de datos principal, la insercion de tablas y las restricciones relacionales.

## ⚛️ Tecnologia:
- SQL: MySQL, MySQL Workbench. 

## 🚀 Instalacion:
1. Clonar repositorio en una directorio local:
    `git clone https://github.com/EdwinB1025/S2.01.nvl1.1.git`
2. Obeter directorio para la ejecucion de MySQL server:
    a. From MySQL Command Line:
    ```sql
    SELECT @@basedir;
    /*
    +------------------------------------------+
    | @@basedir                                |
    +------------------------------------------+
    | C:\Program Files\MySQL\MySQL Server 8.0\ |
    +------------------------------------------+
    1 row in set (0.00 sec)
    */
    ```
    b. From bash/cmd/powershaell: `where mysql`.
    c. Copy the path directly from the Program File directory in your local machine:
        `"C:\Program Files\MySQL\MySQL Server 8.0\"`
3. Generate a session variable to launch MySQL using your path, mind you need to extend your path addind the subfolder `"/bin"`:
    `export PATH=$PATH:"/c/Program Files/MySQL/MySQL Server 8.0/bin"`
4. Connect to your local MySQL server.
    ```bash
    mysql -u root -p
    ```
    ```bash
    Enter password: **************
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 48
    Server version: 8.0.46 MySQL Community Server - GPL
    ```
5. Run the script: ```SOURCE main.sql; ```
6. To exist MySQL Server: `EXIT;`.
