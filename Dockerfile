FROM node:10.15.3 as source
WORKDIR /src/build-your-own-radar
COPY package.json ./
RUN npm install
COPY . ./
ARG CSV_FILE_URL=http://localhost/source.csv
ENV CSV_FILE_URL $CSV_FILE_URL
RUN npm run build

FROM nginx:1.15.9
WORKDIR /opt/build-your-own-radar
COPY --from=source /src/build-your-own-radar/dist .
COPY default.template /etc/nginx/conf.d/default.conf
COPY source.csv /opt/build-your-own-radar/source.csv
CMD ["nginx", "-g", "daemon off;"]
