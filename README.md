# prescripta-llm

Local LLM serving for Prescripta — vLLM + Qwen3.5-35B-A3B-AWQ on L40S (48GB).

## Architecture

Exposes an **OpenAI-compatible API** at `http://<host>:11007/v1/`.
Prescripta-app connects to it by setting:
- `LLM_BASE_URL=http://<this-machine>:11007/v1`
- `LLM_MODEL=prescripta-judge`

## Quick start

```bash
# 1. Clone to Machine C (L40S instance)
git clone <repo-url> prescripta-llm
cd prescripta-llm

# 2. Set up env
cp .env.example .env
# Edit .env if needed (HF_TOKEN for gated models)

# 3. Build and run
docker compose up -d

# First run downloads ~20GB model — takes 5-10 min
# Check logs:
docker compose logs -f
```

## Testing the API

```bash
# Health check
curl http://localhost:11007/health

# List models
curl http://localhost:11007/v1/models

# Chat completion (OpenAI-compatible)
curl http://localhost:11007/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "prescripta-judge",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 100
  }'
```

## Hardware requirements

- **GPU**: 1x NVIDIA L40S (48GB VRAM)
- **RAM**: 64GB+ recommended
- **Disk**: 50GB for model weights + Docker image
- **NVIDIA driver**: 535+ with CUDA 12.1+

## Model details

- **Model**: Qwen3.5-35B-A3B-AWQ (4-bit quantized)
- **Architecture**: 35B MoE, 3B active parameters per token
- **Context**: 16,384 tokens (configurable up to 131k)
- **Reasoning**: Native thinking mode enabled
