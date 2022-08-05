#!/bin/bash


sh intspeed_ref.sh 600.perlbench_s --threads 1
sh intspeed_ref.sh 602.gcc_s --threads 1
sh intspeed_ref.sh 605.mcf_s --threads 1
sh intspeed_ref.sh 620.omnetpp_s --threads 1
sh intspeed_ref.sh 623.xalancbmk_s --threads 1
sh intspeed_ref.sh 625.x264_s --threads 1
sh intspeed_ref.sh 631.deepsjeng_s --threads 1
sh intspeed_ref.sh 641.leela_s --threads 1
sh intspeed_ref.sh 648.exchange2_s --threads 1
sh intspeed_ref.sh 657.xz_s --workload 0 --threads 1
sh intspeed_ref.sh 657.xz_s --workload 1 --threads 1
