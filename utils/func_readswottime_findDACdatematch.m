function [swot_time,fnameDAC]=func_readswottime_findDACdatematch(fname)

  %Use file name to extract date & times from SWOT tile
  %find DAC filename based on these times
 
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
    %   see
    %   https://www.aviso.altimetry.fr/en/data/tools/calendar-days-or-julian-days/convert-calendar-days-in-cnes-or-nasa-julian-days.html
    %   https://en.wikipediforg/wiki/Julian_day
    %   
    DACtime=juliandate(datetime(tileyr,tilemm,tiledy)) - 2433282.5;  %using CNES julian day

    tmfordac=tilehr + ((tilemin + (tilesec_mid/60.0))/60.0);
    
    h=[0 6 12 18 24];   % 6 hrly times steps of DAC files.  24 is added to have the option of switching to next day.


 % find closest 6 hourly time stamp
    vals=abs(h-tmfordac);
    minv=min(vals);   %(find the smallest difference)
    idx=find(vals==minv);   % get location in h array
    if length(idx)~=1
      dachr=h(idx(1));
    else
      dachr=h(idx);
    end

    if dachr==24       % if close to 24 hr, switch to next day
        dachrstr='00';
        dacdyadd=1;   
    else
        dachrstr=pad(num2str(dachr),2,'left','0');
        dacdyadd=0;
    end
    DACtime=DACtime+dacdyadd;

    % creat name of the dac file to match the IS2 rgt
    fnameDAC=['dac_dif_' num2str(DACtime) '_' dachrstr '.nc'];









