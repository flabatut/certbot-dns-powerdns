FROM python:3.9-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN apt update \
    && apt install -y gcc make \
    && pip install --upgrade pip \
    && pip install wheel setuptools \
    && pip wheel -r requirements.txt --wheel-dir=/build/wheels

FROM python:3.9-slim
COPY --from=builder /build /build
RUN pip install --no-index --find-links=/build/wheels -r /build/requirements.txt \
    && rm -rf /build
ENTRYPOINT ["/usr/local/bin/certbot"]