*Howard et al., GRL 2026*





###### **Figure 1: Examples of HR Raster data coverage, and validation of SWOT using ICESat-2 altimetry.**

###### **\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_**



&#x09;

**Step1: Create\_fig1files\_GRL2026.m**



Extracts data and applies corrections to data needed for figure 1 plot.  



Requires:

o	func\_get\_IS2\_gtX\_corr.m (included)

o	matlab toolbox TMD3.0   (external download)

o	CATS2008\_v2023.nc model (external download)







Reads the following datafiles (user must download separately) or adapt script according to there access method

o	See data\_file\_list.pdf





**Step 2: plot\_fig1\_from\_file\_GRL2026.m**



This plots figure 1.



Reads in:

o	Mat file created in step 1: fig1\_variables\_GRL2026.mat 

o	SWOT cycle 28 data files (HR data over Larsen C), see data\_file\_list.pdf











