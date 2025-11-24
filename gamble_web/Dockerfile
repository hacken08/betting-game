
FROM node:24-alpine

WORKDIR /web_app

COPY ./package*.json /web_app
RUN npm instal -g pnpm
RUN pnpm install
RUN pnpm install @ant-design/icons
COPY . /web_app

RUN pnpm build
LABEL Name="Admin_gamble_web"
LABEL Version="0.1"

EXPOSE 8080
CMD [ "pnpm", "start" ]
