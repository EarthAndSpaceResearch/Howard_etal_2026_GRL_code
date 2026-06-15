%% Howard et al., 2026 GRL paper Figure 1 plotting script
%  
%  figure 1: Examples of HR Raster data coverage, and validation of SWOT using ICESat-2 altimetry.
%    
%  Input
%      fig1_variables_GRL2026.mat:created by create_fig1files_GRL2026.m
%      Set of Cycle 28 SWOT HR Raster files (see data file list)
%      \aux_files\Larsen_ts34_mask.mat
%     
%  requires:
%     plot_moa.m & data
%     mapll.m 
%     Brewermap for colormap
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

SLON=0;
SLAT=-71;
HEMI='s';

fs=12; % Font Size for axes and colorbars

%% get data

% data file from create_fig1files_GRL2026.m
load fig1_variables_GRL2026.mat

%% get list of Larsen tiles  (uncorrected Larsen C cycle 28 HR tiles
b=pwd;

dirsrc='..\GRL2026_paperdata\fig1\LarFiles_completeset\';   
cd(dirsrc)

A=dir('*.nc');
cd(b);
[m,~]=size(A);


%% load Larsen subset mask
LM=load('..\aux_files\Larsen_ts34_mask.mat');  % x y IS2_era_mask_timestep_34 SLAT SLON HEMI

%% Plotting plotting parameters.
figure(10);clf
axall=[-2400 -1900 925 1300]; % axis limits for overview map
%ax=[-2090 -2000 1050 1110]; % axis limits
ax=[-2060 -2010 1050 1110]; % axis limits

ax_full=[-2550 -1900 950 1400];  % For panel (a)

ax_fig2=[-2220 -2160 1040 1100]; %to plot area used in fig 2
ax_fig3=[-2120 -2095 1060 1085];  %to plot area used in fig 3a
%limits for histogram - all beams : only use where x<-2022 and x > -2050
lowlim1=-2043; uplim1=-2015;
lowlim2=-2050; uplim2=-2022;  % Susan's default for histogramming
lowlim3=-2058; uplim3=-2030;  % Susan's default for histogramming

tr_lim=[-2060 -2010]; % Transect limits for panels (c) & (d)

idx=find(gt1.x<uplim1 & gt1.x>lowlim1);
ndh1=dh_gt1(idx);
nx1=gt1.x(idx);
ny1=gt1.y(idx);
clear idx

idx=find(gt2.x<uplim2  & gt2.x>lowlim2);
ndh2=dh_gt2(idx);
nx2=gt2.x(idx);
ny2=gt2.y(idx);
clear idx

idx=find(gt3.x<uplim3  & gt3.x>lowlim3);
ndh3=dh_gt3(idx);
nx3=gt3.x(idx);
ny3=gt3.y(idx);
clear idx

% concatenate all dh for 3 beam sections
Alldh=cat(1,ndh1, ndh2, ndh3);

%% Make Figure
figure(10); clf
% To get a consistent figure alignment, need to set Figure window size
set(gcf,'Position',[1000 400 1100 700])

npanels=5;

%cm1=flipud(brewermap(50,'PuBuGn')); % Colormap for SWOT maps
cm2=brewermap(42,'PuBu');
swotlimc=[0 50];

%% Plot SWOT tile large map
hs(1)=subplot(npanels,1,1);
hold on
for i=1:m
    src=[dirsrc A(i).name ];

    wse1=ncread(src,'wse');
    lat1=ncread(src,'latitude');
    lon1=ncread(src,'longitude');
    [xx1,yy1]= mapll(lat1,lon1,SLAT,SLON,HEMI);
    pcolor(xx1,yy1,wse1);shading interp;

    clim([-4 80]);hc=colorbar; colormap(gca,cm2)
    set(hc,'ylim',[0 80])
    set(gca,'fontsize',fs)
end
dc=1;  %choose decimation rate for plotting
contour(LM.x(1:dc:end),LM.y(1:dc:end),...
    LM.IS2_era_mask_timestep_34(1:dc:end,1:dc:end),[1 1],...
    'Color','#9a32c9','LineWidth',2)
plot_moa(.1,'k',SLAT,SLON,HEMI);

% plot(gt1x,gt1y,'Color', '#A2142F')
% plot(gt3x,gt3y,'Color', '#A2142F')
% plot(gt5lx,gt5ly,'Color', '#A2142F')

grid on; set(gca,'layer','top','GridAlpha',0.7)
%xlabel('distance (km)')
ylabel('Y coordinate (km)')
%title('SWOT HR: WSE (m)','FontSize',fs)
axis('equal'); axis(ax_full);
ht=text(-2100,1350,['Weddell';'  Sea  '],'FontSize',1.4*fs,...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontAngle','italic','FontWeight','bold');
htap=text(-2410,1230,['Ant.';'Pen.'],'FontSize',1.2*fs,...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontAngle','italic','FontWeight','bold','Color','k');
box('on')
xlimits=xlim(gca); ylimits=ylim(gca);
xt=xlimits(1)+0.05*diff(xlimits);
yt=ylimits(2)-0.05*diff(ylimits);

text(xt,yt,'{\bf (a)}','FontSize',1.1*fs,'BackgroundColor','w', ...
    'HorizontalAlignment','center','VerticalAlignment','middle')
% plot(gt1x,gt1y,'Color', '#A2142F','LineWidth',.5)
% plot(gt2x,gt2y,'Color', '#A2142F','LineWidth',.5)
% plot(gt3x,gt3y,'Color', '#A2142F','LineWidth',.5)
rectangle('Position', [ax(1),ax(3), ax(2)-ax(1), ax(4)-ax(3)],...
    'LineWidth',2,'EdgeColor','y')
rectangle('Position', [ax_fig2(1),ax_fig2(3), ax_fig2(2)-ax_fig2(1), ax_fig2(4)-ax_fig2(3)],...
    'LineWidth',2,'EdgeColor','#fc9f1c')
rectangle('Position', [ax_fig3(1),ax_fig3(3), ax_fig3(2)-ax_fig3(1), ax_fig3(4)-ax_fig3(3)],...
    'LineWidth',2,'EdgeColor','#ECFFDC')


%% Zoomed SWOT with IS2 lines
hs(2)=subplot(npanels,1,2);
hold on
pcolor(SWOT.xx,SWOT.yy,SWOT.wse);shading interp;
clim(swotlimc);colormap(cm2);
%subtitle('cycle 027 pass 328 140F date: 2025-01-25' ,'Interpreter','none')
plot_moa(.1,'k',SLAT,SLON,HEMI);
axis('equal'); axis(ax);
set(gca,'fontsize',14)
set(gca,'Xtick',-2100:25:-2000)
set(gca,'Ytick',1050:20:1110)

plot(gt1.x,gt1.y,'Color', '#A2142F','LineWidth',1)
plot(gt2.x,gt2.y,'Color', '#A2142F','LineWidth',1)
plot(gt3.x,gt3.y,'Color', '#A2142F','LineWidth',1)

loc=find(gt2.x>tr_lim(1) & gt2.x<tr_lim(2));
plot(gt2.x(loc),gt2.y(loc),'Color', '#A2142F','LineWidth',1)

plot(nx1,ny1,'y','LineWidth',3)
plot(nx2,ny2,'y','LineWidth',3)
plot(nx3,ny3,'y','LineWidth',3)

grid on; set(gca,'layer','top','GridAlpha',0.7)
xlabel('X coordinate (km)')
ylabel('Y coordinate (km)')
box('on')
text(-2059,1108,'{\bf (b)}','FontSize',1.1*fs,...
    'HorizontalAlignment','left','VerticalAlignment','middle')
text(-2011,1108,'25 January 2025','FontSize',1.1*fs,...
    'HorizontalAlignment','right','VerticalAlignment','middle')
% Arrow for SWOT direction
hold on
hq=quiver(-2054,1100,20,3,0);
%hq=quiver(-2040,1100,20,3,0);
or='#FFBF00'; or='#FFFF00'; or='k';
set(hq,'Color',or,'LineWidth',2,'MarkerSize',10,'MaxHeadSize',0.2);
ht_swot=text(-2055,1102,'SWOT pass','FontWeight','bold',...
    'Color',or,'FontSize',fs,'Rotation',10);

%% plot SWOT and IS2 for a beam
hs(3)=subplot(npanels,1,3);

plot(gt2.x,h_Swot_gt2_corr,'.','Color', '#0072BD','MarkerSize',6)
hold on
plot(gt2.x,gt2.atl06_Hcor,'.','Color', '#A2142F','MarkerSize',3)
xlim(tr_lim);
ylim([-1 35]);

% Legend
[~,hleg1]=legend('{\it WSE_{corr}}','{\it h_{IS2,corr}}','FontSize',0.9*fs,'Position',[0.7984596555014,0.852857142857143,0.098181816637516,0.081941124726054]);
objhl = findobj(hleg1, 'type', 'line');
set(objhl, 'Markersize', 12);

grid on; set(gca,'layer','top','GridAlpha',0.5)
set(gca,'Xtick',[tr_lim(1):10:tr_lim(2)])
set(gca,'Ytick',[0:10:45])

ht(3)=title('SWOT HR {\it WSE_{corr}} & ICESat-2 {\it h_{IS2,corr}} , middle beam');
ylabel('Corrected height (m)')
xlimits=xlim(gca); ylimits=ylim(gca);
xt=xlimits(1)+0.0*diff(xlimits);
yt=ylimits(2)-0.05*diff(ylimits);
text(-2058,yt,'{\bf (c)}','FontSize',1.1*fs, ...
    'HorizontalAlignment','center','VerticalAlignment','middle')



%% Plot dh between SWOT and ICESat-2
hs(4)=subplot(npanels,1,4);
plot([-2060 -2000],[0 0],'Color','k','LineWidth',1.5)
hold on
plot(gt2.x,dh_gt2,'.','Color', 'k','LineWidth',0.5)

loc=find(gt2.x>=lowlim2 & gt2.x<=uplim2);
plot(gt2.x(loc),dh_gt2(loc),'.','Color', 'r','LineWidth',0.5)

xlim(tr_lim);
ylim([-1.5 +1.5]);

grid on; set(gca,'layer','top','GridAlpha',0.5)
xlabel('X coordinate (km)')
ylabel('{\it {\Delta}h_{corr}} (m)')
ht(4)=title('{\it {\Delta}h_{corr}} (m): SWOT HR {\it WSE_{corr}} - ICESat-2 {\it h_{IS2,corr}} , middle beam');
set(gca,'Xtick',[tr_lim(1):10:tr_lim(2)])
xlimits=xlim(gca); ylimits=ylim(gca);
xt=xlimits(1)+0.03*diff(xlimits);
yt=ylimits(2)-0.07*diff(ylimits);
text(-2058,1.25,'{\bf (d)}','FontSize',1.1*fs, ...
    'HorizontalAlignment','center','VerticalAlignment','middle')

%% Plot histogram of differences, based on 3 strong beams
hs(5)=subplot(npanels,1,5);
histogram(Alldh,'BinWidth',.05,'BinLimits',[-1, 1])
hold on
plot([0 0],[0 950],'--r','LineWidth',1.5)
xticks(-1:.5:1)
yticks(0:100:950)
ylim([0 900])
grid on; set(gca,'GridAlpha',0.5)
xlabel('{\Delta}h (m)')
ylabel('Counts')
ht(5)=title('{\it {\Delta}h_{corr}} (m): {\it WSE_{corr}} - {\it h_{IS2,corr}}');
xlimits=xlim(gca); ylimits=ylim(gca);
xt=xlimits(1)+0.03*diff(xlimits);
yt=ylimits(2)-0.07*diff(ylimits);
text(-1,660,'{\bf (e)}','FontSize',1.1*fs, ...
    'HorizontalAlignment','left','VerticalAlignment','middle')
% hr=rectangle('Position',[0.10 390 0.95 220],'FaceColor','w');
% text(0.12,550,'mean: -0.17 m','FontSize',fs)
% text(0.12,450,'std:       0.18 m','FontSize',fs)

% calculate values for yellow sections:

mean_dh_val=mean(Alldh)
StDev_val=std(Alldh)
annotation(gcf,'textbox',...
    [0.718922077922077 0.21 0.105623376623378 0.0669841269841268],...
    'String',{['mean:  ' num2str(mean_dh_val,'%5.2f') ' m'],['std:       ' num2str(StDev_val,'%5.2f') ' m']},...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1], 'FontSize',0.9*fs);


%% Clean up
for i=1:5
    set(hs(i),'FontSize',fs)
end
for i=3:5
    ht(i).FontSize=11;
end


% 
% Revised to increase size of large-scale map
set(hs(1),'Position',[0.075 0.55 0.37 0.45],...
    'XTick',-2400:200:-2000,'YTick',1000:200:1200)
set(hs(2),'Position',[0.08 0.10 0.32 0.40],...)
    'XTick',-2060:20:-2020,'YTick',1060:20:1100)
set(hs(3),'Position',[0.52 0.72 0.38 0.22],'XTickLabel',[])
set(hs(4),'Position',[0.52 0.44 0.38 0.20],'YTick',-1:0.5:1)
set(hs(5),'Position',[0.59 0.10 0.24 0.20],'ylim',[0 750],'YTick',0:200:1000)

set(hc(1),'Position',[0.39 0.15 0.01 0.35],'FontSize',fs)


hc(1).Label.String='SWOT {\it WSE} (m)';


print Figure1_FINAL_450dpi.png -f10 -dpng -r450
