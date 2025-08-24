#!/bin/bash

# --- Script to compare 7b vs 3b model performance AND save their output ---

# --- CONFIGURATION ---
PROMPT_FILE_7B="prompt_chat_21.json"
PROMPT_FILE_3B="prompt_chat_21_3b.json"
NUM_PARAMS=21
# Output files will be named based on the model
OUTPUT_FILE_7B="response_7b.json"
OUTPUT_FILE_3B="response_3b.json"
# ---------------------

echo "===== EXPERIMENT 2: MODEL PERFORMANCE & QUALITY COMPARISON ====="
echo "Endpoint: /api/chat"
echo "Batch Size: $NUM_PARAMS parameters"
echo "================================================================"
echo

# --- Function to run a single chat test and save the output ---
run_chat_test() {
    local prompt_file=$1
    local model_name=$2
    local output_file=$3 # New argument for the output file name

    echo "--- BENCHMARKING MODEL: $model_name ---"
    if [ ! -f "$prompt_file" ]; then
        echo "Error: Prompt file not found: $prompt_file"
        return
    fi
    
    START_TIME=$(date +%s.%N)
    # The response is now saved to a variable AND written to a file
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/chat -d @"$prompt_file")
    END_TIME=$(date +%s.%N)

    # Save the full, raw response to its output file
    echo "$RESPONSE" > "$output_file"
    echo "Full response saved to: $output_file"
    
    TOTAL_SECONDS=$(echo "$END_TIME - $START_TIME" | bc)
    TIME_PER_PARAM=$(echo "scale=4; $TOTAL_SECONDS / $NUM_PARAMS" | bc)

    echo "Total Time Taken:  ${TOTAL_SECONDS}s"
    echo "Time per Parameter: ${TIME_PER_PARAM}s"
    echo "------------------------------------------------"
    echo
}

# --- Run both tests, passing the correct output file for each ---
run_chat_test "$PROMPT_FILE_7B" "qwen2.5:7b" "$OUTPUT_FILE_7B"
run_chat_test "$PROMPT_FILE_3B" "qwen2.5:3b" "$OUTPUT_FILE_3B"

echo "===== BENCHMARK COMPLETE ====="
echo "You can now compare the quality of the two models by inspecting the output files:"
echo "-> $OUTPUT_FILE_7B"
echo "-> $OUTPUT_FILE_3B"
echo "Use a diff tool for a side-by-side comparison, e.g., 'code --diff $OUTPUT_FILE_7B $OUTPUT_FILE_3B'"