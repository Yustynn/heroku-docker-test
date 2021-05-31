FROM golang:1.16.4-alpine3.12

EXPOSE 98
EXPOSE 99

### FRONTEND ###
WORKDIR /frontend
COPY example-frontend .
COPY example-backend /api


RUN apk add nodejs npm
RUN npm i -g serve
RUN npm i

ENV FRONTEND_PORT=98
ENV REACT_APP_BACKEND_URL=http://127.17.0.1:99
RUN npm run build

### BACKEND ###
WORKDIR /api
COPY example-backend .

ENV PORT=99
ENV REQUEST_ORIGIN=http://127.17.0.1:98
RUN go build

#CMD ["./server", "&", "serve", "-s", "-l", "$FRONTEND_PORT", "/frontend/build"]
#CMD ["serve", "-s", "-l", "$FRONTEND_PORT", "/frontend/build"]
CMD serve -s -l $FRONTEND_PORT /frontend/build & ./server
#CMD ["serve", "-s", "-l", "$FRONTEND_PORT", "/frontend/build"]
