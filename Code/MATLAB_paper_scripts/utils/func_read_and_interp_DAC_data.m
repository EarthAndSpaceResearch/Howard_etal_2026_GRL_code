function [lonDAC2d, latDAC2d, xDAC, yDAC, DAC,swotJD]=func_read_and_interp_DAC_data(fnameDAC1,fnameDAC2,SLAT,SLON,HEMI, dirD, swot_time,DAC_time1_jd,DAC_time2_jd)

%%  This function reads in 2 DAC files, and returns 2D arrays of DAC values interpolated to swot tile (mid time)
%   Input:   
%       directory of DAC files
%       DAC filenames 
%       Projection parameters (SLAT SLON HEMI)
%       Swot and DAC times
%   Output:
%       latitude       m x n
%       longitude      m x n
%       PS X           m x n
%       PS Y           m x n
%       DAC            m x y
%       swot julian date


%set up srcs and read in 2 DAC files
    srcD1=[dirD fnameDAC1];
    srcD2=[dirD fnameDAC2];
    
    dac_full1=ncread(srcD1,'dac');
    dac_full2=ncread(srcD2,'dac');
    
    %grids are same, read lat and lon from just 1
    lat_full=ncread(srcD1,'latitude');
    lonDAC=ncread(srcD1,'longitude');
    
    %restrict data to latitudes lower than -39 degree south

    idx=find(lat_full<-39);
    latDAC=lat_full(idx);


    DAC1=dac_full1(:,idx);
    DAC2=dac_full2(:,idx);
  
    
    [m,n]=size(DAC1);
   

    swotJD=juliandate(datetime(swot_time.tileyr,swot_time.tilemm,swot_time.tiledy,swot_time.tilehr,swot_time.tilemin,swot_time.tilesec));

    %initialize array
    DAC=zeros(m,n);

    %interperolate DAC to SWOT time 
    for i=1:m
        for j=1:n    
            DAC(i,j)=interp1([DAC_time1_jd DAC_time2_jd], [DAC1(i,j) DAC2(i,j)],swotJD);
        end
    end

      
    
    [latDAC2d,lonDAC2d]=meshgrid(latDAC,lonDAC);
 
    %convert to PS
    [xDAC,yDAC]= mapll(latDAC2d,lonDAC2d,SLAT,SLON,HEMI);
