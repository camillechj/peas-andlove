### Install simuPOP based on the website (http://simupop.sourceforge.net/Main/Download)

### Set up a baseline population. This one will be sampled from a distribution lambda distribution.

from simuOpt import setOptions
setOptions(alleleType='binary')

import simuPOP as sim
pop = sim.Population(size=200, ploidy=2, loci=1052, infoFields='fitness')

import random
sim.initGenotype(pop, freq=lambda: random.random())

### Set parameters to evolve the population forward in time

import time
pop.evolve(
    initOps=sim.InitSex(),
    matingScheme=sim.SelfMating(ops=[
        sim.Recombinator(rates=0.01),
        sim.SelfingGenoTransmitter(),
        sim.MapSelector(loci=0, fitness={(0,0):1, (0,1):0.98, (1,1):0.97}),
    ]),
    postOps=[
        sim.Stat(LD=[0,1], step=10),
        sim.PyEval(r"'%.2f\n' % LD[0][1]", step=10),
    ],
    gen = 100
)

### Save the file so it can be processed later (see the file called "Processing-simuPOP-population.r")

from simuPOP.utils import saveCSV
saveCSV(pop, filename='mypopfinal.csv', affectionFormatter={True: 1, False: 2},
    genoFormatter=lambda geno: (geno[0] + 1, geno[1] + 1), sep=',')
