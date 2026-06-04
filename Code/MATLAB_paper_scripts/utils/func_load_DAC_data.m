function [lonDAC2d, latDAC2d, xDAC, yDAC, DAC]=func_load_DAC_data(fnameDAC,SLAT,SLON,HEMI, dirD)

%%  This function read in DAC file  and returns 2D arrays of data
%   Input:   
%       directory of DAC files
%       filename
%       Projection parameters (SLAT SLON HEMI)
%   Output:
%       latitude       m x n
%       longitude      m x n
%       PS X           m x n
%       PS Y           m x n
%       DAC            m x y


    srcD=[dirD fnameDAC];
    
    dac_full=ncread(srcD,'dac');
    lat_full=ncread(srcD,'latitude');
    lonDAC=ncread(srcD,'longitude');
    
    %restrict data to latitudes lower than -39 degree south

    idx=find(lat_full<-39);
    latDAC=lat_full(idx);
    DAC=dac_full(:,idx);
    [latDAC2d,lonDAC2d]=meshgrid(latDAC,lonDAC);

    %convert to PS
    [xDAC,yDAC]= mapll(latDAC2d,lonDAC2d,SLAT,SLON,HEMI);
