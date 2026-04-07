%% script to extract a transect from corrected SWOT tiles from STEP1
% For line defined in script, extract data along this line for all tiles
% and save this as structured array in output file
% 
% Input: 
%     Corrected SWOT HR Raster tiles (step 1 output)  - 
%         this script is currently set to read all corrected tiles in specified directory 
%     User should set desired projection
%  
%
% 
% Output
%   tideflex_trans_withDACTIDEScorr_grl2026.mat   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

SLON=0;
SLAT=-71;
HEMI='s';

%% read in Step 1 corrected tiles
b=pwd;
dirsrc='..\Step1_DACTIDE_corrections\corrected_DACTIDES\';
cd(dirsrc)

A=dir('*.mat');
cd(b)

[m,~]=size(A);

%% Define line for transect 

ptA = [-2106.73, 1074.11];
ptB = [-2100.71, 1059.28];


% Specify the number of intermediate points (e.g., 8 intermediate points, plus the two endpoints gives 10 total points)
num_points = 1000;
x_int= linspace(ptA(1), ptB(1), num_points);

% Generate equally spaced y-coordinates
y_int = linspace(ptA(2), ptB(2), num_points);


% for each tile, extract the following variables along the specificed line:
%    h_swot  (corrected swot elevations)
%    wse  (uncorrected)
%    DAC corrections  that were applied
%    CATS ocean tide corrections that were applied

%preallocate
transSwot(m).h_Swot_cor=0;
transSwot(m).wsetr=0;
transSwot(m).CATStidetr=0;
transSwot(m).DACtr=0;
transSwot(m).xtr=0;
transSwot(m).ytr=0;

swot_time(m)=datetime('now');
cycnm(m,1:3)='NaN';


for i=1:m
    src=[dirsrc A(i).name ];
    load(src);

    [c,d]=size(xx);

% H_swot : swot elevations corrected for DAC and ocean tidels

    X1d=reshape(xx,[c*d,1]);
    Y1d=reshape(yy,[c*d,1]);
    hsE1d=reshape(h_swot,[c*d,1]);
    [hsE1d_cl,TF] = rmmissing(hsE1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS2= scatteredInterpolant(X1d_cl,Y1d_cl,hsE1d_cl,'linear','none');
    transSwot(i).h_Swot_cor=FS2(x_int,y_int);

    clear TF X1d_cl Y1d_cl idx

% WSE  

    wse1d=reshape(wse,[c*d,1]);
    [wse1d_cl,TF] = rmmissing(wse1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS3= scatteredInterpolant(X1d_cl,Y1d_cl,wse1d_cl,'linear','none');
    transSwot(i).wsetr=FS3(x_int,y_int);
    
    clear TF X1d_cl Y1d_cl idx

% DAC corrections

    dac1d=reshape(dacI,[c*d,1]);
    [dac1d_cl,TF] = rmmissing(dac1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS4= scatteredInterpolant(X1d_cl,Y1d_cl,dac1d_cl,'linear','none');
    transSwot(i).DACtr=FS4(x_int,y_int);

    clear TF X1d_cl Y1d_cl idx
% CATS corrections
    swottide1d=reshape(swottide,[c*d,1]);
    [swottide1d_cl,TF] = rmmissing(swottide1d);
    X1d_cl=X1d(TF==0);
    Y1d_cl=Y1d(TF==0);
    
    FS5= scatteredInterpolant(X1d_cl,Y1d_cl,swottide1d_cl,'linear','none');
    transSwot(i).CATStidetr=FS5(x_int,y_int);

    transSwot(i).xtr=x_int;
    transSwot(i).ytr=y_int;
    swot_time(i)=dt_swot;
    cycnm(i,:)=A(i).name(21:23);
    disp(['cycle ' cycnm(i,:)])
    clear FS2 c d Y1d X1d idx TF X1d_cl Y1d_cl  xx yy h_swot dt_swot

end


save tideflex_trans_withDACTIDEScorr_grl2026.mat   transSwot  swot_time cycnm

