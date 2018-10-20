<img align="right" width="120" height="120" title="ERAU Logo" src="https://github.com/MrPilotMan/RadSim/blob/master/Embry-Riddle%20Aeronautical%20University%20Seal.png" />

# RadSim
**University:** Embry-Riddle Aeronautical University

**Organization:** Society 4 S.P.A.C.E.

**Project:** Project S.H.I.E.L.D.

**Objective:** Simulate particle interaction with an electro-magnetic field radiation shield on a spacecraft.

## Instructions on running
1. Download `master` branch.
2. Open `RadSim.m` in MatLab.
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
| MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14 | 1.0     | 5000  | 1e<sup>-6</sup> | 10 seconds            | No       |
| *school computer*                             | 1.0     | 5000  | 1e<sup>-6</sup> | *time*                | No       |

When adding rows to the above table, please order your rows by version (new &rightarrow; old), time (fast &rightarrow; slow), delta (small &rightarrow; large), and scale (large &rightarrow; small), in that order.

#### Version Benchmarks
| Version | Total Simulation Time | Improvement | Notes                                          |
|---------|-----------------------|-------------|------------------------------------------------|
| 0       |                       | N/A         | Initial sim did not produce 100 valid plots.   |
| 1.0     |                       |             | Refactor and memory/compute optimization.      |

##### Standard Benchmarking Parameters
```
Machine is a MacBook Pro, 2.9GHz i9, 32GB RAM, macOS 10.14

requestedParticles = 100

scale = 10000

delta = 1e^-6
```


## To Do
* [ ] Refactor
    * [X] Style
    * [ ] File structure
    * [X] Fuction/loop optimization
    * [X] Math optimization
* [ ] Benchmarking
   * [X] Timing
   * [ ] Plotting results
   * [ ] Save result
* [ ] Parallelization
* [ ] Hit detection
* [ ] Unit testing
* [ ] Save data to CSV
* [ ] Fortran translation
* [ ] OpenCL support?
* [ ] GUI
* [ ] Packaging

## Contributers
* Brennan McCann
  * Original simulation
    
* Sam Kopp (Github Username - MrPilotMan)
  * Refactor/optimization
  * Fortran translation
