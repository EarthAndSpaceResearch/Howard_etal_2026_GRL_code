*Howard et al., GRL 2026*





###### **Figure 2: Example of corrections applied to SWOT HR WSE for a small region of Larsen C ice shelf.**

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_





**Step 1:  correct and advect SWOT HR tiles using 2-step method**

&#x20;     

&#x20;   Step1a:  **Step1a\_Correct\_TIDES\_DAC\_save\_tiles\_fig2.m** 

&#x20;        

&#x20;         Applies DAC and TIDE corrections to selected HR tiles

&#x20;         (see data\_file\_list.pdf\_\_for specific files)

&#x20;         

&#x20;         Requires :

&#x20;          •	\\utils\\func\_readswottime\_findDACdatematch.m

&#x20;          •	\\utils\\func\_load\_DAC\_data.m

&#x20;          •	External 

&#x20;              o	matlab toolbox TMD3.0

&#x09;       o	CATS2008\_v2023.nc Model

&#x09;       o	Aviso DAC files



&#x09;



&#x20;  

&#x20;   Step1b:  **Step1b\_advect\_corrected\_tiles\_fig2.m**

&#x20;            

&#x20;        Advects tiles to common time using MEaSUREs velocity file

&#x20;        

&#x20;        Requires:  

&#x20;        •      Step 1a \*\_correctedDACTIDES.mat files

&#x20;        •      \\aux\_files\\vel\_LarsenC.mat   (subset of MEaSUREs V2 data over Larsen C)







**Step 2:  Script: get\_streamlines\_grl2026.m**



&#x20;        From a streamline, extract data along this for corrected \& advected, and uncorrected tiles



&#x20;        Requires :

&#x20;          •	files from step1

&#x20;          •	\\aux\_files\\streamline\_1day\_LarC.mat   : Larsen C streamline





**Final step:   plot\_fig2\_grl2026.m**



&#x20;         Plots paper Figure 2

&#x20;            

&#x20;         Requires :

&#x20;          •	files from step1 and step2

&#x20;          •	\\aux\_files\\streamline\_1day\_LarC.mat   : Laresen C streamline

&#x20;               \\aux\_files\\vel\_LarsenC.mat

&#x09;	\\aux\_files\\snapshot-2025-10-17T00\_00\_00Z\_aqua\_rev1.tif



