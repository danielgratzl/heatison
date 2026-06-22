FROM alpine AS build
RUN apk add --no-cache gettext
WORKDIR /app
COPY index.html .
RUN envsubst '$FIREBASE_API_KEY $FIREBASE_AUTH_DOMAIN $FIREBASE_DATABASE_URL $FIREBASE_PROJECT_ID $FIREBASE_STORAGE_BUCKET $FIREBASE_MESSAGING_SENDER_ID $FIREBASE_APP_ID' < index.html > index.built.html

FROM nginx:alpine
COPY --from=build /app/index.built.html /usr/share/nginx/html/index.html
