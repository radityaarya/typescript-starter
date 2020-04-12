FROM node:12-alpine as dist
WORKDIR /tmp/
COPY package.json package-lock.json tsconfig.json tsconfig.build.json ./
COPY src/ src/
RUN npm install && npm run build

FROM node:12-alpine as node_modules
WORKDIR /tmp/
COPY package.json package-lock.json ./
RUN npm install --production

FROM node:12-alpine
RUN apk add --no-cache ca-certificates
WORKDIR /usr/local/apps
COPY --from=node_modules /tmp/node_modules ./node_modules
COPY --from=dist /tmp/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"]
