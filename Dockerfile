FROM node:20-alpine

WORKDIR /app
COPY package*.json .

RUN npm i
COPY . .
CMD ["npm", "start"]

EXPOSE 3001