# MSc SSE Individual Research Project Submission Details

This markdown document contains the details of the code artifiact submissions made for the MSc research project.

## About
This repository contains the prompts that were used to evaluate the different performances between a SLM model with various different parameter sizes.

# SLM Model Performance Testing

A benchmarking suite for comparing different AI models (Qwen 2.5 7B vs 3B) and API endpoints (`/api/generate` vs `/api/chat`) for test data generation tasks.

## What This Does

Tests AI models on generating suggestions for wallet management app parameters. Models receive 21 test parameters and must suggest improved values while following strict enum constraints.

## Files

### Test Data
- `prompt_*.json` - Input prompts for different models/endpoints
- `response_*.json` - AI model outputs for comparison
- `diff.diff` - Shows differences between 7B and 3B model responses

### Benchmark Scripts
- `run_endpoint_test.sh` - Compare `/api/generate` vs `/api/chat` performance
- `run_model_test.sh` - Compare 7B vs 3B model quality/speed
- `run_*_fresh_take.sh` - Variants that test "fresh generation" (no initial values)
- `run_*_with_output.sh` - Save full responses for quality analysis

## Key Findings

The 3B model struggles with enum constraints and generates invalid values like `"WalletNames.PERSONAL"` instead of just `"PERSONAL"`. The 7B model follows instructions more reliably but is ~2.5x slower.

## Usage

```bash
# Compare API endpoints
./run_endpoint_test.sh

# Compare model sizes  
./run_model_test_with_output.sh

# Then diff the outputs
diff response_7b.json response_3b.json
```

Requires local Ollama server running on port 11434.
