%% Script to create file to used for Figure 1, comparing SWOT with IS2 
%  Inputs:
%     SWOT HR raster file
%     ICESat2 ATL06 granule
%     DAC file for SWOT DAC corrections
%     
%  Set projection parameters: SLON, SLAT, and HEMI
%
%  output:
%     fig1_variables_GRL2026.mat:  file used in figure 1 plotting
%
%  Requires:
%     TMD3.0
%     CATS2008_v2023.nc tide model
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
%parameters for stereographic projection/
SLON=0;
SLAT=-71;
HEMI='s';

%Model='Model_CATS2008';
Model='CATS2008_v2023.nc'



%% atl06 filname and path
dir06='..\GRL2026_paperdata\fig1\validation_files\';
fn06='ATL06_20250125173907_06202610_006_01.h5';

%% Swot filanmename and path
dir='..\GRL2026_paperdata\fig1\validation_files\';
fname='SWOT_L2_HR_Raster_100m_UTM20D_N_x_x_x_027_328_140F_20250125T101527_20250125T101548_PIC2_01.nc';

%% DAC file name and Path
dacyear=fname(52:55);   % data organized by year 
dirD=['Z:\MOG2d\' dacyear '\'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read DAC file for swot
%
  
    [swot_time,fnameDAC1,fnameDAC2,DAC_time1_jd,DAC_time2_jd]=func_readswottime_find_DAC_files(fname);
    [lonD2, latD2, xD, yD, dac,swotJD]=func_read_and_interp_DAC_data(fnameDAC1,fnameDAC2,SLAT,SLON,HEMI, dirD, swot_time,DAC_time1_jd,DAC_time2_jd);

    %check times
    % disp(['DAC filemames:   ' fnameDAC1 '    ' fnameDAC2])
    % disp(['SWOT jd: ' num2str(swotJD)])
    % disp(['DAC  jd: ' num2str(DAC_time1_jd)  '    ' num2str(DAC_time2_jd)])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% read in IS2 variables

src06=[dir06 fn06];

% find strong beams, which are based on the orientation of the IS2
% satellite:  spacecraft orientation parameter values: ['0', '1', '2']; value meanings: ['backward', 'forward', 'transition'] 
sc_orient = h5read(src06, '/orbit_info/sc_orient'); 

%Get strong beams numbers
 if sc_orient == 1
     %strong beams are
     strbeams=[2,4,6];
 elseif sc_orient == 0
     strbeams=[1,3,5];
 else
     disp('in transition')     
 end

% Read in ICESat-2 data for a strong beams and correct for Ocean tides and DAC

[gt1]=func_get_IS2_gtX_corr(dir06,fn06, Model, SLAT, SLON, HEMI, strbeams(1) );
[gt2]=func_get_IS2_gtX_corr(dir06,fn06, Model, SLAT, SLON, HEMI, strbeams(2) );
[gt3]=func_get_IS2_gtX_corr(dir06,fn06, Model, SLAT, SLON, HEMI, strbeams(3) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read SWOT file 

src=[dir fname];
cycS=fname(39:41);
pass=fname(43:45);
swot_time_dt=datetime(2025,01,25,10,15,37);

SWOT.wse=ncread(src,'wse');
SWOT.sig0=ncread(src,'sig0');
SWOT.x=ncread(src,'x');
SWOT.y=ncread(src,'y');
SWOT.lat=ncread(src,'latitude');
SWOT.lon=ncread(src,'longitude');

%convert to PS
[SWOT.xx,SWOT.yy]= mapll(SWOT.lat,SWOT.lon,SLAT,SLON,HEMI);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Next Find SWOT transects at IS2 track locations, and correct for tides and DAC 

% Set up scatteredinterpolant function 
[c,d]=size(SWOT.xx);
X1d=reshape(SWOT.xx,[c*d,1]);
Y1d=reshape(SWOT.yy,[c*d,1]);
wse1d=reshape(SWOT.wse,[c*d,1]);
idx=isnan(wse1d==1);
[wse1d_cl,TF] = rmmissing(wse1d);
X1d_cl=X1d(TF==0);
Y1d_cl=Y1d(TF==0);

FS= scatteredInterpolant(X1d_cl,Y1d_cl,wse1d_cl,'linear','none');


%% Get SWOT on IS2 tracks

% gt1l
wseI1=FS(gt1.x,gt1.y); % interpolate SWOT data onto IS2 track locations
dacline1=griddata(xD,yD,dac,gt1.x,gt1.y); % get dac for SWOT along IS2 track
[swottide1]=tmd_predict(Model,gt1.lat,gt1.lon, swot_time_dt,'h'); % get tide for SWOT
h_Swot_gt1_corr=wseI1-swottide1 -dacline1; %correct swot

% gt2l
wseI2=FS(gt2.x,gt2.y); % interpolate SWOT data onto IS2 track locations
dacline2=griddata(xD,yD,dac,gt2.x,gt2.y); % get dac for SWOT along IS2 track
[swottide2]=tmd_predict(Model, gt2.lat,gt2.lon,swot_time_dt,'h'); % get tide for SWOT
h_Swot_gt2_corr=wseI2-swottide2 -dacline2; %correct swot

% gt3l
wseI3=FS(gt3.x,gt3.y); % interpolate SWOT data onto IS2 track locations
dacline3=griddata(xD,yD,dac,gt3.x,gt3.y); % get dac for SWOT along IS2 track
[swottide3]=tmd_predict(Model,gt3.lat,gt3.lon, swot_time_dt,'h'); % get tide for SWOT
h_Swot_gt3_corr=wseI3-swottide3 -dacline3; %correct swot line


%% Calcuate Delta_h for three tracks:  Delta_h =  SWOT_h_corr - IS2_h_corr
   dh_gt1=h_Swot_gt1_corr-gt1.atl06_Hcor;
   dh_gt2=h_Swot_gt2_corr-gt2.atl06_Hcor;
   dh_gt3=h_Swot_gt3_corr-gt3.atl06_Hcor;

 

save fig1_variables_GRL2026.mat gt1 gt2 gt3 SWOT h_Swot_gt1_corr h_Swot_gt2_corr h_Swot_gt3_corr dh_gt1 dh_gt2 dh_gt3   fname fn06 fnameDAC1 fnameDAC2
