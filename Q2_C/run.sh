#!/bin/bash

# Array of predictors
predictors=("hybrid")

# Array of output files corresponding to each predictor
output_files=("hybrid_output_75_25.txt")

# Array of trace files
traces=("cassandra_phase5_core0.trace.xz" "streaming_phase0_core1.trace.xz" "cloud9_phase5_core3.trace.xz" "631.deepsjeng_s-928B.champsimtrace.xz")

# Loop through each predictor
for i in "${!predictors[@]}"; do
    predictor="${predictors[$i]}"
    output_file="${output_files[$i]}"

    # Clear the output file
    > "$output_file"

    # Modify the config file to change the branch predictor
    sed -i "s/\"branch_predictor\": \".*\"/\"branch_predictor\": \"$predictor\"/" champsim_config.json

    # Confirm that the config file has been updated
    current_predictor=$(grep "\"branch_predictor\"" champsim_config.json)
    echo "Config file updated: $current_predictor"

    # Run the configuration script and make command
    ./config.sh champsim_config.json
    make

    # Loop through each trace file
    for trace in "${traces[@]}"; do
        echo "Running simulation for $trace with $predictor predictor..." >> "$output_file"

        if [ "$trace" = "631.deepsjeng_s-928B.champsimtrace.xz" ]; then
            # echo "if"
            bin/champsim --warmup_instructions 200000000 --simulation_instructions 500000000 "$trace" >> "$output_file" 2>&1    
        else
            # echo "else"
            bin/champsim --warmup_instructions 200000000 --simulation_instructions 500000000 "$trace" -c >> "$output_file" 2>&1    
        fi


        # Add space between outputs
        echo -e "\n\n" >> "$output_file"
    done

    echo "Simulation for $predictor predictor completed. Output saved to $output_file."
done

echo "All simulations completed for both predictors."
