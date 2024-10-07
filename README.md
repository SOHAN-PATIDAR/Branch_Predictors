This README file is for Q2 of Assignment_1 that eplains about the evaluation of different branch predictors using the Champsim simulator, their code and reults generated for them. For each branch predictor the hardware cost is considered equal roughly 64KB ± 2KB. Each predictor uses a BTB of 2048 entries which is not included in the storage budget.

**NOTE** For this assignment detials of 4 tarces that are used is provided in traces_used.txt file, download them and copy them to traces folder.


For this assignment we have used an champsim version that can be found on below link with steps for installation.
[Champsim](https://github.com/casperIITB/ChampSim)

Q2 consist of 3 subparts as given below :-
1. Evaluation of 3 Cloudsuite benchmark + 1 Optional benchmark using **bimodal predictor, G-share predictor, perceptron predictor, any variant of tage predictor(with 4 tables)** and report MPKI and IPC.
2. Explore a different set of history lengths and different table sizes for the TAGE predictor, keeping storage budget within 64KB.
3. Explore a hybrid g-share and TAGE predictors with a total storage of ~64KB, the relative storage between two can be varied as 25:75, 50:50, or 75:25.

**NOTE:-** Which variant of tage is used in which question is mentioned in variants.txt file.

# Execution Idea for complete Q2 (how predictors are used to perform evaluations on different traces)
To run a predictor for any given trace file, firstly we need to build that predictor and then we perfom evaluation on it. Example for one predictor which is performing evaluation on given trace file is given below.
```bash
# buld the predictor
$ ./build_champsim.sh bimodal no no no next_line lru 1
# Perfrom evaluation using
$ ./run_champsim.sh bimodal-no-no-no-next_line-lru-1core 1 10 600.perlbench_s-210B.champsimtrace.xz
# This commands are specifically for the bash files that are alredy implemented, they can be changed.
```

## Q2_A 

This question asks to perform evaluation on a set of given benchmarks using different predictors like bimodal, G-share, perceptron, tage.
Champsim code alreday impplemented bimodal, gshare and perceptron. To implement the tage predictor I've taken reference from (https://github.com/KanPard005/RISCY_V_TAGE). Some changes are made in the given predictor files to make hardware cost equal for all.

**Steps for the execution for Q2_A:-**
1. Created a **run_A.sh** file that performs evaluation on all the traces for each predictor and store results for all traces in one txt file per predictor inside **Q2_A_results** folder.
2. To run **file_name.sh** file use commands mentioned below
```bash
$ chmod +x file_name.sh
$ ./file_name.sh
```
2. run_A.sh file is building predictor using build_champsim.sh file.
3. After predictor is build we will use the following command for evaluation, using 200 million as warmup inst and 500 million as simulation inst.
```bash
# To build predictor
./build_champsim.sh $predictor_name no no no next_line lru 1

# Performing evaluationa and storing result in txt file
(./bin/"$predictor_name"-no-no-no-next_line-lru-1core -warmup_instructions 200000000 -simulation_instructions 500000000 -c -traces ${TRACE_DIR}/${trace_name}) >> $output_file_name 2>&1
```
## Q2_B

This question asks to perform evaluation on a set of given benchmarks using different variants of tage predictor by exploring different set of history lengths and different table size.

**Steps for the execution for Q2_A:-**
1. Created a **run_B.sh** file that perfrom evaluation on all the traces for different variants of tage predictor and store results for all traces in one txt file per vvariant inside **Q2_B_results** folder.
Remaining steps are same as used in similar part above

## Q2_C

This question asks to perfrom evaluation for all the traces using hybrid (G-share and Tage) predictor with total storage location of 64KB for the two predictors. 1 KB of extra storage location is provided for meta predictor.
The solution implements hybrid(G-share and Tage) with three variation of memory division (G-share : Tage) a). 50:50 b). 25:75 c). 75:25
**NOTE :-** The parameters used for G-share and Tage for different variants are mentioned in **Hybrid_variants.txt** file present in **Q2_C** folder

**Steps for the execution for Q2_A:-**
1. For evaluating different traces using hybrid predictor we have used given [Champsim](https://github.com/ChampSim/ChampSim].
2. After cloning champsim just add the **hybrid** folder and **run.sh** file present here in folder **Q2_c** under **Champsim/branch** & **Champsim** directory of cloned Champsim respectively.
3. Follow the commands mentioned in github profile of the champsim used here for evaluation of traces or run the script file I created using below commands after the above step is done successfully.
```bash
$ chmod +x run.sh

$ ./run.sh
```
4. I've used an script file to manage task easily and efficiently.
5. Output for this part is generated using the Champsim mentioned above, but attaching the part_C result files in folder **Q2_C_results** here. 