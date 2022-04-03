FROM python:slim AS build

USER root
WORKDIR /builder

COPY . .
RUN pip3 install -r requirements.txt && \
    python3 setup.py sdist && \
    python3 setup.py bdist_wheel

FROM python:slim AS dist
ARG UID=4637
ARG GID=4637
USER root
WORKDIR /tmp
COPY --from=build /builder/dist/*.whl .
RUN groupadd -g $GID -o parsedmarc && \
    useradd -m -u $UID -g $GID -o -s /bin/bash parsedmarc && \
    pip3 install /tmp/*.whl
WORKDIR /app
USER parsedmarc
CMD [ "/usr/local/bin/parsedmarc","--config-file","/etc/parsedmarc.ini" ]

