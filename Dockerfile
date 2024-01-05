# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4

ARG VERSION=0.67.0

# x86_64 or aarch64
ARG ARCH=aarch64 

ENV RELEASE PortfolioPerformance-${VERSION}-linux.gtk.${ARCH}.tar.gz
ENV ARCHIVE https://github.com/buchen/portfolio/releases/download/${VERSION}/${RELEASE}
ENV APP_ICON_URL=https://www.portfolio-performance.info/images/logo.png

RUN apt-get update && apt-get install -y wget && \
    cd /opt && wget ${ARCHIVE} && tar xvzf ${RELEASE} && \
    rm ${RELEASE}

# Install dependencies.
RUN \
    apt-get install -y \
    openjdk-17-jre \
    libwebkit2gtk-4.0-37 

RUN \
    # Write config entry for new data folder, cause otherwise pp would try to write in /dev which is not possible
    echo "-data\n/config/portfolio\n$(cat /opt/portfolio/PortfolioPerformance.ini)" > /opt/portfolio/PortfolioPerformance.ini && \
    # Set initial language to english
    echo "osgi.nl=en" >> /opt/portfolio/configuration/config.ini && \
    chmod -R 777 /opt/portfolio && \
    install_app_icon.sh "$APP_ICON_URL"

# Copy the start script.
COPY rootfs/ /

# Set the name of the application.
ENV APP_NAME="Portfolio Performance"