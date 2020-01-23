# Stage 1: Build libvirt exporter
FROM golang:alpine

ENV libvirt_version 3.8.0

# Install dependencies
RUN set -ex
RUN apk add --update git gcc g++ make libc-dev portablexdr-dev linux-headers libnl-dev perl libtirpc-dev pkgconfig wget python python-dev libxslt upx
RUN wget ftp://xmlsoft.org/libxml2/LATEST_LIBXML2 -P /tmp && \
    tar -xf /tmp/LATEST_LIBXML2 -C /tmp
RUN cd /tmp/libxml2* && ./configure --disable-shared --enable-static && \
    make -j$(nproc) && \
    make install
RUN wget https://libvirt.org/sources/libvirt-${libvirt_version}.tar.xz -P /tmp && \
    tar -xf /tmp/libvirt-${libvirt_version}.tar.xz -C /tmp
WORKDIR /tmp/libvirt-${libvirt_version}
RUN ./configure --disable-shared --enable-static --localstatedir=/var --without-storage-mpath && \
    make -j$(nproc) && \
    make install && \
    sed -i 's/^Libs:.*/& -lnl -ltirpc -lxml2/' /usr/local/lib/pkgconfig/libvirt.pc

# Prepare working directory
ENV LIBVIRT_EXPORTER_PATH=/go/src/github.com/rumanzo/libvirt_exporter_improved
RUN mkdir -p $LIBVIRT_EXPORTER_PATH
WORKDIR $LIBVIRT_EXPORTER_PATH
COPY . .

# Build and strip exporter
RUN go get -d ./... && \
    go build --ldflags '-extldflags "-static"' && \
    strip libvirt-exporter

# Stage 2: Prepare final image
FROM scratch

# Copy binary from Stage 1
COPY --from=0 /go/src/github.com/rumanzo/libvirt_exporter_improved/libvirt-exporter .

# Entrypoint for starting exporter
ENTRYPOINT [ "./libvirt-exporter" ]
