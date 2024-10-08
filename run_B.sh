#!/bin/bash
 
# Create a directory for simulation results
mkdir -p Q2_B_results
 
TRACE_DIR=$PWD/traces
 
predictor="tage"
 
# Array of trace files
traces=("cassandra_phase5_core0.trace.xz" "streaming_phase0_core1.trace.xz" "cloud9_phase5_core3.trace.xz" "631.deepsjeng_s-928B.champsimtrace.xz")
 

# Function to update the specified lines in the .h file
V1() {
    # Display the updated values directly from the .h file before the first update
    echo "Updated values in header file before first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
 
    # First update
    sed -i 's/#define TAGE_MAX_INDEX_BITS 14/#define TAGE_MAX_INDEX_BITS 15/' branch/tage.h
    sed -i 's/const uint8_t TAGE_INDEX_BITS\[TAGE_NUM_COMPONENTS\] = {14,\s*14,\s*13,\s*12};/const uint8_t TAGE_INDEX_BITS[TAGE_NUM_COMPONENTS] = {15, 13, 12, 10};/' branch/tage.h
    sed -i 's/const uint8_t TAGE_TAG_BITS\[TAGE_NUM_COMPONENTS\] = {7,\s*6,\s*5,\s*4};/const uint8_t TAGE_TAG_BITS[TAGE_NUM_COMPONENTS] = {6, 5, 4, 4};/' branch/tage.h
 
    # Display the updated values directly from the .h file after the first update
    echo "Updated values in header file after first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
}
 
V2() {
    # Display the updated values directly from the .h file before the first update
    echo "Updated values in header file before first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
 
    # Second update
    sed -i 's/#define TAGE_MAX_INDEX_BITS 15/#define TAGE_MAX_INDEX_BITS 14/' branch/tage.h
    sed -i 's/const uint8_t TAGE_INDEX_BITS\[TAGE_NUM_COMPONENTS\] = {15,\s*13,\s*12,\s*10};/const uint8_t TAGE_INDEX_BITS[TAGE_NUM_COMPONENTS] = {14, 13, 13, 13};/' branch/tage.h
    sed -i 's/const uint8_t TAGE_TAG_BITS\[TAGE_NUM_COMPONENTS\] = {6,\s*5,\s*4,\s*4};/const uint8_t TAGE_TAG_BITS[TAGE_NUM_COMPONENTS] = {10, 6, 5, 4};/' branch/tage.h
 
    # Display the updated values directly from the .h file after the first update
    echo "Updated values in header file after first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
}
 

V3() {
    # Display the updated values directly from the .h file before the first update
    echo "Updated values in header file before first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
 
    # Fourth update
    sed -i 's/#define TAGE_MAX_INDEX_BITS 14/#define TAGE_MAX_INDEX_BITS 15/' branch/tage.h
    sed -i 's/const uint8_t TAGE_INDEX_BITS\[TAGE_NUM_COMPONENTS\] = {14,\s*13,\s*13,\s*13};/const uint8_t TAGE_INDEX_BITS[TAGE_NUM_COMPONENTS] = {15, 11, 10, 10};/' branch/tage.h
    sed -i 's/const uint8_t TAGE_TAG_BITS\[TAGE_NUM_COMPONENTS\] = {10,\s*6,\s*5,\s*4};/const uint8_t TAGE_TAG_BITS[TAGE_NUM_COMPONENTS] = {9, 7, 5, 4};/' branch/tage.h
 
    # Display the updated values directly from the .h file after the first update
    echo "Updated values in header file after first update:"
    echo "1. TAGE_MAX_INDEX_BITS: $(grep '#define TAGE_MAX_INDEX_BITS' branch/tage.h)"
    echo "2. TAGE_INDEX_BITS: $(grep 'const uint8_t TAGE_INDEX_BITS' branch/tage.h)"
    echo "3. TAGE_TAG_BITS: $(grep 'const uint8_t TAGE_TAG_BITS' branch/tage.h)"
    echo "-----------------------------------"
}
 
 
 
 
for func in V1 V2 V3
do
    echo "Calling $func"
    $func  # Call the function by name
 
    output_file="Q2_B_results/"$func"_TAGE_simulation_output.txt"
    
    ./build_champsim.sh $predictor no no no next_line lru 1

    for trace in "${traces[@]}"; do
        echo "Running simulation for $trace with $predictor predictor..." >> "$output_file"
 
        echo "before run"
 
        if [ "$trace" = "631.deepsjeng_s-928B.champsimtrace.xz" ]; then
            # echo "if"
            ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 200000000 -simulation_instructions 500000000 -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
        else
            # echo "else"
            ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 200000000 -simulation_instructions 500000000 -c -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
        fi

        echo "after run"
 
        # Add space between outputs
        echo -e "\n\n" >> "$output_file"
    done
 
echo "All simulations completed for all predictors."
 
done
 
 
sed -i 's/#define TAGE_MAX_INDEX_BITS 15/#define TAGE_MAX_INDEX_BITS 14/' branch/tage.h
sed -i 's/const uint8_t TAGE_INDEX_BITS\[TAGE_NUM_COMPONENTS\] = {15,\s*11,\s*10,\s*10};/const uint8_t TAGE_INDEX_BITS[TAGE_NUM_COMPONENTS] = {14, 14, 13, 12};/' branch/tage.h
sed -i 's/const uint8_t TAGE_TAG_BITS\[TAGE_NUM_COMPONENTS\] = {9,\s*7,\s*5,\s*4};/const uint8_t TAGE_TAG_BITS[TAGE_NUM_COMPONENTS] = {7, 6, 5, 4};/' branch/tage.h
 