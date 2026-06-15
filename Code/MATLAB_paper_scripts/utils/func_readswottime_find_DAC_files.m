function [swot_time,fnameDAC1,fnameDAC2,DAC_time1_jd,DAC_time2_jd]=func_readswottime_find_DAC_files(fname)

  %Use file name to extract date & times from SWOT tile
  %find DAC filenames on either side of swot time, based on swot time
 
  % Use file name to extract date & times from SWOT tile
  % tile start time
    tileyr=str2double(fname(52:55));
    tilemm=str2double(fname(56:57));
    tiledy=str2double(fname(58:59));
    tilehr=str2double(fname(61:62));
    tilemin=str2double(fname(63:64));
    tilesec=str2double(fname(65:66)); % add 9 sec for ~about mid point of tile % 0.5*(fname(81:82) -   
    timeST=datetime(tileyr, tilemm, tiledy,tilehr,tilemin,tilesec);
  % tile end time
    tileyrE=str2double(fname(68:71));
    tilemmE=str2double(fname(72:73));
    tiledyE=str2double(fname(74:75));
    tilehrE=str2double(fname(77:78));
    tileminE=str2double(fname(79:80));
    tilesecE=str2double(fname(81:82));

    timeE=datetime(tileyrE, tilemmE, tiledyE,tilehrE,tileminE,tilesecE);


    dt=seconds(diff([timeST;timeE]))/2.0 ;  


    tilesec_mid=tilesec +dt;

    %% get datetime of mid point

   swot_time.tileyr=tileyr;
   swot_time.tilemm=tilemm;
   swot_time.tiledy=tiledy;
   swot_time.tilehr=tilehr;
   swot_time.tilemin=tilemin;
   swot_time.tilesec=tilesec_mid;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  determine filenames for Aviso Dac product based on swot date
    %   see Julian date conversion for CNES files
    %   https://www.aviso.altimetry.fr/en/data/tools/calendar-days-or-julian-days/convert-calendar-days-in-cnes-or-nasa-julian-days.html
    %   https://en.wikipediforg/wiki/Julian_day
    %   
     
    DACtime1=juliandate(datetime(tileyr,tilemm,tiledy)) - 2433282.5;  %using CNES julian day
    DACtime2=juliandate(datetime(tileyr,tilemm,tiledy)) - 2433282.5;  %using CNES julian day
    disp(DACtime1)
    tmfordac=tilehr + ((tilemin + (tilesec_mid/60.0))/60.0);
    
    disp(tmfordac)
  
    h=[0 6 12 18 24];   % 6 hrly times steps of DAC files.  24 is added to have the option of switching to next day.


 % find 2 nearest 6 hourly time steps
    vals=abs(h-tmfordac);
    B = mink(vals,2);   %smallest 2 values 
    
   idx1=find(vals==B(1));
   idx2=find(vals==B(2));
    % get location in h array
    
     dachr1=h(idx1);
     dachr2=h(idx2);
   

    if dachr1==24       % if close to 24 hr, switch to next day
        dachrstr1='00';
        dacdyadd1=1;   
    else
        dachrstr1=pad(num2str(dachr1),2,'left','0');
        dacdyadd1=0;
    end

    if dachr2==24       % if close to 24 hr, switch to next day
        dachrstr2='00';
        dacdyadd2=1;   
    else
        dachrstr2=pad(num2str(dachr2),2,'left','0');
        dacdyadd2=0;
    end

    %dactime for filenames - need to add a day to move to new day when hr
    %=24
    DACtime1fn=DACtime1+dacdyadd1;
    DACtime2fn=DACtime2+dacdyadd2;

    % creat name of the dac file to match the IS2 rgt
    fnameDAC1=['dac_dif_' num2str(DACtime1fn) '_' dachrstr1 '.nc'];
    fnameDAC2=['dac_dif_' num2str(DACtime2fn) '_' dachrstr2 '.nc'];

    %dactime in julian days 

    DAC_time1_jd=DACtime1 + dachr1/24  + 2433282.5; %as julian
    DAC_time2_jd=DACtime2 + dachr2/24  + 2433282.5;  %as julian date