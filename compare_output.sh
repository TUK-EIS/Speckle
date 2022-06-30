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
    echo "usage: gen_binaries.sh [--version[2006 | 2017]] [--compile | --genCommands] [-H | -h | --help] [--suite [intspeed | intrate | fpspeed | fprate] | --input [train | test | ref]]"
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

benchmarks=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)


   echo ${benchmarks[2]}
   echo "Start diffing ..."
   for b in ${benchmarks[@]}; do
      echo "Comparing ${b} ..."
	if cmp -s "${out_dir}/${b}.err" "${ref_dir}/${b}.out"; then
    		echo "$b succeeded" 
	else
	  	 echo "$b failed .. run diff ${out_dir}/${b}.err ${ref_dir}/${b}.out for more information" 
	fi
      #diff ${out_dir}/${b}.err ${ref_dir}/${b}.out > ${diff_dir}/${b}.diff
   done
   



echo ""
echo "Done!"
