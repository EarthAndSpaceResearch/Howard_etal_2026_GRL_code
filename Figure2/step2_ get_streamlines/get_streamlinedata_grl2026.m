%% script to extract data from SWOT HR Raster Tiles (corrected and uncorrected) along a streamline
%
%  Input:
%      - Streamline file: \aux_files\streamline_1day_LarC.mat)
%      - Corrected files from Step1a
%      - Corrected and advected files from Step 1b
%
%  Output: for the given streamline, it extracts data along this streamline and saves to a file
%
%      - SWOT_HR_alongstreamline_*_uncorrected.mat:  files with wse (uncorrected) data 
% 
%      - SWOT_HR_alongstreamline_*_corrected_adv20250925.mat: files with h_SwotAdv
%                                            (corrected and advected) data
%
%      - SWOT_HR_alongstreamline_*_corrected.mat: files with h_Swot (corrected but not advected)                        
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

% set file directory locations

fldir='..\step1_correct_advect_tiles\corrected_DACTIDES\';
advfldir='..\step1_correct_advect_tiles\corrected_advected\';


% files to extract the uncorrected streamlines (wse) from
% note these files contain both corrected (h_swot) and uncorrected (wse)
% data
fnames=['SWOT_HR_raster_100m_034_115_016F_20250612_correctedDACTIDES.mat';
    'SWOT_HR_raster_100m_035_115_016F_20250703_correctedDACTIDES.mat';  
    'SWOT_HR_raster_100m_036_115_016F_20250724_correctedDACTIDES.mat';  
    'SWOT_HR_raster_100m_037_115_016F_20250814_correctedDACTIDES.mat';  
    'SWOT_HR_raster_100m_038_115_016F_20250904_correctedDACTIDES.mat';  
    'SWOT_HR_raster_100m_039_115_016F_20250925_correctedDACTIDES.mat'] ; 

[m,~]=size(fnames);


%files to extract the corrected and advected streamlines from
% h_swotAdv
advfnames=['SWOT_HR_raster_100m_034_115_016F_20250612_correctedDACTIDES_adv_to_20250925.mat';
    'SWOT_HR_raster_100m_035_115_016F_20250703_correctedDACTIDES_adv_to_20250925.mat';  
    'SWOT_HR_raster_100m_036_115_016F_20250724_correctedDACTIDES_adv_to_20250925.mat';  
    'SWOT_HR_raster_100m_037_115_016F_20250814_correctedDACTIDES_adv_to_20250925.mat';  
    'SWOT_HR_raster_100m_038_115_016F_20250904_correctedDACTIDES_adv_to_20250925.mat'] ; 

[n,~]=size(advfnames);


% load in stream line x and y values (in PS)
load '..\..\aux_files\streamline_1day_LarC.mat'

x_int=xstr;
y_int=ystr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find data along streamlines  


% use scatteredInterpolant to get WSE values(UNCORRECTED) along streamline 

for i=1:m   %  number of uncorrected files to extract data from

    load([fldir fnames(i,:)])
    [c,d]=size(xx);
    X1d=reshape(xx,[c*d,1]);
    Y1d=reshape(yy,[c*d,1]);
    hsA1d=reshape(wse,[c*d,1]);

    [hsA1d_cl,TF] = rmmissing(hsA1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS= scatteredInterpolant(X1d_cl,Y1d_cl,hsA1d_cl,'linear','none');
    wse_line=FS(x_int,y_int);

    cycnum=fnames(i,21:23);
    save(['SWOT_HR_alongstreamline_' cycnum '_uncorrected.mat'], 'y_int', 'x_int', 'wse_line');
    clear c d X1d Y1d hsA1d wse TF hsA1d_cl  X1d_cl Y1d_cl FS wse_line
end

%Now get corrected and advected streamlines
for i=1:n  % number of corrected & advected files to extract data from
    load([advfldir advfnames(i,:)])
    [c,d]=size(xxE);
    X1d=reshape(xxE,[c*d,1]);
    Y1d=reshape(yyE,[c*d,1]);
    hsA1d=reshape(h_SwotAdv,[c*d,1]);
    
    [hsA1d_cl,TF] = rmmissing(hsA1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS= scatteredInterpolant(X1d_cl,Y1d_cl,hsA1d_cl,'linear','none');
    h_line=FS(x_int,y_int);

    cycnum=fnames(i,21:23);
    save(['SWOT_HR_alongstreamline_' cycnum '_corrected_adv' advfnames(i,68:75) '.mat'], 'y_int', 'x_int', 'h_line');
    clear c d X1d Y1d hsA1d h_SwotAdv TF hsA1d_cl  X1d_cl Y1d_cl FS h_line
end

% for the end tile, we want corrected data but not advected,
% so, from SWOT_HR_raster_100m_039_115_016F_20250925_correctedDACTIDES.mat, so use h_swot

for i=m:m
    load([fldir fnames(i,:)])
    [c,d]=size(xx);
    X1d=reshape(xx,[c*d,1]);
    Y1d=reshape(yy,[c*d,1]);
    hsA1d=reshape(h_swot,[c*d,1]);
    idx=isnan(hsA1d==1);
    [hsA1d_cl,TF] = rmmissing(hsA1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS2= scatteredInterpolant(X1d_cl,Y1d_cl,hsA1d_cl,'linear','none');
    h_line=FS2(x_int,y_int);


    cycnum=fnames(i,21:23);
    save(['SWOT_HR_alongstreamline_' cycnum '_corrected.mat'], 'y_int', 'x_int', 'h_line');
    clear c d X1d Y1d hsA1d h_swot TF hsA1d_cl  X1d_cl Y1d_cl FS h_line
end