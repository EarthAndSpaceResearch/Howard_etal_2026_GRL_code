%% Script to advect SWOT HR tile data
%  Input: 
%       - File1: the file/files you want to advect
%       - File2: the file containing the date you want to end up at
%       - MEaSURES velocity file.  Here we use a subset of this dataset over Larsen C (vel_LarsenC.mat) for efficiency
%
%  Output:  advected Tiles (*_adv_to_' enddate '.mat') are saved in user specified directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

% Location of corrected files
fdir='.\corrected_DACTIDES\';

% tiles to advect 
fname1=['SWOT_HR_raster_100m_034_115_016F_20250612_correctedDACTIDES';
    'SWOT_HR_raster_100m_035_115_016F_20250703_correctedDACTIDES';  
    'SWOT_HR_raster_100m_036_115_016F_20250724_correctedDACTIDES';  
    'SWOT_HR_raster_100m_037_115_016F_20250814_correctedDACTIDES';  
    'SWOT_HR_raster_100m_038_115_016F_20250904_correctedDACTIDES']; 


[fn,~]=size(fname1);

% Tile that we are advecting other tiles to
fname2='SWOT_HR_raster_100m_039_115_016F_20250925_correctedDACTIDES';
enddate= fname2(34:41);   % date of end tile (date we are advecting too, used for output name)

% Load in subset of MeASUREs dataset to use for advection
load("..\..\aux_files\vel_LarsenC.mat")

% select directory for output files
outdir='.\corrected_advected\';


%%%%%%%%%%%%%% end user input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% load in corrected SWOT data tiles

for l=1:fn

    % load in data
    
    load([fdir fname1(l,:) '.mat']);  % load in file to advect
    SE=load([fdir fname2 '.mat']);   %  Swot End (SE) File loaded into SE array
    
    disp([' Advecting ' fname1(l,:)])

    xxE=SE.xx;
    yyE=SE.yy;
    timeend=SE.dt_swot;
    
    % set up time info from corrected tiles
    timeST=dt_swot;
    timeE=SE.dt_swot;
    
    % we will use a time step of one day.
    dt=days(diff([timeST;timeE]) ); % get number of days between files
    timesteps=round(dt); % round to nearest day
    
    
    %set up arrays for advected aroias
    new_x1=xx;
    new_y1=yy;
    
    % advect
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
    idx=isnan(h_swot1d==1);
    [h_swot1d_cl,TF] = rmmissing(h_swot1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS= scatteredInterpolant(X1d_cl,Y1d_cl,h_swot1d_cl,'linear','none');
    h_SwotAdv=FS(xxE,yyE);
 
    outname=[fname1(l,:) '_adv_to_' enddate '.mat'];
    save([outdir outname],'-v7.3','xxE','yyE','h_SwotAdv','timeend', 'SLAT','SLON','HEMI' )

   clear xxE yyE timeend h_swot1d X1d_cl Y1d_cl X1d Y1d h_SwotAdv h_swot c d new_y1 new_x1 SE vxI vyI timeST timeE dt timesteps xx yy
end 
