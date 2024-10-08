# predictor="tage12"

# if [ "$predictor" = "tage" ]; then
#     echo "if"
#     # ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 200000000 -simulation_instructions 500000000 -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
# else
#     echo "else"
#     # ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 200000000 -simulation_instructions 500000000 -c -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
# fi


#!/bin/bash
 
# Create a directory for simulation results
 
mkdir -p try
 
TRACE_DIR=$PWD/traces
 
# Array of predictors
predictors=("gshare" "bimodal" "perceptron" "tage")
 
# Array of output files corresponding to each predictor
output_files=("Gshare_simulation_output.txt" "Bimodal_simulation_output.txt" "Perceptron_simulation_output.txt" "TAGE_simulation_output.txt")
 
# Array of trace files
traces=("cassandra_phase5_core0.trace.xz" "streaming_phase0_core1.trace.xz" "cloud9_phase5_core3.trace.xz" "631.deepsjeng_s-928B.champsimtrace.xz")


# Loop through each predictor
for i in "${!predictors[@]}"; do
 
    output_file="try/${output_files[$i]}"
 
    predictor="${predictors[$i]}"
 
    ./build_champsim.sh $predictor no no no next_line lru 1
 
    # Loop through each trace file
    for trace in "${traces[@]}"; do
        echo "Running simulation for $trace with $predictor predictor..." >> "$output_file"

        echo "before run"

        if [ "$trace" = "631.deepsjeng_s-928B.champsimtrace.xz" ]; then
            ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 2000 -simulation_instructions 5000 -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
        else
            ./bin/"$predictor"-no-no-no-next_line-lru-1core -warmup_instructions 2000 -simulation_instructions 5000 -c -traces "${TRACE_DIR}/${trace}" >> "$output_file" 2>&1
        fi
 

        echo "after run"
 
        # Add space between outputs
        echo -e "\n\n" >> "$output_file"
    done
 
    echo "Simulation for $predictor predictor completed. Output saved to $output_file."
done
 
echo "All simulations completed for all predictors."
 