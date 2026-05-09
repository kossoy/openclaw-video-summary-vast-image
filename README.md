# OpenClaw video-summary Vast image

Prebuilt CUDA runtime for the OpenClaw `video-summary` skill.

It bakes in:

- `ffmpeg`
- `uv`
- `deno`
- `yt-dlp`
- `faster-whisper`
- cached `large-v3-turbo` faster-whisper model

Published image:

```text
ghcr.io/kossoy/openclaw-video-summary-vast:cuda12.4
```

The image is intended for short-lived Vast.ai workers. It removes most of the
cold-start time otherwise spent installing packages and downloading the Whisper
model.
