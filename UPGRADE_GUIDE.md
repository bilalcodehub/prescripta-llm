# 🚀 Upgrade vLLM for Production (4 GPUs + Parallel Processing)

## 📊 Changes Needed:

### **1. GPU Count: 2 → 4**
```yaml
# BEFORE:
environment:
  - NVIDIA_VISIBLE_DEVICES=0,1
deploy:
  resources:
    reservations:
      devices:
        - count: 2

# AFTER:
environment:
  - NVIDIA_VISIBLE_DEVICES=0,1,2,3
deploy:
  resources:
    reservations:
      devices:
        - count: 4
```

### **2. Tensor Parallelism: 2 → 4**
```yaml
# BEFORE:
--tensor-parallel-size 2

# AFTER:
--tensor-parallel-size 4
```

### **3. Add Parallel Request Handling**
```yaml
# ADD these two flags:
--max-num-seqs 128
--enable-chunked-prefill
```

---

## 🔧 **On Server - Apply Changes:**

```bash
cd /data/mlworks/prescripta-llm

# 1. Backup current config
cp docker-compose.yml docker-compose.yml.BACKUP

# 2. Update docker-compose.yml with changes above
nano docker-compose.yml
# Make the 3 changes listed above

# 3. Restart vLLM
docker-compose down
docker-compose up -d

# 4. Wait 2-3 minutes for model loading on 4 GPUs

# 5. Verify it's running
curl http://localhost:11007/v1/models
```

---

## ✅ **What This Enables:**

- ✅ **All 4 L40S GPUs** used (tensor parallelism)
- ✅ **128 concurrent requests** (8 workers × 16 requests each)
- ✅ **Chunked prefill** (better throughput)
- ✅ **~10x faster** than current 2-GPU setup

---

## 📋 **Full Production docker-compose.yml:**

See `docker-compose.yml.PRODUCTION` file in this directory.

---

## ⚠️ **Important:**

- Model will reload (2-3 min downtime)
- GPU memory usage will increase (~90% across 4 GPUs)
- Check `nvidia-smi` after restart to verify all 4 GPUs active

**After upgrade, proceed with worker deployment from polaris-judge-production!**
