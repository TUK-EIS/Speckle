#!/bin/bash


sh intspeed_test.sh 600.perlbench_s --threads 1
sh intspeed_test.sh 602.gcc_s --threads 1
sh intspeed_test.sh 605.mcf_s --threads 1
sh intspeed_test.sh 620.omnetpp_s --threads 1
sh intspeed_test.sh 623.xalancbmk_s --threads 1
sh intspeed_test.sh 625.x264_s --threads 1
sh intspeed_test.sh 631.deepsjeng_s --threads 1
sh intspeed_test.sh 641.leela_s --threads 1
sh intspeed_test.sh 648.exchange2_s --threads 1
sh intspeed_test.sh 657.xz_s --workload 0 --threads 1
sh intspeed_test.sh 657.xz_s --workload 1 --threads 1
