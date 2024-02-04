FROM python:3.9-slim-buster AS builder
RUN apt update && apt install git gcc libssl-dev -y

RUN mkdir asksonic && cd asksonic
ADD . /asksonic
WORKDIR /asksonic
RUN pip install --user wheel setuptools honcho
RUN pip install --user -r requirements.txt

FROM python:3.9-slim-buster
COPY --from=builder /asksonic /opt
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
WORKDIR /opt
ENTRYPOINT ["honcho", "start", "-f", "Procfile.dev"]
