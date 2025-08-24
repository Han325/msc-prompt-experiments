#!/bin/bash

# --- EXPERIMENT 1: Endpoint Test with "Fresh Take" Prompts ---

GENERATE_PROMPT="prompt_generate_fresh_take_21.json"
CHAT_PROMPT="prompt_chat_fresh_take_21.json"
NUM_PARAMS=21
MODEL="qwen2.5:7b"

echo "===== FRESH TAKE: ENDPOINT PERFORMANCE COMPARISON ====="
echo "Model: $MODEL"
echo "Batch Size: $NUM_PARAMS parameters"
echo "======================================================="
echo

# --- Function to run /api/generate ---
run_generate_test() {
    echo "--- BENCHMARKING /api/generate ---"
    if [ ! -f "$GENERATE_PROMPT" ]; then echo "Error: Missing $GENERATE_PROMPT"; return; fi
    START_TIME=$(date +%s.%N)
    curl -s -X POST http://localhost:11434/api/generate -d @"$GENERATE_PROMPT" > /dev/null
    END_TIME=$(date +%s.%N)
    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)
    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------------"
    echo
}

# --- Function to run /api/chat ---
run_chat_test() {
    echo "--- BENCHMARKING /api/chat ---"
    if [ ! -f "$CHAT_PROMPT" ]; then echo "Error: Missing $CHAT_PROMPT"; return; fi
    START_TIME=$(date +%s.%N)
    curl -s -X POST http://localhost:11434/api/chat -d @"$CHAT_PROMPT" > /dev/null
    END_TIME=$(date +%s.%N)
    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)
    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------"
    echo
}

run_generate_test
run_chat_test