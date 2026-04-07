%% Howard et al., 2026 GRL paper Figure 2 plotting script
%  this reads in the files created in Steps 1 and 2
%
%  this script also requires the additional auxillary files:
%      \aux_files\streamline_1day_LarC.mat
%      \aux_files\vel_LarsenC.mat
%      \aux_files\snapshot-2025-10-17T00_00_00Z_aqua_rev1.tif
%
% Uses Brewermap for colormap 

clear; clf


%% load swot tiles
% first tile corrected
T1=load(".\step1_correct_advect_tiles\corrected_DACTIDES\SWOT_HR_raster_100m_034_115_016F_20250612_correctedDACTIDES.mat");
% last tile corrected
T6=load(".\step1_correct_advect_tiles\corrected_DACTIDES\SWOT_HR_raster_100m_039_115_016F_20250925_correctedDACTIDES.mat");
%first tile corrected & advected
T1A=load(".\step1_correct_advect_tiles\corrected_advected\SWOT_HR_raster_100m_034_115_016F_20250612_correctedDACTIDES_adv_to_20250925.mat");


%% uncorrected streamlines
ST34un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_034_uncorrected.mat");  
ST35un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_035_uncorrected.mat");  
ST36un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_036_uncorrected.mat");  
ST37un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_037_uncorrected.mat");   
ST38un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_038_uncorrected.mat");   
ST39un=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_039_uncorrected.mat");   

%% corrected and advected streamlines

ST34=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_034_corrected_adv20250925.mat");  
ST35=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_035_corrected_adv20250925.mat");  
ST36=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_036_corrected_adv20250925.mat");  
ST37=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_037_corrected_adv20250925.mat");   
ST38=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_038_corrected_adv20250925.mat"); 

%% corrected end streamline 
ST39=load(".\step2_get_streamlines\SWOT_HR_alongstreamline_039_corrected.mat");   


% height differences tiles
delt_H=T6.wse-T1.wse;    %  first and last, uncorrected
delt_HA=T6.h_swot-T1A.h_SwotAdv;     % first and last, after all corrections applied
delt_Hcor_noadv=T6.h_swot-T1.h_swot;  % first and last - corrections nut no advection

%height differences from streamline files
st_delh_uncor=ST39un.wse_line -ST34un.wse_line;
st_delh_cor=ST39.h_line -ST34.h_line;


%% get streamline 
load('..\aux_files\streamline_1day_LarC.mat');
x_int=xstr;
y_int=ystr;
% make section of streamline for plotting
idxx=find(x_int>-2195 & x_int <-2180);
nx=x_int(idxx);
ny=y_int(idxx);


%% Load in MEaSUREs velocity subset
load("..\aux_files\vel_LarsenC.mat")
vxsub1=vxsub/1000;
vysub1=vysub/1000;
sp=sqrt(vxsub1.^2 + vysub1.^2 );
vxn=vxsub1./sqrt(vxsub1.^2+vysub1.^2);
vyn=vysub1./sqrt(vxsub1.^2+vysub1.^2);
idx1=find(sp<=.025);
vxn(idx1)=0;
vyn(idx1)=0;

%% Load MODIS image
infile1='..\aux_files\snapshot-2025-10-17T00_00_00Z_aqua_rev1.tif';
tif_info = geotiffinfo(infile1);
Xc   = tif_info.CornerCoords.X;
Yc   = tif_info.CornerCoords.Y;
SLON=tif_info.ProjParm(2);
SLAT=abs(tif_info.ProjParm(1));
HEMI='s';
X=(Xc(4)+((1:tif_info.Width)-0.5)*tif_info.PixelScale(1))/1000; 
Y=(Yc(4)+((1:tif_info.Height)-0.5)*tif_info.PixelScale(1))/1000; 

M=readgeoraster(infile1);
M=flipud(M);
M=cast(M,'double');


%%%%%%%%%%%%%%%%%%%%%%%%% create figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up figure parameters

cmdelh=cmocean('balance');
cm1=flipud(brewermap([],'PuBuGn'));
cmB=brewermap(20,'YlOrRd');

% Line Colors
cmp=["#7E2F8E","#0072BD","#4DBEEE","#77AC30","#EDB120",	"#A2142F"];

ax=[-2220 -2160 1040 1100]; % For most maps
ax2=[-2300 -2100 1000 1200]; % For MODIS panel
xtick=[-2220:20:-2160]; ytick=[1040:20:1100];

fs=12; % Font size for all panel and colorbar labeling

pid={'a','d','g','b','e','h','c','f','i'}; % Panel IDs

clim_h=[30 55]; % Color range for WSE map
clim_dh=8*[-1 1]; % Color range for middle column dh maps




%% Figure

figure(10);clf
% To get a consistent figure alignment, need to set Figure window size
set(gcf,'Position',[1000 400 1100 700])

% MODIS panel
ca(1)=subplot(3,3,1);
nd=1;
p.x=X(1:nd:end); p.y=Y(1:nd:end); p.I=squeeze(M(1:nd:end,1:nd:end,2));
pcolor(p.x,p.y,mean(p.I,3)); shading flat; 
ca(1).Colormap=colormap(gray(256));
hold on
plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3)
% Add rectangle showing other maps
dx=ax(2)-ax(1); dy=ax(4)-ax(3);
hr=rectangle('Position',[ax(1) ax(3) dx dy],'EdgeColor','k','LineWidth',1.5);
%plot_moa(1,'k',SLAT,SLON,HEMI);
axis('equal'); axis(ax2);
set(ca(1),'CLim',[210 240]);
htit(1)=title('MODIS: 17 October 2025');
panel_id=['(' pid{1} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');

% SWOT h for time step 1
ca(4)=subplot(3,3,4);
plot_moa(.1,'k',SLAT,SLON,HEMI);
hold on
axis('equal'); axis(ax)
ca(4).Colormap=cm1;
pcolor(T1A.xxE,T1A.yyE,T1A.h_SwotAdv);shading interp; 
clim(clim_h); hc(4)=colorbar;
hc(4).Label.String='{\it WSE} (m)';
plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3) 
htit(4)=title('{\it WSE}: 12 June 2025');
grid on; 
panel_id=['(' pid{4} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
ylabel('Y Coordinate (km)','FontSize',fs)

% SWOT dh between time steps 1 and 6, no corrections
ca(2)=subplot(3,3,2);
plot_moa(.1,'k',SLAT,SLON,HEMI);
hold on
axis('equal'); axis(ax);
ca(2).Colormap=cmdelh;
pcolor(T6.xx,T6.yy,delt_H);shading interp;clim(clim_dh); %colorbar
plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3) 
htit(2)=title('{\it {\Delta}WSE}');
grid on
panel_id=['(' pid{2} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');


% SWOT dh between time steps 1 and 6, height-corrected but unadvected
ca(5)=subplot(3,3,5);
plot_moa(.1,'k',SLAT,SLON,HEMI);
hold on
axis('equal'); axis(ax)
ca(5).Colormap=cmdelh;
pcolor(T6.xx,T6.yy,delt_Hcor_noadv);shading interp;clim(clim_dh);
hc(5)=colorbar;
plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3) 
htit(5)=title('{\it {\Delta}WSE_{corr}}');
grid on
panel_id=['(' pid{5} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');


% SWOT dh between time steps 1 and 6, height-corrected and advected
ca(8)=subplot(3,3,8);
plot_moa(.1,'k',SLAT,SLON,HEMI);
hold on
axis('equal'); axis(ax);
ca(8).Colormap=cmdelh;
pcolor(T6.xx,T6.yy,delt_HA);shading interp; clim(clim_dh); % colorbar
plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3) 
htit(8)=title('{\it {\Delta}WSE_{corr}} + advection');
grid on
panel_id=['(' pid{8} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
xlabel('X Coordinate (km)','FontSize',fs)


% MEaSUREs velocity map
ca(7)=subplot(3,3,7);
pcolor(x2d,y2d,sp');shading interp; clim([0 0.8]); hc(7)=colorbar;
ca(7).Colormap=cmB;
%yl2 = ylabel(cb,'speed (km/yr)','FontSize',24);
plot_moa(.1,'k',SLAT, SLON,HEMI)
axis('equal'); axis(ax)
dc=15; % Decimation rate for quiver direction overlay

quiver(x2d(1:dc:end,1:dc:end),y2d(1:dc:end,1:dc:end), vxn(1:dc:end,1:dc:end)',vyn(1:dc:end,1:dc:end)','color','k','MarkerSize',10)

plot(x_int,y_int,'k',LineWidth=1) 
plot(nx,ny,'g',LineWidth=3) 
hc(7).Label.String='{\it V_{ice}} (km/yr)';
htit(7)=title('MEaSUREs ice velocity');
grid on
panel_id=['(' pid{7} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.09*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
xlabel('X Coordinate (km)','FontSize',fs)


%% TRANSECTS
yrange=[min(ny) max(ny)];

% Uncorrected h
ca(3)=subplot(3,3,3);
hold on
plot(ST34un.y_int,ST34un.wse_line,'Color',cmp(1),LineWidth=1)
plot(ST35un.y_int,ST35un.wse_line,'Color',cmp(2),LineWidth=1)
plot(ST36un.y_int,ST36un.wse_line,'Color',cmp(3),LineWidth=1)
plot(ST37un.y_int,ST37un.wse_line,'Color',cmp(4),LineWidth=1)
plot(ST38un.y_int,ST38un.wse_line,'Color',cmp(5),LineWidth=1)
plot(ST39un.y_int,ST39un.wse_line,'Color',cmp(6),LineWidth=1)
xlim(yrange)
ylim([29 46])
grid on
ylabel('{\it WSE} (m)')
panel_id=['(' pid{3} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.04*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
ht=text(1072.5,yc,'{\it WSE}','fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold');
box on

% Corrected h
ca(6)=subplot(3,3,6);
hold on
plot(ST34.y_int,ST34.h_line,'Color',cmp(1),LineWidth=1)
plot(ST35.y_int,ST35.h_line,'Color',cmp(2),LineWidth=1)
plot(ST36.y_int,ST36.h_line,'Color',cmp(3),LineWidth=1)
plot(ST37.y_int,ST37.h_line,'Color',cmp(4),LineWidth=1)
plot(ST38.y_int,ST38.h_line,'Color',cmp(5),LineWidth=1)
plot(ST39.y_int,ST39.h_line,'Color',cmp(6),LineWidth=1)
xlim(yrange)
ylabel('Advected {\it WSE_{corr}} (m)')
grid on
ylim([29 46])
panel_id=['(' pid{6} ')'];
xl=xlim; yl=ylim; xc=xl(1)+0.04*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
ht=text(1072.5,yc,'{\it WSE_{corr}}+advection','fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold');

box on
% dh comparing uncorrected and corrected
ca(9)=subplot(3,3,9);
hold on
plot([-2195 -2180],[0 0],'Color',[0.5 0.5 0.5],'LineWidth',0.5)
plot(ST39.y_int,st_delh_cor,'Color',cmp(6),LineWidth=1)
plot(ST39.y_int,st_delh_uncor,'Color',0.5*[1 1 1],LineWidth=0.5)
xlim(yrange)
grid on
xlabel('Y coordinate (km)');
ylabel('{\it {\Delta}h} (m)')
panel_id=['(' pid{9} ')'];
set(gca,'ylim',[-8 12]);
xl=xlim; yl=ylim; xc=xl(1)+0.04*diff(xl); yc=yl(1)+0.91*diff(yl);
ht=text(xc,yc,panel_id,'fontsize',1.0*fs,'HorizontalAlignment','center',...
    'VerticalAlignment','middle','FontWeight','bold','BackgroundColor','w');
hleg9=legend('{\it {\Delta}WSE}','{\it {\Delta}WSE_{corr}}+advection');
set(hleg9,'FontSize',0.8*fs,'Location','NorthEast')
box on
%% Tidy up

% Set constant tick marks for common map panels
for ip=[2 4 5 7 8]
    set(ca(ip),'XTick',xtick,'YTick',ytick,'layer','top','GridAlpha',0.7)
end

for ip=1:9
    set(ca(ip),'FontSize',fs)
end
for ip=[1,2,4,5,7,8]
    htit(ip).FontSize=10;
end

xlab={' ','-2200',' ','-2160',' '};
for ip=[2,4,5,7,8]
    set(ca(ip),'XTick',-2220:20:-2160,'XTickLabel',xlab,'XTickLabelRotation',0);
end

dy=0.23;
set(ca(1),'Position',[0.05 0.70 0.20 dy])
set(ca(4),'Position',[0.05 0.40 0.20 dy])
set(ca(7),'Position',[0.05 0.10 0.20 dy])
set(ca(2),'Position',[0.28 0.70 0.20 dy])
set(ca(5),'Position',[0.28 0.40 0.20 dy],'YTickLabel',[])
set(ca(8),'Position',[0.28 0.10 0.20 dy],'YTickLabel',[])

set(hc(4),'Position',[0.23 0.415 0.01 0.20],'FontSize',0.9*fs)
set(hc(5),'Position',[0.48 0.205 0.01 0.60],'YTick',[-8:2:8],'FontSize',fs)
hc(5).Label.String='{\it {\Delta}h} (m)';
set(hc(7),'Position',[0.23 0.115 0.01 0.20],'FontSize',0.9*fs)

set(ca(3),'Position',[0.60 0.70 0.37 0.25],'XTickLabel',[])
set(ca(6),'Position',[0.60 0.40 0.37 0.25],'XTickLabel',[])
set(ca(9),'Position',[0.60 0.10 0.37 0.25])

return
print Figure2_9panel_FINAL.png -f10 -dpng -r300
