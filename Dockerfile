FROM node:20-alpine

WORKDIR /app
COPY package*.json .

RUN npm i
COPY . .
CMD ["npm", "start"]

# overriden by env-var
EXPOSE 15777

# override default server port
#CMD ["sh", "-c", "PORT=${PORT:-15777} npm start"]