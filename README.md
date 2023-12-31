# Merra2CODProject
Code used to Extract and Process Cloud Optical Depth Data from Merra2 Program Data Storage
## MERRA-2 is the latest version of global atmospheric reanalysis for the satellite era produced by NASA Global Modeling and Assimilation Office (GMAO)
using the Goddard Earth Observing System Model (GEOS) version 5.12.4. The purpose of this program is to gather data from a wide variety of sources to
further atmospheric modelling efforts. This project has been running since 1980.Merra2 means that this is the second iteration of the project. The overall proces is 
called data assimilation. In practical terms this indicates gathering data from a wide variety of sensors (space based,atmospheric balloons and aircraft as well as 
land and sea based sensors.
The contributing sensors have a wide variety of capabilities,sampling rates,wavelength regimes etc. The assimilation process is meant to combine these disparate results
and agglomorate this data to estimate and the values of measured producrs on a common data grid. In the case of Merra2 this data grid is spaced at 0.5 deg in latitude and
0.625 deg in longitude. This produces a grid of dimensions  576 x 361 points. The data is stored using a netCDF format.
## Project Scope
This project was executed using Matlab version 2022b and uses the basic Matlab along with the data mapping toolbox. The dataset that is used comes from the NASA EarthData website
anf the user will need an account to download data from this source. Many different datasets are collected on this site but only one dataset was used for this versy specific project.
This dataset has the short name of M2TMNXRAD_5.12.4 and is also called MERRA-2 tavgM_2d_rad_Nx: 2d,Monthly mean,Time-Averaged,Single-Level,Assimilation,Radiation Diagnostics V5.12.4 .
This dataset provides many different items but this project is focussed on the variable "TAUHGH" which is the name for the Cloud Optical Depth (COD) at high altitudes. This was the variable
of greatest interest because the goal of the effort was to study the effect of Cirrus clouds on climate.
## Script Processing
The executive script was called "ProcessCODData.m" and is the entry point to the analysis effort. The basic tasks to be accomplished by this script and the other included functions are as follows
+ Set up required folder paths and variables,flags and default values
+ User selects datafiles and time of day
+ Each file is then processed in succession to decode the data
+ Global plot/Polar plot of TAUHGH is produced (polar plots used because Region Of Interest is 65N to 90N
+ TimeTables Created and Plotted to show results over time at 1 day intervals

Note that the full files cover a grid of 576 x 361 points and span the globe. For purposes of this project the Region of Interest (ROI)
was limited to 65-90 Deg North and covered the full span of the globe in longitude. In addition the raw datafile,including all the (128) variables) over the entire globe
has a size of about 209 MBytes per file. It is possible to download only a subset of the full raw file. That was done in this case and this reduced the file size to just 132 KB 
because only 4 variables were downloaded. The full size files are not practical to host on GitHub.

## User Guide
This project requires significant effort to set up and to understand the data. For this reason an extensive User Guide was created and was stored in this repo.
The name of this file is "User Manual For ProcessCODData.docx". The reader is stringly advised to read this document afterdow downloading the contents of this repo.
As noted earlier,it is not easy to store files larger than 25 MB on the repo so only some of the "data only files " were stored. The workaround is that a copy of this repo is stored on
Dropbox. The user manual has a link to this repo which has a full collection of files.

## Reference Material
The EarthData site https://disc.gsfc.nasa.gov/datasets/M2TMNXRAD_5.12.4/summary?keywords=M2TMNXRAD_5.12.4 provides a wealth of reference material and the reader should study it. Some of the
reference papers have been included in the GitHub and Dropbox repos. A good start point is to read the paper The Modern-Era Retrospective Analysis for Research and Applications,
Version 2 (MERRA-2" by Gelaro et all. The Merra2 program creates approximately 60 different data products so no one reference can begin to cover this depth of material.

## Ancillary Software
There is one piece of government provided software that every user should have and use to assist in understanding the data. This software is called "Panoply" and can be downloaded
from the following site https://www.giss.nasa.gov/tools/panoply/download/  . Very highly recommended
 

  
