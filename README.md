<img align="right" width="120" height="120" title="ERAU Logo" src="https://github.com/MrPilotMan/RadSim/blob/master/Embry-Riddle%20Aeronautical%20University%20Seal.png" />

# RadSim
**University:** Embry-Riddle Aeronautical University

**Organization:** Society 4 S.P.A.C.E.

**Project:** Project S.H.I.E.L.D.

**Objective:** Simulate particle interaction with an electro-magnetic field radiation shield on a spacecraft.

## Instructions on running
1. Download the [latest release](https://github.com/MrPilotMan/RadSim/releases) file titled `RadSim.zip`.
2. Unzip and open `RadSim.m` in MatLab.
3. Adjust `requestedParticles`, `scale`, and `delta` variables in `radsim.m` as desired.
   1. Setting `requestedParticles` higher will demand significantly more RAM to display the plots. It is advisable to run more simulations with a lower `requestedParticle` size.
   2. Making `scale` larger does not produce better graphs and will significantly slow down each particles simulation.
   3. Setting `delta` to a lower numeric value will increase the granularity of the simulation, but results in a roughly linear time increase.
5. There are a number of premade `wireGeometry` data files in `../wireGeometry`, but the option to set your own variables remains.
  1. To use the included data, make sure `load('wireGeometry/1e4.mat');` is uncommented and `wireGeometry = generateWireGeometry(innerRadius, torusRadius);` is commented out. Then replace the file name (eg. 1e4.mat) with your desired data.
    1. All the included data files are multiples of 10 (eg. 1e4 is equivelant to `turns = 1000;`).
  2. If you wish to gereate the `wireGeometry` during the simulation, make sure the above two lines are reversed and you have manually set any variables in `generateWireGeometry.m`.
6. If you want to run the simulation in parallel, make sure you have started a worker pool, then simply set `parallel = true`.
  2. Since MATLAB will not show plots created in a `parfor` loop, parallel simulations will only report a final hit/missed tally.
7. Save and run the simulation.
   1. On termination or completion, MatLab will display the plots.
   
## Benchmarks

#### Real World Benchmarks
| Machine                                       | Version | Scale | Delta           | Average Particle Time | Parallel |
|-----------------------------------------------|---------|-------|-----------------|-----------------------|----------|
| MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14 | 1.0     | 5000  | 1e<sup>-6</sup> | 13 seconds            | No       |
| Dell, 3.4 GHz i7 6700, 16GB RAM, Windows 10   | 1.0     | 5000  | 1e<sup>-6</sup> | 23 seconds            | No       |

*When adding rows to the above table, please order your rows by version (new &rightarrow; old), time (fast &rightarrow; slow), delta (small &rightarrow; large), and scale (large &rightarrow; small), in that order.*

#### Version Benchmarks
| Version | Total Time | Particle Time | Memory per Particle | Particle Improvement | Memory Improvement | Notes   |         
|---------|------------|---------------|---------------------|----------------------|--------------------|---------|
| 0.0     | 73m 54s    | 3m 50s        | 361.57 MB           | 0%                   | 0%   |Only produced valid 19 plots.| 
| 1.0     | 46m 09s    | 0m 28s        | 103.40 MB           | 832%                 | 349%  |Refactor & CPU/MEM optimization.|
| 1.1     |            |               |                     |                      |       |CSV usage and file structure.|
| 2.0     |            |               |                     |                      |       |Parallelized with hit detection.|
| 3.0     |            |               |                     |                      |       |C++ translation.|


##### Standard Benchmarking Parameters
```
Machine is a MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14

requestedParticles = 100

scale = 10000

delta = 1e^-6

As of version 2.0, particles are no longer plotted since the hit detection function si used.
```


## To Do (No real order)
* [X] Refactor
    * [X] Style
    * [X] File structure
    * [X] Function/loop optimization
    * [X] Math optimization
* [X] Benchmarking
   * [X] Timing
   * [X] Version Benchmarking
* [ ] CSV
   * [X] Save data to CSV
   * [X] Read in wire geometry from CSV
   * [ ] CSV particle simulation interpreter & plotter
* [ ] Parallelization
   * [ ] MATLAB
   * [ ] C++
* [ ] Hit detection
* [ ] Data collection
   * [X] Particle type
   * [ ] Approach angle
* [ ] Translation

## Contributors (Alphabetical by last name)
* John Galjanic
   * Hit detection

* Sam Kopp (GitHub username - MrPilotMan)
  * Refactor and optimization
  * Use CSV for collecting and loading data

* Brennan McCann
  * Original simulation
