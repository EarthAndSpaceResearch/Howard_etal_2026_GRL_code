*Howard et al., GRL 2026*





###### **Figure 3: Examples of ice shelf processes observed with repeat SWOT HR acquisitions.**

###### \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

&#x09;



Before running the plot script, all data must be processed according to scripts in the

LarsenC and Venable directories. 



Directions are as follows:





**Larsen C:  Tide Flexure**



**Step 1:  Correct\_TIDES\_DAC\_save\_tiles\_fig3.m**

&#x20;   

&#x20;         Applies DAC and TIDE corrections to selected HR tiles

&#x20;         

&#x20;         Requires :

&#x20;          •	\\utils\\func\_readswottime\_findDACdatematch.m

&#x20;          •	\\utils\\func\_load\_DAC\_data.m

&#x20;          •	External 

&#x20;              o	matlab toolbox TMD3.0

&#x09;       o	CATS2008\_v2023.nc Model

&#x09;       o	Aviso DAC files



&#x09;

**Step 2:   extract\_line\_withDACtide\_corr\_GRL2026.m**



&#x20;        extract data along a line defined in script for corrected tiles (step1 data) 

&#x20;        and saves this as structured array in output file



&#x20;        Requires :

&#x20;          •	files from step1

&#x20;          

&#x20;         



**Venable:  Crevasse**





**Step 1:Correct and advect SWOT HR tiles using 2-step method**

&#x20;     

&#x20;   **Step1a:  Step1a\_Correct\_TIDES\_DAC\_save\_tiles\_fig3.m** 

&#x20;        

&#x20;         Applies DAC and TIDE corrections to selected HR tiles

&#x20;         

&#x20;         Requires :

&#x20;          •	\\utils\\func\_readswottime\_findDACdatematch.m

&#x20;          •	\\utils\\func\_load\_DAC\_data.m

&#x20;          •	External 

&#x20;              o	matlab toolbox TMD3.0

&#x09;       o	CATS2008\_v2023.nc Model

&#x09;       o	Aviso DAC files





&#x20;  

&#x20;   **Step1b:  Step1b\_advect\_corrected\_tiles\_fig3.m**

&#x20;            

&#x20;        Advects tiles to common time using MEaSUREs velocity file 

&#x20;        

&#x20;        Requires:  

&#x20;        •      Step 1a \*\_correctedDACTIDES.mat files

&#x20;        •      \\aux\_files\\aux\_files\\venable\_vel.mat   (subset of MEaSUREs V2 data over Venable)





**Step 2: step2\_extract\_Venable\_transect.m**

&#x20;	Script to extract elevations along line defined in script from corrected tiles from Step1

&#x20;       





**Final step:   plot\_figure3\_6panel\_grl2026.m**



&#x20;         Plots paper Figure3

&#x20;            

&#x20;         relies of data from all steps above

