%% Script to advect SWOT HR tile data
%  Input: 
%       - File1: the file/files you want to advect
%       - File2: the file containing the date you want to end up at
%       - MEaSURES velocity file.  Here we use a subset of this dataset over Venable (vel_Venable.mat) for efficiency
%
%  Output:  advected Tiles (*_adv_to_' enddate '.mat') are saved in user specified directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
% Location of corrected files
fdir='.\corrected_DACTIDES\';

% read SWOT file  to advect
fname1='SWOT_HR_raster_100m_025_199_010F_20241210_correctedDACTIDES';

% what we are advecting too
fname2='SWOT_HR_raster_100m_038_199_010F_20250907_correctedDACTIDES';
enddate= fname2(34:41);

% Load in subset of MeASUREs dataset to use for advection
load("..\..\..\aux_files\vel_Venable.mat")
%remove nans
idx=find(isnan(vxsub));
vxsub(idx)=0.0;
clear idx

idx=find(isnan(vysub));
vysub(idx)=0.0;
clear idx

% select directory for output files
outdir='.\corrected_advected\';


%%%%%%%%%%%%%% end user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% load in corrected SWOT data tiles

% load in data

load([fdir fname1 '.mat']);

SE=load([fdir fname2 '.mat']);   %  swot end File loaded into SE array


xxE=SE.xx;
yyE=SE.yy;
timeend=SE.dt_swot;


% 1 to 5
timeST=dt_swot;
timeE=SE.dt_swot;

% we will use a time step of one day.
dt=days(diff([timeST;timeE]) ); % get number of days between files
timesteps=round(dt); % round to nearest day


%set up arrays for advecting tile
new_x1=xx;
new_y1=yy;


for i=1:timesteps  % time step is 1 day
    %convert from m/year to km/day.  
   vxI=interp2(x2d,y2d,vxsub',new_x1,new_y1 )/(1000*365);
   vyI=interp2(x2d,y2d,vysub',new_x1,new_y1)/(1000*365);
   [m,n]=size(new_x1);
  for j=1:m
    for k=1:n
     new_x1(j,k)=new_x1(j,k)+ (vxI(j,k)*(1)) ;
     new_y1(j,k)=new_y1(j,k)+ (vyI(j,k)*(1)) ;
    end
  end
end



%interpret advected on to end grid for differencing

[c,d]=size(new_x1);
X1d=reshape(new_x1,[c*d,1]);
Y1d=reshape(new_y1,[c*d,1]);
h_swot1d=reshape(h_swot,[c*d,1]);
[h_swot1d_cl,TF] = rmmissing(h_swot1d);
X1d_cl=X1d(TF==0);
Y1d_cl=Y1d(TF==0);

FS= scatteredInterpolant(X1d_cl,Y1d_cl,h_swot1d_cl,'linear','none');
h_SwotAdv=FS(xxE,yyE);

outname=[fname1 '_adv_to_' enddate '.mat'];
save([outdir outname],'-v7.3','xxE','yyE','h_SwotAdv','timeend', 'SLAT','SLON','HEMI' )



