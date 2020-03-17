FROM lsiobase/nginx:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BARCODEBUDDY_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips, homerr"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	git && \
	# composer \
	# yarn && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	php7 \
	php-sqlite3 \
	php-curl && \
	# php7-gd \
	# php7-pdo \
	# php7-pdo_sqlite \
	# php7-tokenizer && \
 echo "**** install barcodebuddy ****" && \
 mkdir -p /app/barcodebuddy && \
# chown abc:abc -R /app/barcodebuddy && \
 # echo "**** barcodebuddy folder created ****" && \
 if [ -z ${BARCODEBUDDY_RELEASE+x} ]; then \
	BARCODEBUDDY_RELEASE=$(curl -sX GET "https://api.github.com/repos/Forceu/barcodebuddy/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
    # echo "**** if statement evaluated true ****" && \
 fi && \
 echo "BARCODEBUDDY_RELEASE=${BARCODEBUDDY_RELEASE}" && \
 curl -o \
	/tmp/barcodebuddy.tar.gz -L \
	"https://github.com/Forceu/barcodebuddy/archive/${BARCODEBUDDY_RELEASE}.tar.gz" && \
 tar xf \
	/tmp/barcodebuddy.tar.gz -C \
	/app/barcodebuddy/ --strip-components=1 && \
 # chown abc:abc -R /app/barcodebuddy && \
 # cp -R /app/grocy/data/plugins \
	# /defaults/plugins && \
 # echo "**** install composer packages ****" && \
 # composer install -d /app/grocy --no-dev && \
 # echo "**** install yarn packages ****" && \
 # cd /app/barcodebuddy && \
 # yarn && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
