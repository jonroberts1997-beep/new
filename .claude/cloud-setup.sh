#!/bin/bash
# Cloud environment setup for the VSL video editor skill.
# Paste into the environment's Setup script setting so every new session has
# ffmpeg, faster-whisper and the Whisper "small" model ready.
# Each step warns instead of failing so a blocked download never stops the session.

if ! command -v ffmpeg >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq ffmpeg || echo "WARNING: ffmpeg install failed"
fi

python3 -m pip install -q faster-whisper \
  || python3 -m pip install -q --break-system-packages faster-whisper \
  || echo "WARNING: faster-whisper install failed"

# Pre-download the Whisper model so the first transcription doesn't wait on it.
python3 -c "from faster_whisper import WhisperModel; WhisperModel('small', device='cpu', compute_type='int8')" \
  || echo "WARNING: Whisper model download failed (are *.hf.co hosts allowed in Network access?)"

exit 0
