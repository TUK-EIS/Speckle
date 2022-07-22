#!/usr/bin/env python3
import pandas as pd
import argparse
import pathlib
import matplotlib
from matplotlib import pyplot as plt
import numpy as np

# Color style similar to ppt color scheme
plt.style.use('seaborn-colorblind')

#Latex Default Font
plt.rc('font', family='serif') 
plt.rc('font', serif='Latin Modern Roman')
matplotlib.rcParams.update({'font.size': 12})

speedBenches= [
    "600.perlbench_s",
    "602.gcc_s",
    "605.mcf_s",
    "620.omnetpp_s",
    "623.xalancbmk_s",
    "625.x264_s",
    "631.deepsjeng_s",
    "641.leela_s",
    "648.exchange2_s",
    "657.xz_s"
]

speedCleanName = {
        "600.perlbench_s" : "perl",
        "602.gcc_s" : "gcc",
        "605.mcf_s" : "mcf",
        "620.omnetpp_s" : "omnetpp",
        "623.xalancbmk_s" : "xalancbmk",
        "625.x264_s" : "x264",
        "631.deepsjeng_s" : "deepsjeng",
        "641.leela_s" : "leela",
        "648.exchange2_s" : "exchange2",
        "657.xz_s" : "xz"
}

all2006Benches= [
    "400.perlbench",
	"401.bzip2",
	"403.gcc",
	"410.bwaves",
	"416.gamess",
	"429.mcf",
	"433.milc",
	"434.zeusmp",
	"435.gromacs",
	"436.cactusADM",
	"437.leslie3d",
	"444.namd",
	"445.gobmk",
	"447.dealII",
	"450.soplex",
	"453.povray",
	"454.calculix",
	"456.hmmer",
	"458.sjeng",
	"459.GemsFDTD",
	"462.libquantum",
	"464.h264ref",
	"465.tonto",
	"470.lbm",
	"471.omnetpp",
	"473.astar",
	"481.wrf",
	"482.sphinx3",
	"483.xalancbmk",
	"GeometricMean",
    "ArithmeticMean"

]

spec2006AllTest = {
    "400.perlbench" : "perlbench",
	"401.bzip2" : "bzip2",
	"403.gcc" : "gcc",
	"410.bwaves" : "bwaves",
	"416.gamess" : "gamess",
	"429.mcf" : "mcf",
	"433.milc" : "milc",
	"434.zeusmp" : "zeusmp",
	"435.gromacs" : "gromacs",
	"436.cactusADM" : "cactusADM",
	"437.leslie3d" : "leslie3d",
	"444.namd" : "namd",
	"445.gobmk" : "gobmk",
	"447.dealII" : "dealII",
	"450.soplex" : "soplex",
	"453.povray" : "povray",
	"454.calculix" : "calculix",
	"456.hmmer" : "hmmer",
	"458.sjeng" : "sjeng",
	"459.GemsFDTD" : "GemsFDTD",
	"462.libquantum" : "libquantum",
	"464.h264ref" : "h264ref",
	"465.tonto" : "tonto",
	"470.lbm" : "lbm",
	"471.omnetpp" : "omnetpp",
	"473.astar" : "astar",
	"481.wrf" : "wrf",
	"482.sphinx3" : "sphinx3",
	"483.xalancbmk" : "xalancbmk",
	"GeometricMean" : "#GeometricMean",
    "ArithmeticMean" : "#ArithmeticMean"
}

def geo_mean(iterable):
    a = np.array(iterable)
    return a.prod()**(1.0/len(a))
    
def loadFiles(files):
    fullDF = None
    for name, path in files.items():
        newDF = pd.read_csv(path, index_col=0)
        newDF.index.rename("Benchmark", inplace=True)
        newDF = newDF.assign(Experiment=name).set_index('Experiment',append=True).swaplevel(0,1)

        if fullDF is None:
            fullDF = newDF
        else:
            #fullDF = fullDF.append(newDF)
            fullDF = pd.concat([fullDF, newDF])

    fullDF.rename(index=spec2006AllTest, inplace=True)
    return fullDF

def make_hatches(ax, df):
    hatches = [h*len(df.index) for h in [['//'], ['--'], ['x'], ['\\'], ['||'], ['+'], ['o'], ['.']]]
    hatches = sum(hatches, [])

    if len(hatches) < len(ax.patches):
        print("Not enough hatches defined")
        
    for i,bar in enumerate(ax.patches):
        bar.set_hatch(hatches[i])
    ax.legend()

def plotRes(res, metric):
    scores = resDF.loc[pd.IndexSlice[:,:], metric].unstack(level=0)

    plot = scores.plot(kind="bar")
    make_hatches(plot, scores)
    plot.set_ylabel("SPEC " + metric)
    plot.set_xticklabels(scores.index, rotation=45, ha='right')

    plot.get_figure().savefig("result.pdf", bbox_inches = "tight", format="pdf")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compare results from multiple runs of the spec workload")
    parser.add_argument('-m', '--metric', required=True, choices=['score', 'overhead'], help="Which metric should be applied?.")
    parser.add_argument('-s', '--suite', required=True, choices=['intspeed', 'intrate', 'all'], help="Which suite was run.")
    parser.add_argument('-d', '--dataset', required=True, help="Which dataset was used, either test or ref. You can also specify a path to a previous output of this script to use as a baseline.")
    parser.add_argument("-n", "--names", nargs='?', default=None, type=lambda s: [item for item in s.split(',')], help="list of names to display of results. If omitted, the parent directory name will be used.")
    parser.add_argument('resultPaths', nargs="+", type=pathlib.Path, help="Paths to results csvs to compare (csvs should be in the format produced by handle-results.py")

    args = parser.parse_args()

    if args.names is None:
        args.names = [ p.parent.name for p in args.resultPaths ]

    datasets = { name : path for (name, path) in zip(args.names, args.resultPaths) }

    resDF = loadFiles(datasets)
    with open("compare_results.csv", "w") as f:
        f.write(resDF.to_csv())
    plotRes(resDF, args.metric)
