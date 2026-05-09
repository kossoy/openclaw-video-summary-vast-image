FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.local/bin:/root/.deno/bin:/opt/conda/bin:${PATH}" \
    HF_HOME="/root/.cache/huggingface" \
    HF_HUB_DISABLE_XET=1 \
    HF_HUB_DOWNLOAD_TIMEOUT=120 \
    UV_SYSTEM_PYTHON=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      ffmpeg \
      openssh-client \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && curl -fsSL https://deno.land/install.sh | sh -s -- -y

RUN uv pip install --python /opt/conda/bin/python --system \
      "faster-whisper>=1.1.1" \
      yt-dlp

RUN /opt/conda/bin/python - <<'PY'
from faster_whisper import WhisperModel

WhisperModel("large-v3-turbo", device="cpu", compute_type="int8")
PY

RUN ffmpeg -version >/dev/null \
    && deno --version >/dev/null \
    && uv --version >/dev/null \
    && yt-dlp --version >/dev/null \
    && /opt/conda/bin/python - <<'PY'
from faster_whisper import WhisperModel

print("faster-whisper import ok")
PY

LABEL org.opencontainers.image.title="OpenClaw video-summary Vast worker" \
      org.opencontainers.image.description="CUDA PyTorch runtime with ffmpeg, uv, deno, yt-dlp, faster-whisper, and cached large-v3-turbo model for OpenClaw video-summary." \
      org.opencontainers.image.source="https://github.com/kossoy/openclaw-video-summary-vast-image"
