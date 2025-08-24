#!/bin/bash

# --- Script to compare /api/generate vs /api/chat performance ---

# --- CONFIGURATION ---
GENERATE_PROMPT_FILE="prompt_generate_21.json"
CHAT_PROMPT_FILE="prompt_chat_21.json"
NUM_PARAMS=21
# ---------------------

echo "===== EXPERIMENT 1: ENDPOINT PERFORMANCE COMPARISON ====="
echo "Model: qwen2.5:7b"
echo "Batch Size: $NUM_PARAMS parameters"
echo "========================================================="
echo

# --- Function to run and time /api/generate ---
run_generate_test() {
    echo "--- BENCHMARKING /api/generate ---"
    if [ ! -f "$GENERATE_PROMPT_FILE" ]; then
        echo "Error: Generate prompt file not found: $GENERATE_PROMPT_FILE"
        return
    fi
    
    START_TIME=$(date +%s.%N)
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate -d @"$GENERATE_PROMPT_FILE")
    END_TIME=$(date +%s.%N)
    
    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)

    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------------"
    echo
}

# --- Function to run and time /api/chat ---
run_chat_test() {
    echo "--- BENCHMARKING /api/chat ---"
    if [ ! -f "$CHAT_PROMPT_FILE" ]; then
        echo "Error: Chat prompt file not found: $CHAT_PROMPT_FILE"
        return
    fi

    START_TIME=$(date +%s.%N)
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/chat -d @"$CHAT_PROMPT_FILE")
    END_TIME=$(date +%s.%N)

    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)

    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------"
    echo
}

# --- Run both tests ---
run_generate_test
run_chat_test