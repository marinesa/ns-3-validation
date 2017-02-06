# ns-3-validation

This repository contains files used for 3GPP validation of the ns-3 LTE module.

Case 1 and Case 3 folders each contain their own modified version of lena-dual-stripe.cc (i.e., lena_dual_stripe_case1.cc, lena_dual_stripe_case3.cc). 

## 1. Evaluating simulation results

Each case folder already contains simulations output files in subfolders, together with matlab scripts to compute statistics and plot CDFs.

For example, to compute statistics for Case 1 with bursty traffic, from corresponding folder, i.e. "\case 1\30 runs bursty traffic\", you can run the script contained within, "compute_ue_sinr_results_average_bursty.m", which will plot the throughput CDF and compute 3GPP 36.814 required statistics. All the matlab computation scripts start with the "compute_ue" string, and the other "\*.m" scripts are used by it.

Additionally, in case 1 with full buffer traffic, users' SINR CDF will also be plotted.

## 2. Running ns-3 simulations in linux

Simulation files can also be generated from scratch assuming ns-3 is already installed in Linux, after it was built with the waf command and examples enabled:

./waf configure --build-profile=optimized --enable-example

Note that optimized build is used as well, to speed up simulations.

In each case folder, there are matlab scripts that will trigger simulations with multiple instances of ns-3. Current implementation assumes 5 ns-3 instances (5 threads), but this can be modified depending on the specifications of the computer it runs on (or, in case matlab is not installed, can be adapted to shell scripts as the script's code is very basic). The scripts pass scenario-specific arguments to the ns-3 lena-dual-stripe.cc file for 3GPP simulations. These scripts need to be placed in the root folder of the ns-3 simulator.

First, to run the simulation for a case, the lena-dual-stripe.cc file content in ns-3 needs to be replaced with content from intended case (e.g., for Case 1, lena_dual_stripe_case1.cc), while keeping the original filename, lena-dual-stripe.cc. 

Secondly, when running a simulation, the specific traffic type needs to be decided beforehand (full buffer or bursty), and the corresponding script selected (e.g., ns3_samples_run_case1_full_buffer.m or ns3_samples_run_case1_bursty.m). A script will generate 30 different simulations/runs (30 independent UE placements), and will output traffic files (e.g., run_17_DlRlcStats.txt). When a full buffer script is used, this will also generate SINR statistics files (e.g., run_17_DlRsrpSinrStats.txt).

Afterwards, the resulting data can be evaluated as described in Section 1.




