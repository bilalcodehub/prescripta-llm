FROM vllm/vllm-openai:latest

# Pre-download model on build (optional — can also download on first run)
# RUN python -c "from huggingface_hub import snapshot_download; snapshot_download('Qwen/Qwen3.5-35B-A3B-AWQ', cache_dir='/models')"

EXPOSE 11007

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]
