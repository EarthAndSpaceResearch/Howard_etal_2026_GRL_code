%% Script to extract elevations along line from from corrected tiles
% 
% For line defined in script, extract data along this line 
%
%  Input: 
%       - Files from Step 1
%             these include the inital tile, the advected initial tile, and the end tile
%
%  Output:  venable_transect.mat  which contains elevations along line
%  defined in script extracted from both the beginning and end tiles
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

clear;


%% read SWOT file 

%T1=load('..\step1_correct_advect\corrected_DACTIDES\SWOT_HR_raster_100m_025_199_010F_20241210_correctedDACTIDES.mat')
T1adv=load('..\step1_correct_advect\corrected_advected\SWOT_HR_raster_100m_025_199_010F_20241210_correctedDACTIDES_adv_to_20250907.mat');


%% read correced end file SWOT file 

TE=load('..\step1_correct_advect\corrected_DACTIDES\SWOT_HR_raster_100m_038_199_010F_20250907_correctedDACTIDES.mat');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pull project values from end tile
SLAT=TE.SLAT;
SLON=TE.SLON;
HEMI=TE.HEMI;


%% Define line for transect 

ptA = [-1848.7, 123.382];
ptB = [-1845.85, 126.428];

% Specify the number of intermediate points (e.g., 8 intermediate points, plus the two endpoints gives 10 total points)
num_points = 1000;
x_int= linspace(ptA(1), ptB(1), num_points);

% Generate equally spaced y-coordinates
y_int = linspace(ptA(2), ptB(2), num_points);


% extract elevations along line for end tile  (hE_line)

[c,d]=size(TE.xx);
X1d=reshape(TE.xx,[c*d,1]);
Y1d=reshape(TE.yy,[c*d,1]);
hsE1d=reshape(TE.h_swot,[c*d,1]);
idx=isnan(hsE1d==1);
[hsE1d_cl,TF] = rmmissing(hsE1d);
X1d_cl=X1d(TF==0);
Y1d_cl=Y1d(TF==0);

FS2= scatteredInterpolant(X1d_cl,Y1d_cl,hsE1d_cl,'linear','none');
hE_line=FS2(x_int,y_int);

clear c f Y1d X1d idx TF X1d_cl Y1d_cl

% extract elevations along line for initial corrected and advected tile (hadv_line)

[c,d]=size(T1adv.xxE);
X1d=reshape(T1adv.xxE,[c*d,1]);
Y1d=reshape(T1adv.yyE,[c*d,1]);
hsA1d=reshape(T1adv.h_SwotAdv,[c*d,1]);
idx=isnan(hsA1d==1);
[hsA1d_cl,TF] = rmmissing(hsA1d);
X1d_cl=X1d(TF==0);
Y1d_cl=Y1d(TF==0);

FS3= scatteredInterpolant(X1d_cl,Y1d_cl,hsA1d_cl,'linear','none');
hadv_line=FS3(x_int,y_int);



save venable_transect.mat ptA ptB x_int y_int hadv_line  hE_line SLAT SLON HEMI 

