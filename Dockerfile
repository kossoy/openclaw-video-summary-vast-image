FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/opt/video-summary-venv/bin:/root/.local/bin:/root/.deno/bin:${PATH}" \
    HF_HOME="/root/.cache/huggingface" \
    HF_HUB_DISABLE_XET=1 \
    HF_HUB_DOWNLOAD_TIMEOUT=120

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      ffmpeg \
      openssh-client \
      python3 \
      python3-venv \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && curl -fsSL https://deno.land/install.sh | sh -s -- -y

RUN uv venv /opt/video-summary-venv \
    && uv pip install --python /opt/video-summary-venv/bin/python \
      "faster-whisper>=1.1.1" \
      yt-dlp

RUN /opt/video-summary-venv/bin/python - <<'PY'
from faster_whisper import WhisperModel

WhisperModel("large-v3-turbo", device="cpu", compute_type="int8")
PY

RUN ffmpeg -version >/dev/null \
    && deno --version >/dev/null \
    && uv --version >/dev/null \
    && yt-dlp --version >/dev/null \
    && python3 - <<'PY'
from faster_whisper import WhisperModel

print("faster-whisper import ok")
PY

LABEL org.opencontainers.image.title="OpenClaw video-summary Vast worker" \
      org.opencontainers.image.description="Slim CUDA runtime with ffmpeg, uv, deno, yt-dlp, faster-whisper, and cached large-v3-turbo model for OpenClaw video-summary." \
      org.opencontainers.image.source="https://github.com/kossoy/openclaw-video-summary-vast-image"
