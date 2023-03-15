# Manual Usuario API REST
## Introduction

La dirección de nuestra API estará formada por localhost/api → <http://127.0.0.1:8080/api/>

## Configuration

Abrimos un gestor de API’s, en nuestro caso, RapidAPI y creamos dos variables de entorno API\_HOST, con la dirección del server y API\_KEY con la key para conectarse al server, haciendo doble click en ShelterAPI.

![](./docs/api-001.png)


Environment variables

![](./docs/api-002.png)


## Endpoints

Para crear un endpoint seleccionamos el símbolo “+” y escribimos el nombre de la request

### Sign Up

Este endpoint sirve para registrar un usuario en la aplicación cuya dirección es <http://127.0.0.1:8080/api/auth/signup>

- **Request**

La petición sera un POST al endpoint anterior compuesto por:

- Headers → Debemos de escribir de la ApiKey de nuestra aplicación



![](./docs/api-003.png)

- ` `Body → Deberá estar compuesto por los siguientes parámetros. El único caso especial es el de address, que deberíamos cambiar el tipo manualmente a array para poder meter los valores longitude y latitude, de tipo Int, dentro de dicho valor. El resto de los campos serán de tipo String:

![](./docs/api-004.png)

- **Response**

Hacemos en actualizar y enviamos la petición, si la respuesta es satisfactoria recibimos un código 200 OK y recibiremos un token en la respuesta:

![](./docs/api-005.png)


### Sign In

Este endpoint sirve para autenticar un usuario en la aplicación cuya dirección es <http://127.0.0.1:8080/api/auth/signin> 

- **Request**

La petición sera un GET al endpoint anterior compuesto por:

![](./docs/api-006.png)

- Headers → Debe de ir la variable de entorno ApiKey y el Authorization que se crea automáticamente a través Auth, como veremos a continuación



![](./docs/api-007.png)



- ` `Auth → Deberá estar compuesto por el username y la password en formato utf-8:

![](./docs/api-008.png)


- **Response**

Hacemos en actualizar y enviamos la petición, si la respuesta es satisfactoria recibimos un código 200 OK y un token en la respuesta:

![](./docs/api-009.png)


### Get All Shelters

Este endpoint sirve recuperar todos los Shelters registrados en el servidor cuya dirección es <http://127.0.0.1:8080/api/shelters>

- **Request**

La petición sera un GET al endpoint anterior compuesto por :

![](./docs/api-010.png)


- Headers → Debe de ir la variable de entorno ApiKey , ya que se puede acceder a este endpoint sin necesidad de registrarse en la app.



![](./docs/api-011.png)


- **Response**

Hacemos clic en actualizar y enviamos la petición al servidor, si la respuesta es satisfactoria recibimos un código 200 OK y una lista de los Shelters con todos sus datos :

![](./docs/api-012.png)


### Get One Shelter

Este endpoint sirve recuperar los datos de un Shelter registrado en el servidor a través de su id, cuya dirección es [http://127.0.0.1:8080/api/shelters/{id_shelter}](http://127.0.0.1:8080/api/shelters/%7Bid_shelter%7D)

- **Request**

Para realizar este endpoint vamos al endpoint anterior Shelters, dentro de la respuesta, seleccionamos un id y hacemos clic con el botón derecho,  y seleccionamos la opción copy as dynamic value y lo pegamos en la url del endpoint para podemos crear id\_shelter dinamicamente. En nuestro caso, hemos cogido la primera posición.

![](./docs/api-013.png)


La petición será un GET al endpoint anterior, compuesto por:


![](./docs/api-014.png)



- Headers → Debe de ir la variable de entorno ApiKey , ya que se puede acceder a este endpoint sin necesidad de registrarse en la app.



![](./docs/api-015.png)


- **Response**

Hacemos en actualizar y enviamos la petición, si la respuesta es satisfactoria recibimos un código 200 OK y nos devolverá los datos del Shelter que corresponda con la id :

![](./docs/api-016.png)


### <a name="ole_link1"></a>Upload photo with multipart

Este endpoint sirve subir una foto al Public Directory con el formato user\_id.png de los usuarios registrados en el servidor cuya dirección es <http://127.0.0.1:8080/api/upload>

- **Request**

Para realizar este endpoint vamos al endpoint anterior Shelters y dentro de la respuestas, hacemos click en “copy as dynamic value” y lo pegamos en la url para que podamos crear el id\_shelter dinámicamente. En nuestro caso, hemos cogido la primera posición.

![](./docs/api-013.png)


La petición será un POST  al endpoint anterior, compuesto por :

![](./docs/api-017.png)


- Headers → Debe de ir la variable de entorno ApiKey , ademas de un Authorization Bearer {SignIn\_token}, haciendo un  “copy as dynamic value” de la respuesta recibida en el endpoint Sign In, ya que para que un Shelter pueda subir una imagen es necesario que previamente se haya registrado y autenticado en la aplicación:



![](./docs/api-018.png)

Body → Aqui deberemos incluir la imagen que deseamos añadir en nuestro Shelter en formato **multipart**  con el atributo **picture**, que escribiremos manualmente, y para añadir el archivo hacemos clic derecho en el campo Value → File → File Content 

![](./docs/api-019.png)

Nos aparecerá un campo dinámico donde podremos insertar el archivo a través de la opción **Choose File …** en formato tanto .jpg como .png:

![](./docs/api-020.png)



- **Response**

Hacemos clic en actualizar y enviamos la petición, si la respuesta es satisfactoria recibimos un código 303 See other y nos devolverá la location de donde se ha guardado la photoURL Shelter que corresponda con la id:

![](./docs/api-021.png)
### Update shelter

Este endpoint sirve actualizar los datos de un shelter en el servidor cuya dirección es <http://127.0.0.1:8080/api/update>

- **Request**

Para realizar este endpoint vamos al endpoint seguido por la ID del Shelter que queremos actualizar y dentro de la respuestas anterirores, hacemos click en “copy as dynamic value” y lo pegamos en la url para que podamos crear el id\_shelter dinámicamente. En nuestro caso, hemos cogido la primera posición.

![Text

Description automatically generated](./docs/Aspose.Words.a5f4cc92-1036-4da7-b86f-b455a71c891e.022.png)


La petición será un POST  al endpoint anterior, compuesto por :

![](./docs/api-023.png)


- Headers → Debe de ir la variable de entorno ApiKey , ademas de un Authorization Bearer {SignIn\_token}, haciendo un  “copy as dynamic value” de la respuesta recibida en el endpoint Sign In, ya que para que un Shelter pueda subir una imagen es necesario que previamente se haya registrado y autenticado en la aplicación:



![A screenshot of a computer

Description automatically generated with medium confidence](./docs/Aspose.Words.a5f4cc92-1036-4da7-b86f-b455a71c891e.018.png)

Body → Aqui deberemos incluir la imagen que deseamos añadir en nuestro Shelter en formato **multipart**  con el atributo **picture**, que escribiremos manualmente, y para añadir el archivo hacemos clic derecho en el campo Value → File → File Content 

![A screenshot of a computer

Description automatically generated with medium confidence](./docs/Aspose.Words.a5f4cc92-1036-4da7-b86f-b455a71c891e.024.png)



- **Response**

Recibiremos un 200 OK en caso correcto, y nos devolverá los datos del shelter actualizado

![A screenshot of a computer screen

Description automatically generated](./docs/Aspose.Words.a5f4cc92-1036-4da7-b86f-b455a71c891e.025.png)





### Get image

Es una request parta comprobar la subida imagenes visualizar la imagen anteriormente subida en el endpoint anterior al “Public Directory” del servidor, cuya dirección es [http://127.0.0.1:8080/{id_shelter.png}](http://127.0.0.1:8080/%7Bid_shelter.png%7D)

- **Request**

Para realizar este endpoint vamos al endpoint anterior Shelters y dentro de la respuesta, hacemos clic con el botón derecho en el id de un shelter y seleccionamos la opción “copy as dynamic value” y lo pegamos en la url para crear el endpoint con el formato mencionado anteriormente id\_shelter + .png. En nuestro caso, hemos cogido la primera posición.

![](./docs/api-013.png)


Sera un GET al endpoint anterior, compuesto por :

![](./docs/api-026.png)


- ` `Headers → Debe de ir la variable de entorno ApiKey, ademas de un Authorization Bearer {SignIn\_token}, haciendo un” copy as dynamic value” de la respuesta recibida en el endpoint Sign In, ya que para que un Shelter pueda descargar su imagen es necesario que previamente se haya registrado y autenticado en la aplicación:



![Graphical user interface, text, application

Description automatically generated](./docs/Aspose.Words.a5f4cc92-1036-4da7-b86f-b455a71c891e.027.png)

- **Response**

Hacemos clic en actualizar y enviamos la petición, si la respuesta es satisfactoria recibimos un código 200 OK y nos devolverá la imagen asociada al id del shelter, seleccionando el tipo de respuesta como imagen:

![](./docs/api0-028.png)



