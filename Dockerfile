FROM node:14.19.3-alpine

# instalar un simple servidor http para servir nuestro contenido estático
RUN npm i npm@latest -g 
RUN npm install -g http-server

# hacer la carpeta 'app' el directorio de trabajo actual
WORKDIR /app

# copiar 'package.json' y 'package-lock.json' (si están disponibles)
COPY package*.json ./

# instalar dependencias del proyecto
RUN npm install

# copiar los archivos y carpetas del proyecto al directorio de trabajo actual (es decir, la carpeta 'app')
COPY . .

# construir aplicación para desarollo
#EXPOSE 9402
#CMD npm run serve

# construir aplicación para producción minificada
RUN npm run build

EXPOSE 9402
CMD ["http-server", "dist", "-p", "9402"]

# docker build . -t carolinedesousa/prueba-coches-front:latest
# docker push carolinedesousa/prueba-coches-front:latest