FROM nvidia/cuda:12.5.1-runtime-ubuntu22.04


ENV DEBIAN_FRONTEND=noninteractive \
    PATH=/usr/local/bin:$PATH

RUN apt update && apt --quiet --no-install-recommends -y install \
    htop \
    git \
    curl \
    vim \
    tree \
    software-properties-common \
    python3-pip \
    python3-dev \
    python3-venv \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/* \
    && apt purge --auto-remove \
    && apt clean

RUN useradd --create-home --user-group app
RUN mkdir /app && chown app:app /app

USER app

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app

ENV VIRTUAL_ENV=/app/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH=$PATH:/user/local/bin:/home/app/.local/bin:${VIRTUAL_ENV}bin
WORKDIR /app
RUN /app/venv/bin/pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
RUN /app/venv/bin/pip3 install -r requirements.txt

CMD [ "/app/venv/bin/python3", "main.py", "--listen" ]