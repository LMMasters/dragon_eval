FROM python:3.10-slim

RUN groupadd -r user && useradd -m --no-log-init -r -g user user

RUN mkdir -p /opt/app /input /output \
    && chown user:user /opt/app /input /output

USER user
WORKDIR /opt/app

ENV PATH="/home/user/.local/bin:${PATH}"

RUN python -m pip install --user -U pip && python -m pip install --user pip-tools

COPY --chown=user:user requirements.txt /opt/app/
RUN python -m piptools sync requirements.txt

COPY --chown=user:user ground-truth /opt/app/ground-truth
COPY --chown=user:user . /opt/app/dragon_eval
RUN python -m pip install --user -e ./dragon_eval

ENTRYPOINT [ "python", "-m", "dragon_eval" ]


