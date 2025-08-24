#!/bin/bash

# --- Script to compare 7b vs 3b model performance on the /api/chat endpoint ---

# --- CONFIGURATION ---
PROMPT_FILE_7B="prompt_chat_21.json"
PROMPT_FILE_3B="prompt_chat_21_3b.json"
NUM_PARAMS=21
# ---------------------

echo "===== EXPERIMENT 2: MODEL PERFORMANCE COMPARISON ====="
echo "Endpoint: /api/chat"
echo "Batch Size: $NUM_PARAMS parameters"
echo "======================================================"
echo

# --- Function to run a single chat test ---
run_chat_test() {
    local prompt_file=$1
    local model_name=$2

    echo "--- BENCHMARKING MODEL: $model_name ---"
    if [ ! -f "$prompt_file" ]; then
        echo "Error: Prompt file not found: $prompt_file"
        return
    fi
    
    START_TIME=$(date +%s.%N)
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/chat -d @"$prompt_file")
    END_TIME=$(date +%s.%N)
    
    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)

    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "-------------------------------------"
    echo
}

# --- Run both tests ---
run_chat_test "$PROMPT_FILE_7B" "qwen2.5:7b"
run_chat_test "$PROMPT_FILE_3B" "qwen2.5:3b"