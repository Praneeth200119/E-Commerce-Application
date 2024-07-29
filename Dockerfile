#WORKDIR /app
#COPY package*.json ./
#RUN npm install --legacy-peer-deps
#COPY . .
#EXPOSE 3000
#CMD ["npm", "start"]

FROM node:16.17.0 as builder
WORKDIR /app
COPY ./package.json .
COPY . .
RUN npm install --legacy-peer-deps
RUN npm run build --prod

FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]


#groups $USER
#sudo usermod -aG docker $USER
#ls -l /var/run/docker.sock
#sudo chown root:docker /var/run/docker.sock
#sudo chmod 660 /var/run/docker.sock
#sudo reboot
