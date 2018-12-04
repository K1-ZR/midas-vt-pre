* [**What is MIDAS-VT?**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#what-is-midas-vt)  
* [**What is MIDAS-VT-Pre?**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#what-is-midas-vt-pre)  
* [**User's guide**](https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/MIDAS-VT-User'sGuide.pdf)  
* [**Installation**](https://github.com/K1-ZR/midas-vt-pre/blob/master/README.md#installation)  

Cite this work by:
* [![DOI](https://zenodo.org/badge/155322004.svg)](https://zenodo.org/badge/latestdoi/155322004) 
| [BibTeX file](https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/cite-midas-vt-pre.bib)
* and [this paper](https://www.sciencedirect.com/science/article/pii/S0013794417303703)  

# What is MIDAS-VT?
MIDAS Virtual Tester, MIDAS-VT, is a software package that virtually analyses common experiments of homogenous and heterogenous materials. MIDAS-VT is capable of predicting viscoelastic behavior and crack propagation in smaples.
The current version is able to simulate the following test configurations. 
The blue areas represent potential crack regions.
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/AT.png" width="500" title="all tests">
</p>  

# What is MIDAS-VT-Pre?
MIDAS Virtual Tester Preprocessor, MIDAS-VT-Pre, is a part of MIDAS-VT package. MIDAS-VT-Pre generates Finite Element model of the test samples.
Overall flow of MIDAS-VT-Pre is shown below. MIDAS-VT-Pre has two options:  
* Case I: generates the FE model directly from the sample image or sample geometry  
* Case II: adds cohessive elemnets into regular FE mesh which is generated in advance  
  
<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/Gallery/MIDAS-VT-Pre-flowchart.png" width="500" title="midas-vt-pre flowchart">
</p>

<p align="center">
  <img src="https://github.com/K1-ZR/midas-vt-pre/blob/master/documents/midsa-vt-pre.gif">
</p>
# Installation
1. Download the latest version, midas-vt-pre.rar, from [the release page](https://github.com/K1-ZR/midas-vt-pre/releases), then unzip the file.  
2. Make sure you have all necessary files in the release package:   
    * Gallery folder
    * MIDAS_VT_Pre.exe 
    * splash.PNG  
3. Verify [the suitable MATLAB Runtime](https://www.mathworks.com/products/compiler/matlab-runtime.html?s_cid=BB&nocookie=true), version 9.5, is installed on your computer.  
4. Run MIDAS_VT_Pre.exe   

**Note:** all the output messages will be stored in STATUS.txt for future reference.  
**Note:** The execution may take several minutes.  
