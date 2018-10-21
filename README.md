<img align="right" width="120" height="120" title="ERAU Logo" src="https://github.com/MrPilotMan/RadSim/blob/master/Embry-Riddle%20Aeronautical%20University%20Seal.png" />

# RadSim
**University:** Embry-Riddle Aeronautical University

**Organization:** Society 4 S.P.A.C.E.

**Project:** Project S.H.I.E.L.D.

**Objective:** Simulate particle interaction with an electro-magnetic field radiation shield on a spacecraft.

## Instructions on running
1. Download the [latest release](https://github.com/MrPilotMan/RadSim/releases) file titled `RadSim.m.zip`.
2. Unzip and open `RadSim.m` in MatLab.
3. Adjust `requestedParticles`, `scale`, and `delta` variables as desired.
   1. Setting `requestedParticles` higher will demand significantly more RAM to display the plots. It is advisable to run more simulations with a lower `requestedParticle` size.
   2. Making `scale` larger does not produce better graphs and will significantly slow down each particles simualtion.
   3. Setting `delta` to a lower numeric value will increase the granularity of the simulation, but results in a linear time increase.
4. Save and run the simulation.
   1. On termination or completion, MatLab will display the plots.
   
## Benchmarks

#### Real World Benchmarks
| Machine                                       | Version | Scale | Delta           | Average Particle Time | Parallel |
|-----------------------------------------------|---------|-------|-----------------|-----------------------|----------|
| MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14 | 1.0     | 5000  | 1e<sup>-6</sup> | 13 seconds            | No       |
| *school computer*                             | 1.0     | 5000  | 1e<sup>-6</sup> | *time*                | No       |

*When adding rows to the above table, please order your rows by version (new &rightarrow; old), time (fast &rightarrow; slow), delta (small &rightarrow; large), and scale (large &rightarrow; small), in that order.*

#### Version Benchmarks
| Version | Total Time | Particle Time | Memory per Particle | Particle Improvement | Memory Improvement | Notes            
|---------|------------|---------------|---------------------|----------------------|--------------------|----------
| 0.0     | 73m 54s    | 3m 50s        | 361.57 MB           | N/A                  | N/A            | Only produced 19 plots. 
| 1.0     | 46m 09s    | 0m 28s        | 103.40 MB           | 832%                 | 349%   |Refactor & RAM/CPU optimization.

##### Standard Benchmarking Parameters
```
Machine is a MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14

requestedParticles = 100

scale = 10000

delta = 1e^-6
```


## To Do (No real order)
* [ ] Refactor
    * [X] Style
    * [ ] File structure
    * [X] Fuction/loop optimization
    * [X] Math optimization
* [ ] Benchmarking
   * [X] Timing
   * [X] Version Benchmarking
   * [ ] Plotting results
   * [ ] Save result
* [ ] Parallelization
* [ ] Hit detection
* [ ] Unit testing
* [ ] Save data to CSV
* [ ] Translation
* [ ] OpenCL support?

## Contributers
* Brennan McCann
  * Original simulation
    
* Sam Kopp (Github Username - MrPilotMan)
  * Refactor/optimization
  * Fortran translation
