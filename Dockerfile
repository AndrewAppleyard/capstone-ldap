# syntax=docker/dockerfile:1
ARG BUILD_IMAGE=opensuse/tumbleweed
ARG RUN_IMAGE=389ds/dirsrv:2.4

FROM ${BUILD_IMAGE} as builder
USER root
WORKDIR /
COPY . /app

RUN mkdir /unicopy \
    && cp /app/scripts/container-entrypoint.sh /unicopy \
    && cp /app/scripts/container-healthcheck.sh /unicopy \
    && cp /app/scripts/once.sh /unicopy

FROM ${RUN_IMAGE} as runner
COPY --from=builder /unicopy /
RUN zypper install -y openldap2-client tini \
    && mkdir /container-entrypoint-initdb.d \
    && /once.sh
ENTRYPOINT ["/sbin/tini", "--", "/container-entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --start-interval=5s --retries=5 CMD /container-healthcheck.sh