 🐧 Nagios Core en Docker

Este proyecto contiene un `Dockerfile` que construye una imagen personalizada de **Nagios Core 4.5.9** con **Nagios Plugins 2.4.9**, sobre **Ubuntu 22.04**, con Apache configurado para acceso web.

> El script `entrypoint.sh` que inicia Apache y Nagios se genera automáticamente durante la construcción de la imagen, por lo tanto, **no está incluido en este repositorio**.

---

## 📁 Contenido del repositorio

- `Dockerfile`: define el entorno completo.
- `README.md`: este documento con instrucciones.
- `.gitignore`: opcional, para ignorar archivos temporales locales.

---

## 🛠 Requisitos

- Docker instalado (versión 20.10 o superior)
- Acceso a internet para descargar dependencias durante el build

---

## 🧱 Construcción de la imagen

Desde la carpeta raíz del proyecto, ejecuta:

```bash
docker build -t nagios-final:v1.0 .
```

Esto crea la imagen `nagios-final` con la etiqueta `v1.0`.

---

## 🚀 Ejecución del contenedor

Para iniciar el contenedor y exponer el puerto web:

```bash
docker run -d -p 8080:80 --name nagios nagios-final:v1.0
```

Luego abre en tu navegador:

```
http://localhost:8080
```

### 🔐 Acceso a la interfaz web

- **Usuario**: `nagiosadmin`  
- **Contraseña**: `nagiosadmin`

---

## 🧼 Limpieza

Para detener y eliminar el contenedor:

```bash
docker stop nagios
docker rm nagios
```

Para eliminar la imagen si deseas reconstruirla:

```bash
docker rmi nagios-final:v1.0
```

---

## 📬 Autor

**Fabián Díaz**  
fa-diazp@duocuc.cl
