#!/bin/bash
set -e

#############
# TODO
#  * auto-handle output file generation


# intrate, fprate, intspeed, fpspeed
# Supersets spec{speed,rate}, and all, are not supported
suite_type=intspeed

# ref, train, test
input_type=ref

version=2006

function usage
{
    echo "usage: compare_output.sh [--version[2006 | 2017]] [-H | -h | --help] [--suite [intspeed | intrate | fpspeed | fprate] | --input [train | test | ref]]"
}

while test $# -gt 0
do
   case "$1" in
        --suite)
            shift;
            suite_type=$1
            ;;
	--version)
            shift;
            version=$1
            ;;
        --input)
            shift;
            input_type=$1
            ;;
        -h | -H | -help)
            usage
            exit
            ;;
        --*) echo "ERROR: bad option $1"
            usage
            exit 1
            ;;
        *) echo "ERROR: bad argument $1"
            usage
            exit 2
            ;;
    esac
    shift
done

echo "== Speckle Compare Output =="
echo "  Version  : " ${version}
echo "  Suite  : " ${suite_type}
echo "  Input  : " ${input_type}
echo ""

mkdir -p compare
# Directory into which speckle will dump logs and the overlay
out_dir=$PWD/output/${version}/${input_type}
ref_dir=$PWD/reference_output/${version}/${input_type}
diff_dir=$PWD/compare/${version}/${input_type}
mkdir -p $diff_dir

#fi
if [[ $version == *"2006"* ]]; then
	# the integer set
	if [[ $suite_type == *"all"* ]]; then 
		benchmarks=$(basename -s .${input_type}.cmd --multiple $(pwd)/commands/*."${input_type}".cmd)
	
	elif [[ $suite_type == *"int"* ]]; then
		benchmarks=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)
	elif [[ $suite_type == *"fp"* ]]; then
		benchmarks=(410.bwaves 416.gamess 433.milc 434.zeusmp 435.gromacs 436.cactusADM 437.leslie3d 444.namd 447.dealII 450.soplex 453.povray 454.calculix 459.GemsFDTD 465.tonto 470.lbm 481.wrf 482.sphinx3 ) 

	fi
else 
	benchmarks=$(basename -s .${input_type}.cmd --multiple $(pwd)/commands/${suite_type}/*."${input_type}".cmd)
fi
   file=""
   echo ${benchmarks[2]}
   echo "Start diffing ..."
   for b in ${benchmarks[@]}; do
      echo "Comparing ${b} ..."
     if [[ $b == "403.gcc" ]]; then
         if cmp -s "${out_dir}/cccp.s" "${ref_dir}/cccp.s"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/cccp.s ${ref_dir}/cccp.s for more information" 
		 fi
     elif [[ $b == "434.zeusmp" ]]; then
         if cmp -s "${out_dir}/tsl000aa" "${ref_dir}/tsl000aa"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/tsl000aa ${ref_dir}/tsl000aa for more information" 
		 fi
     elif [[ $b == "410.bwaves" ]]; then
		 success=0
         if cmp -s "${out_dir}/bwaves.out" "${ref_dir}/bwaves.out"; then
				success=1 
		 else
			 echo "$b failed .. run diff ${out_dir}/bwaves.out ${ref_dir}/bwaves.out for more information" 
			 success=0
		 fi
		 if cmp -s "${out_dir}/bwaves2.out" "${ref_dir}/bwaves2.out"; then
			 filler=1
		 else
			 echo "$b failed .. run diff ${out_dir}/bwaves2.out ${ref_dir}/bwaves2.out for more information"
			 success=0
		 fi
		 if cmp -s "${out_dir}/bwaves3.out" "${ref_dir}/bwaves3.out"; then
			filler=1
		 else
			 echo "$b failed .. run diff ${out_dir}/bwaves.out ${ref_dir}/bwaves.out for more information"
			 success=0
		 fi
		 if [[ $success == 1 ]]; then
			  echo "$b succeeded"
		 fi
	 elif [[ $b == "435.gromacs" ]]; then
		 if cmp -s "${out_dir}/gromacs.out" "${ref_dir}/gromacs.out"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/gromacs.out ${ref_dir}/gromacs.out for more information" 
		 fi
	 elif [[ $b == "437.leslie3d" ]]; then
		 if cmp -s "${out_dir}/leslie3d.out" "${ref_dir}/leslie3d.out"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/leslie3d.out ${ref_dir}/leslie3d.out for more information" 
		 fi
	 elif [[ $b == "444.namd" ]]; then
		 if cmp -s "${out_dir}/namd.out" "${ref_dir}/namd.out"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/namd.out ${ref_dir}/namd.out for more information" 
		 fi
 	 elif [[ $b == "453.povray" ]]; then
		 if cmp -s "${out_dir}/SPEC-benchmark.tga" "${ref_dir}/SPEC-benchmark.tga"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/SPEC-benchmark.tga ${ref_dir}/SPEC-benchmark.tga for more information" 
		 fi
		 if cmp -s "${out_dir}/SPEC-benchmark.log" "${ref_dir}/SPEC-benchmark.log"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/SPEC-benchmark.log ${ref_dir}/SPEC-benchmark.log for more information" 
		 fi
	 elif [[ $b == "454.calculix" ]]; then
		 if cmp -s "${out_dir}/beampic.dat" "${ref_dir}/beampic.dat"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/beampic.dat ${ref_dir}/beampic.dat for more information" 
		 fi
		 if cmp -s "${out_dir}/SPECtestformatmodifier_z.txt" "${ref_dir}/SPECtestformatmodifier_z.txt"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/SPECtestformatmodifier_z.txt ${ref_dir}/SPECtestformatmodifier_z.txt for more information" 
		 fi
	 elif [[ $b == "459.GemsFDTD" ]]; then
		 if cmp -s "${out_dir}/sphere_td.nft" "${ref_dir}/sphere_td.nft"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/sphere_td.nft ${ref_dir}/sphere_td.nft for more information" 
		 fi
	 elif [[ $b == "465.tonto" ]]; then
		 if cmp -s "${out_dir}/stdout" "${ref_dir}/stdout"; then
				echo "$b succeeded" 
		 else
			 echo "$b failed .. run diff ${out_dir}/stdout ${ref_dir}/stdout for more information" 
		 fi
	else 	 
		if cmp -s "${out_dir}/${b}.err" "${ref_dir}/${b}.err"; then
				echo "$b succeeded" 
		else
			 echo "$b failed .. run diff ${out_dir}/${b}.err ${ref_dir}/${b}.err for more information" 
		fi
	fi
      #diff ${out_dir}/${b}.err ${ref_dir}/${b}.out > ${diff_dir}/${b}.diff
   done


echo ""
echo "Done!"
