%% script to correct SWOT Raster Tiles for DAC and ocean tides
% Input: 
%      - SWOT HR Raster tile/tiles to correct
% 
%  The script needs access to:
%      -  Directory of downloaded AVISO DAC files
%      -  CATS2008_v2023.nc Tide model
%      -  TMD 3.0 software
%
%  User should set desired projection
%       
%  this script is currently set to read SWOT tiles in specified directory and correct
%  each one for:
%      - ocean tides (using CATS2008_v2023 model) 
%      - DAC (using AVISO DAC product)
%
%  Corrected tiles (*_correctedDACTIDES.mat) are written to user specified directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Set up user choices

% tide model 
Model='CATS2008_v2023.nc'; 

% set Polar Stereograohic projection
SLON=0;
SLAT=-71;
HEMI='s';


% Select Directory OF SWOT tiles to correct

b=pwd;  % store current directory
dirsrc='..\..\..\GRL2026_paperdata\fig3\SWOT_HR_LarsenC';
cd(dirsrc)
A=dir('*.nc');
cd(b)
[m,~]=size(A);

% select directory for output files
outdir='.\corrected_DACTIDES\';


%%%%%%%%%%%%%%%%%%%%%%%% End user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For each tile in directory, read in SWOT tile and correct for both tides
% and DAC

for i=1:m 

    %% read SWOT data
    src=[dirsrc '/' A(i).name ]
    
    %read swot file
    wse=ncread(src,'wse');
    sig0=ncread(src,'sig0');
    x=ncread(src,'x');
    y=ncread(src,'y');
    lat=ncread(src,'latitude');
    lon=ncread(src,'longitude');
    
    %convert to PS
    [xx,yy]= mapll(lat,lon,SLAT,SLON,HEMI);


    %% read time information from SWOT and find matching DAC file name
   
    [swot_time,fnameDAC]=func_readswottime_findDACdatematch(A(i).name)

    swot_time_dt(i)=datetime(swot_time.tileyr,swot_time.tilemm,swot_time.tiledy,swot_time.tilehr,swot_time.tilemin,swot_time.tilesec);

    %% read in DAC data 
    dirD=['Z:\MOG2d\' num2str(swot_time.tileyr) '\'];   % Store Aviso DAC files Sorted by year
  
    [lonD2, latD2, xD, yD, DAC]=func_load_DAC_data(fnameDAC,SLAT,SLON,HEMI, dirD);
   

    %% Apply corrections

    % tide correction
    [swottide]=tmd_predict(Model,lat,lon, swot_time_dt(i),'h');
    
    % DAC correction
    dacI=griddata(xD,yD,DAC,xx,yy);

    h_swot=wse-swottide -dacI;


    % strings for file name
    stryr=num2str(swot_time.tileyr);
    strmm=pad(num2str(swot_time.tilemm),2,'left','0');
    strdy=pad(num2str(swot_time.tiledy),2,'left','0');
   
   outname=['SWOT_HR_raster_100m' A(i).name(38:51) stryr strmm strdy '_correctedDACTIDES.mat']
   dt_swot=swot_time_dt(i);
   save([outdir outname],'-v7.3', 'h_swot','xx','yy','lat','lon', 'dacI', 'swottide','dt_swot','wse','SLAT','SLON','HEMI')

   clear h_swot dacI dac swottide xx yy lat lon xD yD DAC idx latD lonD dacI  wse sig0 x y swot_time swot_time_dt

end

