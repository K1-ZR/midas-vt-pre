# What is MIDAS-VT?
MIDAS Virtual Tester, MIDAS-VT, is a software package that virtually analyses homogenous and heterogenous material test experiments. MIDAS-VT is capable of predicting viscoelastic behavior and crack propagation in smaples.
The current version is able to simulate the following test configurations. 
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/AT.png" width="512" title="all tests">
</p>
# What is MIDAS-VT-Pre
MIDAS Virtual Tester Preprocessor, MIDAS-VT-Pre, is a part of MIDAS-VT package. MIDAS-VT-Pre is capable of generating Finite Element models of the test samples.


Preprocessor part generates FE model which contains mesh and boundary condition data. Preprocessor module is tailored for generating FE model from six common test configurations in infrastructure materials’ field: Simple tension test, Simple shear test, Three-point bending beam test, Four-point bending beam test, Semi-circular bending beam test and Indirect shear test. These FE models can be used later in Processor where material properties and other test conditions are defined. Also, Postprocessor feature is provided within this package to display and visualize the result and export required graphs. The descriptions and implementation details of each modules are presented in the following chapters.
