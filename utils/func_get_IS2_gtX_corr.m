function  [gtX]=func_get_IS2_gtX_corr(dir06,fn06, Model, SLAT, SLON, HEMI, gtnum )

%% Extract IS2 data from 3 strong beams and correct for tides and DAC
%%  ICESat2 ATL06 granule
%%  Set projection parameters
%%  set tide model (use CATS2008)
%%  save file with IS2 data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%


%% Read in ICESat-2 data for a beam and correct
%%  h_li_2- (geoid_h_2 + geoid_f2m_2)  + tide_earth_f2m_2 - ot_z'  -dac_2
%%  ot_z is ocean tide from cats2008

src06=[dir06 fn06];

rgt= fn06(22:25);
cycIS2=fn06(26:27);
gtname=['gt1l'; 'gt1r';'gt2l'; 'gt2r'; 'gt3l'; 'gt3r'];

ref_time_dt =datetime(2018,01,01); % reference time for all ground track profiles


j=gtnum;

disp([' retrieving ' gtname(j,:)])

try
    %get atl06
        lat6 = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/latitude']);
        lon6 = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/longitude']);
        h_li = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/h_li']);
        quality_summary_flag = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/atl06_quality_summary']);
        delta_time6 = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/delta_time']);
        geoid_h = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/dem/geoid_h']);
        geoid_f2m = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/dem/geoid_free2mean']);
        tide_ocean = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_ocean']);
        %tide_eq = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_equilibrium']);
        %tide_pole = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_pole']);
        %tide_earth = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_earth']);
        tide_earth_f2m = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_earth_free2mean']);
        %tide_load= h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/tide_load']);
        dac = h5read(src06, ['/' gtname(j,:) '/land_ice_segments/geophysical/dac']);
        
        time_dt= ref_time_dt + seconds(delta_time6 );

   %convert to PS
        [x6,y6] = mapll(lat6,lon6,SLAT,SLON,HEMI);
        
        %get rid of bad points
        nan_idx = h_li > 3.e+38;
        h_li(nan_idx) = NaN;
        clear nan_idx;
    
        bad_quality_inDS06 = quality_summary_flag == 1; 
        % parameter value of 1 indicates some potential data-quality problem
        h_li(bad_quality_inDS06) = NaN;
        clear bad_quality_inDS06;
    
  %cats tides
     
        [ot_z]=tmd_predict(Model,lat6,lon6,time_dt,'h');

    % apply geophysical corrections
    %  IS2_corr= h_li - (geoid + geoid_free2mean) + earth_tide _free2mean - ocean_tides  - DAC 
     gtX.atl06_Hcor=h_li-(geoid_h + geoid_f2m)  + tide_earth_f2m - ot_z -dac ;
     gtX.x=x6;
     gtX.y=y6;
     gtX.lon=lon6;
     gtX.lat=lat6;
     gtX.gtnum=gtnum;
     gtX.gtname=gtname(j,:);
     gtX.rgt=rgt;
     gtX.cycle=cycIS2;
catch
    disp('no groundtrack data')
end

return


