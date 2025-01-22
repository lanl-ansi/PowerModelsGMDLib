# PowerModelsGMDLib

This is a repository of models for [PowerModelsGMD.jl](https://github.com/lanl-ansi/PowerModelsGMD.jl). This includes 
models that are prohibitively large to include in the PowerModelsGMD.jl unit tests.

Models include versions of the [RTS-GMLC](https://github.com/GridMod/RTS-GMLC) test network that include information 
needed for solving geomagnetically induced currents (GICs). These have been translated to the following locations:

- Pacific Northwest of the United States
- Eastern United States
- Northern United States

Additional models are based on cases from [TAMU Smart Grid Center synthetic grid repository](https://smartgridcenter.tamu.edu/research/electric-grid-test-case-repository/) produced by Adam Birchfield. 

## References

A.B. Birchfield, T.J. Overbye, “A Review on Providing Realistic Electric Grid Simulations for Academia and Industry,” Curr Sustainable Renewable Energy Rep, June 2023, View

A.B. Birchfield, T. Xu, and T.J. Overbye, “Power flow convergence and reactive power planning in the creation of large synthetic power grids,” IEEE Transactions on Power Systems, to be published, 2018

A.B. Birchfield; T. Xu; K. M. Gegner; K.S. Shetye; T.J. Overbye, “Grid Structural Characteristics as Validation Criteria for Synthetic Networks,”  in IEEE Transactions on Power Systems, vol. 32, no. 4, pp. 3258-3265, July 2017.

T. Xu; A.B. Birchfield; K.S. Shetye; T.J. Overbye, “Creation of Synthetic Electric Grid Models for Transient Stability Studies,”  2017 IREP Symposium Bulk Power System Dynamics and Control, Espinho, Portugal, 2017.

H. Li, J.H. Yeo, A. Bornsheuer and T.J. Overbye, “The Creation and Validation of Load Time Series for Synthetic Electric Power Systems,” in IEEE Transactions on Power Systems, doi: 10.1109/TPWRS.2020.3018936.

Derived datasets are compressed with `gzip` using the `--rsyncable` option. Derived datasets include:

- PTI RAW V33 exports of the files (either as-released by TAMU or exported by LANL if not present)
- JSON modification files that include equivalent dc networks needed for GIC analysis
- Extended MatPower cases with equivalent dc networks needed for GIC analysis
- GIS information 

## TODO

- [ ] fix v3/v4 issues with one .gic file
- [ ] fix missing .csv issues with one case
- [ ] add citations
- [ ] cleanup PowerModelsGMDLib.jl
- [x] merge develop into master
- [ ] tag version
- [ ] add tests for large cases, at least for parser
- [ ] add GIS for verified cases
- [ ] merge verified cases into root folder

