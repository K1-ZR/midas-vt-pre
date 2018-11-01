[**Link to the user's guide**](https://github.com/K1-ZR/midas-vt-pre/blob/master/MIDAS-VT-User'sGuide.pdf) 

# What is MIDAS-VT?
MIDAS Virtual Tester, MIDAS-VT, is a software package that virtually analyses homogenous and heterogenous material test experiments. MIDAS-VT is capable of predicting viscoelastic behavior and crack propagation in smaples.
The current version is able to simulate the following test configurations. 
The blue areas represent potential crack regions.
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/AT.png" width="400" title="all tests">
</p>  

# What is MIDAS-VT-Pre?
MIDAS Virtual Tester Preprocessor, MIDAS-VT-Pre, is a part of MIDAS-VT package. MIDAS-VT-Pre generate Finite Element model of the test samples.
Overall flow of MIDAS-VT-Pre is shown below. MIDAS-VT-Pre gives two options:  
* Case I: generates the FE model directly from the sample image or sample geometry  
* Case II: to add cohessive elemnets into regular FE mesh which is generated in advance  
  
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/MIDAS-VT-Pre-flowchart.png" width="500" title="midas-vt-pre flowchart">
</p>

# Installation
* make sure you have all files in the release package: 
Gallery folder, MIDAS_VT_Pre.exe, splash.PNG
2.	Prerequisites: 
Verify the suitable MATLAB Runtime is installed on your computer.
3.	Run target software: 
MIDAS_VT_Pre.exe  

**Note:** all the output messages will be stored in STATUS.txt for future reference.
**Note:** The execution may take several minutes.

