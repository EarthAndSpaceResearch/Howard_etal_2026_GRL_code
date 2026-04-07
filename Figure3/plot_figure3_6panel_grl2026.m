%% Howard et al., 2026 GRL paper Figure 3 plotting script
%  
%  this reads in files created in the LarsenC and Venable subdirectories
%  User must run scripts in those directory first. Please see fig3_readme
%  for step by step instrcutions
%  
%
%  this script also requires:
%     plot_moa
%     cmocean amd brewermap for colormaps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
SLON=0;
SLAT=-71;
HEMI='s';

fs=12; % FontSize for titles and labels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Larsen C example tide flexure example.
% load in files for Larsen C fig3 example:

tilelow=load('.\LarsenC\Step1_DACTIDE_corrections\corrected_DACTIDES\SWOT_HR_raster_100m_032_115_016F_20250502_correctedDACTIDES.mat');
tileHigh=load('.\LarsenC\Step1_DACTIDE_corrections\\corrected_DACTIDES\SWOT_HR_raster_100m_038_115_016F_20250904_correctedDACTIDES.mat');
DT=load('.\LarsenC\Step2_extract_tide_flex_line\tideflex_trans_withDACTIDEScorr_grl2026.mat');

%   colormap
cm1=flipud(brewermap([],'Blues'));
cmb=brewermap([],'RdBu');

%  set high and load tile elevations  here we are Just using wse (no
%  corrections too see full ocean forced variability

high_h=tileHigh.wse; % -tileHigh.dacI;
low_h=tilelow.wse;   % -tilelow.dacI;

%% Make 6-panel figure, GZ flexure on left column, Venable rift growth on right
figure(20);clf

axm=[-2120 -2095 1050 1085]; % Tighter crop
axm=[-2120 -2095 1060 1085]; % Tighter still for Transect B

%% Map of maximum range
diffh=high_h - low_h;
hs(1)=subplot(3,2,1);
pcolor(tileHigh.xx,tileHigh.yy,diffh);shading interp; 
hc(1)=colorbar; clim([0 3.5]); hs(1).Colormap=cm1;
hold on
moacol=[255 204 153]/255; % Orange
plot_moa(3,moacol,SLAT,SLON,HEMI);

% Draw the transect line
ptA = [-2106.73, 1074.11];
ptB = [-2100.71, 1059.28];

% Specify the number of intermediate points (e.g., 8 intermediate points, plus the two endpoints gives 10 total points)
num_points = 1000;
x_int= linspace(ptA(1), ptB(1), num_points);

% Generate equally spaced y-coordinates
y_int = linspace(ptA(2), ptB(2), num_points);

loc=find(y_int>1066 & y_int<1073); x_int=x_int(loc); y_int=y_int(loc);
plot(x_int,y_int,'Color','#BE27F5','LineWidth',3)
axis('equal'); axis(axm)
xlabel('X coordinate (km)','FontSize',fs)
ylabel('Y coordinate (km)','FontSize',fs)
text(-2100,1082,['Larsen C ';'Ice Shelf'],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle','BackgroundColor','w')
text(-2118,1083,'(a)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle','BackgroundColor','w')
% Column title
text(-2107.5,1086,'Tidal motion & flexure','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','bottom')

grid on; set(gca,'GridAlpha',0.7,'layer','top')
%%


%cmp=brewermap(10,'Dark2')
cmp=["#7E2F8E","#0072BD","#4DBEEE","#77AC30","#EDB120","#7E2F8E",...
    "#0072BD","#4DBEEE","#A2142F","#77AC30"];
lstyle=['-','-','-','-','-',':',':',':','-',':' ];


xax=[1064 1073];

%% WSE transects (b)
hs(2)=subplot(3,2,3);
for i=1:10
    lcol=0.8*[1 1 1]; lw=0.5;
    if(i==4); lcol='b'; lw=1; end
    if(i==9); lcol='r'; lw=1; end

    x=DT.transSwot(i).ytr;
    corr=(DT.transSwot(i).CATStidetr) + (DT.transSwot(i).DACtr);
    %   Find tide+DAC just offshore of GL
    loc=find(~isnan(corr));
    corr_gl(i) = interp1(x(loc),corr(loc),1066,'spline');

    % Zero corrections for grounded ice
    corr(isnan(corr))=0;
    y=DT.transSwot(i).wsetr;
    % Limit plot to near GL
    loc=find(x>1066); x=x(loc); y=y(loc); corr=corr(loc);
    plot(x(loc),y(loc),'Color',lcol,'LineWidth',lw)
    y_off(i)=y(end);
    hold on
end
% Add offshore tides relative to Cycle 1;
for i=1:10
    lcol=0.8*[1 1 1]; lw=0.5;
    if(i==4); lcol='b'; lw=1; end
    if(i==9); lcol='r'; lw=1; end

    yloc=mean(y_off)+corr_gl(i)-mean(corr_gl);
    plot([1064.5 1065.5],[yloc yloc],'color',lcol,'LineWidth',lw);
end
text(1065,44,'C*','FontSize',fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'BackgroundColor','w')
ht=text(1068.5,45.5,'Cycle 38','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','left','VerticalAlignment','bottom','color','r');
ht=text(1068.5,43,'Cycle 32','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','right','VerticalAlignment','top','color','b');
text(1069.5,52.5,['{\it WSE} from 10 ';' cycles of HR     '],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','left','VerticalAlignment','middle')


xlim(xax); xticks = 1063:1:1074;

ylim([37 55]); yticks = 28:4:60;
ylabel('{\it WSE} (m)')
grid on; set(gca,'GridAlpha',0.5)
text(1072.5,53,'(b)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')

%% Transect of maximum WSE range (c)
hs(3)=subplot(3,2,5);
[~,n]=size(DT.transSwot(1).ytr);
ymean=zeros(n,1); ymin=ymean; ymax=ymean;
y2d=NaN*ones(n,10);
for i=1:10
    if(i==1)
        xp=DT.transSwot(i).ytr;
    end
    y2d(:,i)=DT.transSwot(i).wsetr;
end
ymean=mean(y2d,2); ymin=min(y2d,[],2); ymax=max(y2d,[],2);

% Replace with just Cycle 38 (Transect "9") - Cycle 32 (Transect "4") 
ymax=squeeze(y2d(:,9));
ymin=squeeze(y2d(:,4));

loc=find(xp>1066);
plot(xp(loc),ymax(loc)-ymin(loc),'Color','#7E2F8E','LineWidth',1); grid on
xlim(xax); ylim([-0.5 3.5]);
hold on

% Add a line denoting range of tide+DAC
corr_range=max(corr_gl)-min(corr_gl);
plot(xax,2.3*[1 1],'--k','LineWidth',1);
text(1072.5,3.0,'(c)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')
text(1071.8,0.0,['Flexure';'Zone   '],'FontSize',fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')

xlabel('Y coordinate (km)')
ylabel('{\it {\Delta}WSE} (m)')

legend('{\it {\Delta}WSE}','Offshore {\it{\Delta}WSE}','FontSize',fs,'Location','SouthEast')

grid on; set(gca,'GridAlpha',0.5)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VENABLE CREVASSE example

%files for Venable crevasse example
load('.\venable\step2_extract_transect\venable_transect.mat');
T1adv=load('.\venable\step1_correct_advect\corrected_advected\SWOT_HR_raster_100m_025_199_010F_20241210_correctedDACTIDES_adv_to_20250907.mat');
TE=load('.\venable\step1_correct_advect\corrected_DACTIDES\SWOT_HR_raster_100m_038_199_010F_20250907_correctedDACTIDES.mat');


ax=[-1855 -1840 120 135]; % Tight crop

diffh=TE.h_swot-T1adv.h_SwotAdv;

cmB=cmocean('balance');

%% Map panel (d)
hs(4)=subplot(3,2,2);
pcolor(TE.xx,TE.yy,diffh);shading interp;
clim([-5 5]); hc(4)=colorbar;
xlabel('X coordinate (km)','FontSize',fs)
ylabel('Y coordinate (km)','FontSize',fs)

plot_moa(.1,'w',SLAT,SLON,HEMI);
hold on
axis('equal')
axis(ax)
plot(x_int,y_int','Color','#BE27F5','LineWidth',3)
text(-1854,134,'(d)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'BackgroundColor','w')
text(-1852.5,122.5,['No HR';' data'],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')
text(-1842.5,127.5,['Venable';'  Ice  ';' Shelf '],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle','BackgroundColor','w')
% Column title
text(-1847.5,135.6,'Crevasse deepening','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','bottom')

grid on
set(gca,'Colormap',cmB,'GridAlpha',0.5,'layer','top')

%% Corrected WSE transects: (e)
hs(5)= subplot(3,2,4);

plot(x_int,hadv_line,'-.','Color','#41BE84' ,LineWidth=1)
hold on
plot(x_int,hE_line,'Color','#2A7A54',LineWidth=1)
text(-1848.85,48,'(e)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')
text(-1846.5,40,['Crevasse';'Deepens '],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')


legend('10 December 2024','7 September 2025','FontSize',12,'Location','SouthEast')
ylabel('{\it WSE_{corr}} + adv. (m)','FontSize',fs)
grid on; set(gca,'GridAlpha',0.5)
box on

%% Rift change (f)
hs(6)= subplot(3,2,6);
plot(x_int,hE_line-hadv_line,'k',LineWidth=1)
hold on
plot([x_int(1) x_int(end)],[ 0 0 ],'color','k',LineWidth=1)
text(-1848.85,0.7,'(f)','FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle')
text(-1847.25,-4,['Crevasse    ';'depth change'],'FontSize',1.2*fs,'FontWeight','bold',...
    'HorizontalAlignment','left','VerticalAlignment','middle')

% text(-1847,-4,'{\Delta}WSE_{corr} (m)','FontSize',fs,'FontWeight','bold')
xlabel('X coordinate (km)','FontSize',fs)
ylabel('{\it {\Delta}WSE_{corr}} + adv. (m)','FontSize',fs)

grid on; set(gca,'GridAlpha',0.5)
box on



%% Tidy up
pause(0.5)
% Need to force figure size on screen for consistent plotting layout
set(gcf,'Position',[1060 145 1120 1000]);

%return
% Column#1: LCIS GZ
yticklabel={'0','1','2'};
set(hs(3),'Position',[0.08 0.07 0.35 0.17],'FontSize',fs,'xdir','rev',...
    'YTick',0:1:2,'YTickLabel',yticklabel)
set(hs(2),'Position',[0.08 0.27 0.35 0.17],'FontSize',fs,'XTickLabel',[],'xdir','rev')
set(hs(1),'Position',[0.08 0.45 0.30 0.45],'FontSize',fs)

% Column#2: Venable rift
pause(1)
xlab6={'-1849',' ','-1848',' ','-1847',' ','-1846',' '};
set(hs(6),'Position',[0.52 0.07 0.35 0.17],'FontSize',fs,...
    'xlim',[-1849 -1845.5],'ylim',[-7 1.7],'XTickLabel',xlab6)
set(hs(5),'Position',[0.52 0.27 0.35 0.17],'FontSize',fs,...
     'xlim',[-1849 -1845.5],'ylim',[20 52],'XTickLabel',[])
set(hs(4),'Position',[0.53 0.45 0.30 0.45],'FontSize',fs)

set(hc(1),'Position',[0.40 0.55 0.01 0.25],'FontSize',fs)
hc(1).Label.String='{\it {\Delta}WSE} (m)';

set(hc(4),'Position',[0.84 0.55 0.01 0.25],'FontSize',fs)
hc(4).Label.String='Advected {\it{\Delta}WSE_{corr}} (m)';

return
print LCIS_GZ&VenableRift_TrB_for_paper_F3_FINAL.png -f20 -dpng -r300




