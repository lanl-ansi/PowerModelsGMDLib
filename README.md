# PowerModelsGMDLib

This is a repository of models for [PowerModelsGMD.jl](https://github.com/lanl-ansi/PowerModelsGMD.jl). This includes 
models that are prohibitively large to include in the PowerModelsGMD.jl unit tests.

Models include versions of the [RTS-GMLC](https://github.com/GridMod/RTS-GMLC) test network that include information 
needed for solving geomagnetically induced currents (GICs). These have been translated to the following locations:

- Pacific Northwest of the United States
- Eastern United States
- Northern United States

Additional models are based on the TAMU Smart Grid Center synthetic grids produced by Adam Birchfield.

Where relevant, this repository includes the original PowerWorld cases compressed with `.zip` compression.
Derived datasets are compressed with `gzip` using the `--rsyncable` option. Derived datasets include

- PTI RAW V33 exports of the files (either as-released by TAMU or exported by LANL if not present)
- JSON modification files that include equivalent dc networks needed for GIC analysis
- Extended MatPower cases with equivalent dc networks needed for GIC analysis
- GIS information 
