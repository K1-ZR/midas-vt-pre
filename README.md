* [**What is MIDAS-VT?**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#what-is-midas-vt)  
* [**What is MIDAS-VT-Pre?**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#what-is-midas-vt-pre)  
* [**User's guide**](https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/MIDAS-VT-User'sGuide.pdf)  
* [**Installation**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#installation)  

To cite this work please use:
* [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1477100.svg)](https://doi.org/10.5281/zenodo.1477100)
| [BibTeX file](https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/cite-midas-vt-pre.bib)
* and [paper 1](https://www.sciencedirect.com/science/article/pii/S0013794417303703)  
* and [paper 2](https://www.sciencedirect.com/science/article/pii/S2352711018303054)


<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/midsa-vt-pre.gif">
</p>  

<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/midas-vt-pre-abaqusdemo.gif">
</p>  

# What is MIDAS-VT?
MIDAS Virtual Tester, MIDAS-VT, is a software package that virtually analyses common experiments of homogenous and heterogenous materials. MIDAS-VT is capable of predicting viscoelastic behavior and crack propagation in smaples.
The current version is able to simulate the following test configurations. 
The blue areas represent potential crack regions.
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/AT.png" width="500" title="all tests">
</p>  

# What is MIDAS-VT-Pre?
MIDAS Virtual Tester Preprocessor, MIDAS-VT-Pre, is a part of MIDAS-VT package. MIDAS-VT-Pre generates Finite Element model of mechanical test specimens.
Overall flow of MIDAS-VT-Pre is shown below. The user has two options when uses MIDAS-VT-Pre:  
* Case I: generates the FE model directly from the sample image or sample geometry  
* Case II: adds cohesive elements into regular FE mesh which is generated in advance  
  
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/MIDAS-VT-Pre-flowchart.png" width="500" title="midas-vt-pre flowchart">
</p>

# Installation
1. Download the latest version, midas-vt-pre.rar, from [the release page](https://github.com/K1-ZR/midas-vt-pre/releases), then unzip the file.  
2. Make sure you have all necessary files in the release package:   
    * Gallery folder
    * MIDAS_VT_Pre.exe 
    * splash.PNG  
3. Verify [the suitable MATLAB Runtime](https://www.mathworks.com/products/compiler/matlab-runtime.html?s_cid=BB&nocookie=true), version 9.5 (only), is installed on your computer.  
4. Run MIDAS_VT_Pre.exe   

**Note:** all the output messages will be stored in STATUS.txt for future reference.  
**Note:** The execution may take several minutes.  

