FROM arm32v6/alpine

COPY ./qemu-arm-static /usr/bin/qemu-arm-static
RUN apk --no-cache add curl g++ gcc git make
RUN mkdir -p /tmp/build
RUN curl https://raw.githubusercontent.com/ioquake/ioq3/master/misc/linux/server_compile.sh -o /tmp/build/compile.sh
RUN curl https://ioquake3.org/data/quake3-latest-pk3s.zip --referer https://ioquake3.org/extras/patch-data/ -o /tmp/build/quake3-latest-pk3s.zip
RUN echo 'y' | sh /tmp/build/compile.sh
RUN unzip /tmp/build/quake3-latest-pk3s.zip -d /tmp/build/
RUN cp -r /tmp/build/quake3-latest-pk3s/* ~/ioquake3
RUN mkdir -p /data/maps

FROM arm32v6/alpine
LABEL maintainer="wouterds <wouter.de.schuyter@gmail.com>"

COPY ./qemu-arm-static /usr/bin/qemu-arm-static
COPY --from=0 /root/ioquake3 /home/ioq3srv/ioquake3
RUN ln -sf /data/pak0.pk3 /home/ioq3srv/ioquake3/baseq3/pak0.pk3 && \
  ln -sf /data/server.cfg /home/ioq3srv/ioquake3/baseq3/server.cfg && \
  adduser ioq3srv -D && \
  rm -r /usr/bin/qemu-arm-static
RUN ln -s /data/maps /home/ioq3srv/ioquake3/baseq3

USER ioq3srv
EXPOSE 27960

ENTRYPOINT ["/home/ioq3srv/ioquake3/ioq3ded.arm", "+exec", "server.cfg"]
