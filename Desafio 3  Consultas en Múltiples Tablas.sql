-- Creación de la base de datos

CREATE DATABASE "Desafio3-Victor-Martinez-374";

-- Ingresando a la base de datos

\c "Desafio3-Victor-Martinez-374"

-- Creación de la tabla Usuarios

CREATE TABLE Usuarios (id SERIAL PRIMARY KEY, email VARCHAR, nombre VARCHAR(40), apellido VARCHAR(40), rol VARCHAR(20));

-- Inserción de registros en la tabla Usuarios

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES ('javier@gmail.com', 'Javier', 'Portela', 'usuario'), ('cristian@gmail.com', 'Cristian', 'Rivera', 'usuario'), ('erica@gmail.com', 'Erica', 'Lamas', 'usuario'), ('alain@gmail.com', 'Alain', 'Molinero', 'administrador'), ('antonio@gmail.com', 'Antonio', 'Narvaez', 'usuario');
-- Creación de la tabla Posts

CREATE TABLE Posts (id SERIAL PRIMARY KEY,titulo VARCHAR(100), contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOLEAN, usuario_id BIGINT, FOREIGN KEY (usuario_id) REFERENCES Usuarios(id));

-- Inserción de registros en la tabla Posts

INSERT INTO Posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('Titulo del post 1', 'Contenido del post 1', '2023-01-01 16:32:00', '2023-02-01 13:04:00', true, 1), ('Titulo del post 2', 'Contenido del post 2', '2023-01-02 23:15:00', '2023-02-02 23:50:00', false, 1), ('Titulo del post 3', 'Contenido del post 3', '2023-01-03 12:20:00', '2023-02-03 02:02:00', false, 2), ('Titulo del post 4', 'Contenido del post 4', '2023-01-04 06:34:00', '2023-02-04 12:12:00', true, 3), ('Titulo del post 5', 'Contenido del post 5', '2023-01-05 01:15:00', '2023-02-05 22:05:00', false, null);

-- Creación de la tabla Comentarios

CREATE TABLE Comentarios (  id SERIAL PRIMARY KEY,  contenido TEXT ,  fecha_creacion TIMESTAMP ,  usuario_id BIGINT,  post_id BIGINT,  FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),  FOREIGN KEY (post_id) REFERENCES Posts(id));

-- Inserción de registros en la tabla Comentarios

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('Contenido del comentario 1', '2023-03-01 15:52:00', 1, 1), ('Contenido del comentario 2', '2023-03-02 22:30:00', 2, 1), ('Contenido del comentario 3', '2023-03-03 13:43:00', 3, 1), ('Contenido del comentario 4', '2023-03-04 05:35:00', 1, 2), ('Contenido del comentario 5', '2023-03-05 11:20:00', 2, 2);

--Cruce de datos entre Usuarios y Posts

SELECT u.nombre, u.email, p.titulo, p.contenido FROM Usuarios u INNER JOIN Posts p ON u.id = p.usuario_id ORDER BY u.id;


--Muestra el id, título y contenido de los posts de los administradores.

SELECT p.id, p.titulo, p.contenido FROM Usuarios u INNER JOIN Posts p ON u.id = p.usuario_id WHERE u.rol = 'administrador' ORDER BY u.id;

--Cantidad de posts de cada usuario

SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts FROM Usuarios u LEFT JOIN Posts p ON u.id = p.usuario_id GROUP BY u.id, u.email ORDER BY u.id;

--Email del usuario con más posts

SELECT u.email FROM Usuarios u INNER JOIN (  SELECT usuario_id, COUNT(id) AS cantidad_posts  FROM Posts  GROUP BY usuario_id  ORDER BY cantidad_posts DESC  LIMIT 1) p ON u.id = p.usuario_id ORDER BY u.id;


--Fecha del último post de cada usuario

SELECT u.id, u.email, MAX(p.fecha_creacion) AS ultima_fecha_post FROM Usuarios u LEFT JOIN Posts p ON u.id = p.usuario_id GROUP BY u.id, u.email ORDER BY u.id;

--Título y contenido del post con más comentarios

SELECT p.titulo, p.contenido FROM Posts p INNER JOIN (  SELECT post_id, COUNT(id) AS cantidad_comentarios  FROM Comentarios  GROUP BY post_id  ORDER BY cantidad_comentarios DESC  LIMIT 1) c ON p.id = c.post_id;


--Título de cada post, contenido de cada post, contenido de cada comentario asociado y email del usuario que lo escribió

SELECT p.titulo, p.contenido, c.contenido AS contenido_comentario, u.email FROM Posts p LEFT JOIN Comentarios c ON p.id = c.post_id INNER JOIN Usuarios u ON p.usuario_id = u.id;

--Contenido del último comentario de cada usuario

SELECT u.nombre, u.apellido, c.contenido FROM usuarios u INNER JOIN comentarios c ON u.id = c.usuario_id WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id) ORDER BY c.contenido ASC;


--Emails de los usuarios que no han escrito ningún comentario

SELECT u.email FROM Usuarios u LEFT JOIN Comentarios c ON u.id = c.usuario_id GROUP BY u.email HAVING COUNT(c.id) = 0;

