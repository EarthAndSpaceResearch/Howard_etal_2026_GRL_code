# Howard et al., 2026 code

<b> “SWOT High-Rate Raster Data Reveals Antarctic Ice Shelf Motion and Change in Response to Ocean and Ice Dynamics” </b>

Paper citation to add...

This paper’s goal was to illustrate the potential applications of SWOT High-Rate raster data over the Antarctic Ice shelves.  As part of this work, We provide an example of the validation of SWOT HR Raster using ICESat-2 ATL06 data, and the application of necessary corrections. 

This repository provides MATLAB scripts to process data and recreate figures from our *Geophysical Research Letters* paper published in 2026. 


Scripts and readme's for each figure are located in the figure directories:
<ul>

<li> <b>Figure 1:  Examples of HR Raster data coverage, and validation of SWOT using ICESat-2 altimetry.  </b></li> 

<li> <b>Figure 2:  Example of corrections applied to SWOT HR WSE for a small region of Larsen C ice shelf.   </b></li> 

<li> <b>Figure 3:  Examples of ice shelf processes observed with repeat SWOT HR acquisitions.  </b></li> 
</ul>

We also provide:

<ul>
 <li> <b>.\utils\</b>      -    a set of funcions needed analsyis</li>  
 <li> <b>.\ aux_files\</b>  -   a set of misc files created and used for plotting and analysis</li>
</ul> 
  
User is responsible for accessing data. See [Howard_et_al2026_data_and_software_access.pdf](docs/Howard_et_al2026_data_and_software_access.pdf)  for links to datasets used in this paper.

A specific list of SWOT HR Raster and ICESat-2 ATL06 data used for each figure in this paper is provided in [data_file_list.pdf](docs/data_file_list.pdf)

The published analysis and figure preperation was performed in MATLAB.  However, we provide and additional set of code for those users wishing to preform similar analyses with Python.

