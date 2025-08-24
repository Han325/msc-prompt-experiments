#!/bin/bash

# --- EXPERIMENT 2: Model Test with "Fresh Take" Prompts on /api/generate ---

# --- CONFIGURATION ---
# You will need to create these two files.
PROMPT_FILE_7B="prompt_generate_fresh_take_21.json"
PROMPT_FILE_3B="prompt_generate_fresh_take_21_3b.json"
NUM_PARAMS=21

# Output files will be named based on the model
OUTPUT_FILE_7B="response_fresh_take_7b.json"
OUTPUT_FILE_3B="response_fresh_take_3b.json"
# ---------------------

echo "===== FRESH TAKE: MODEL PERFORMANCE & QUALITY COMPARISON ====="
echo "Endpoint: /api/generate"
echo "Batch Size: $NUM_PARAMS parameters"
echo "==============================================================="
echo

# --- Function to run a single generate test ---
run_generate_test() {
    local prompt_file=$1
    local model_name=$2
    local output_file=$3

    echo "--- BENCHMARKING MODEL: $model_name ---"
    if [ ! -f "$prompt_file" ]; then
        echo "Error: Prompt file not found: $prompt_file"
        return
    fi
    
    START_TIME=$(date +%s.%N)
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate -d @"$prompt_file")
    END_TIME=$(date +%s.%N)
    
    echo "$RESPONSE" > "$output_file"
    echo "Full response saved to: $output_file"

    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)

    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------------------------"
    echo
}

# --- Run both tests ---
run_generate_test "$PROMPT_FILE_7B" "qwen2.5:7b" "$OUTPUT_FILE_7B"
run_generate_test "$PROMPT_FILE_3B" "qwen2.5:3b" "$OUTPUT_FILE_3B"

echo "===== BENCHMARK COMPLETE ====="
echo "You can now compare the quality of the two models by inspecting the output files:"
echo "-> $OUTPUT_FILE_7B"
echo "-> $OUTPUT_FILE_3B"