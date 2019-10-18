FROM node:8

WORKDIR /financier
RUN npm install express@^4.13.0 helmet@^3.10.0 uuid helmet-csp@^2.7.0 cheerio@^0.22.0

ADD ./dist /financier/dist
ADD ./docs /financier/docs
ADD ./api /financier/api

WORKDIR /financier/api

EXPOSE 8080

# RUN apt-get install -y git-core

CMD node ./index.js
