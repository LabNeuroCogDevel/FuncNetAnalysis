%Created by: Scott Marek
%Last updated: 8/20/2013

% Called in matlab file: /Documents/MATLAB/Scott_Network_analysis_redo/Matlab_nets/Connectivitychange_dist.mat

%Used for making scatter plots of connectivity change as a function of distance 
% 6 Networks; 3 groups. 

% Get rid of '%' in lines below to generate Euclidean distance from a variable
% containing a column of x coordinates, a column of y coordinates, and a column of z coordinates.

%for k = 1:82,
%    for j = 1:82
%		dist(j,k) = pdist2(matlab_coords(k,:),matlab_coords(j,:));
% end 
%end

DA_dist = dist(1:12,1:12);
DA_dist_r = reshape(DA_dist,[144 1]);

DA_mean_young = mean_young(1:12,1:12);
DA_mean_mid = mean_mid(1:12,1:12);
DA_mean_old = mean_old(1:12,1:12);


DA_YOUNG = reshape(DA_mean_young,[144 1]);
DA_MID = reshape(DA_mean_mid,[144 1]);
DA_OLD = reshape(DA_mean_old,[144 1]);

DA_CS_yo = DA_OLD-DA_YOUNG;
DA_CS_my = DA_MID-DA_YOUNG;
DA_CS_mo = DA_OLD-DA_MID;

DA_CS_DIST_YO = horzcat(DA_dist_r,DA_CS_yo);
DA_CS_DIST_MY = horzcat(DA_dist_r,DA_CS_my);
DA_CS_DIST_MO = horzcat(DA_dist_r,DA_CS_mo);

VA_dist = dist(13:24,13:24);
VA_dist_r = reshape(VA_dist,[144 1]);

VA_mean_young = mean_young(13:24,13:24);
VA_mean_mid = mean_mid(13:24,13:24);
VA_mean_old = mean_old(13:24,13:24);


VA_YOUNG = reshape(VA_mean_young,[144 1]);
VA_MID = reshape(VA_mean_mid,[144 1]);
VA_OLD = reshape(VA_mean_old,[144 1]);

VA_CS_yo = VA_OLD-VA_YOUNG;
VA_CS_my = VA_MID-VA_YOUNG;
VA_CS_mo = VA_OLD-VA_MID;

VA_CS_DIST_YO = horzcat(VA_dist_r,VA_CS_yo);
VA_CS_DIST_MY = horzcat(VA_dist_r,VA_CS_my);
VA_CS_DIST_MO = horzcat(VA_dist_r,VA_CS_mo);

FP_dist = dist(25:36,25:36);
FP_dist_r = reshape(FP_dist,[144 1]);

FP_mean_young = mean_young(25:36,25:36);
FP_mean_mid = mean_mid(25:36,25:36);
FP_mean_old = mean_old(25:36,25:36);


FP_YOUNG = reshape(FP_mean_young,[144 1]);
FP_MID = reshape(FP_mean_mid,[144 1]);
FP_OLD = reshape(FP_mean_old,[144 1]);

FP_CS_yo = FP_OLD-FP_YOUNG;
FP_CS_my = FP_MID-FP_YOUNG;
FP_CS_mo = FP_OLD-FP_MID;

FP_CS_DIST_YO = horzcat(FP_dist_r,FP_CS_yo);
FP_CS_DIST_MY = horzcat(FP_dist_r,FP_CS_my);
FP_CS_DIST_MO = horzcat(FP_dist_r,FP_CS_mo);

DMN_dist = dist(37:48,37:48);
DMN_dist_r = reshape(FP_dist,[144 1]);

DMN_mean_young = mean_young(37:48,37:48);
DMN_mean_mid = mean_mid(37:48,37:48);
DMN_mean_old = mean_old(37:48,37:48);


DMN_YOUNG = reshape(DMN_mean_young,[144 1]);
DMN_MID = reshape(DMN_mean_mid,[144 1]);
DMN_OLD = reshape(DMN_mean_old,[144 1]);

DMN_CS_yo = DMN_OLD-DMN_YOUNG;
DMN_CS_my = DMN_MID-DMN_YOUNG;
DMN_CS_mo = DMN_OLD-DMN_MID;

DMN_CS_DIST_YO = horzcat(DMN_dist_r,DMN_CS_yo);
DMN_CS_DIST_MY = horzcat(DMN_dist_r,DMN_CS_my);
DMN_CS_DIST_MO = horzcat(DMN_dist_r,DMN_CS_mo);

Striat_dist = dist([49:50,71:82],[49:50,71:82]);
Striat_dist_r = reshape(Striat_dist,[196 1]);

Striat_mean_young = mean_young([49:50,71:82],[49:50,71:82]);
Striat_mean_mid = mean_mid([49:50,71:82],[49:50,71:82]);
Striat_mean_old = mean_old([49:50,71:82],[49:50,71:82]);


Striat_YOUNG = reshape(Striat_mean_young,[196 1]);
Striat_MID = reshape(Striat_mean_mid,[196 1]);
Striat_OLD = reshape(Striat_mean_old,[196 1]);

Striat_CS_yo = Striat_OLD-Striat_YOUNG;
Striat_CS_my = Striat_MID-Striat_YOUNG;
Striat_CS_mo = Striat_OLD-Striat_MID;

Striat_CS_DIST_YO = horzcat(Striat_dist_r,Striat_CS_yo);
Striat_CS_DIST_MY = horzcat(Striat_dist_r,Striat_CS_my);
Striat_CS_DIST_MO = horzcat(Striat_dist_r,Striat_CS_mo);

CEREB_dist = dist(51:70,51:70);
CEREB_dist_r = reshape(CEREB_dist,[400 1]);

CEREB_mean_young = mean_young(51:70,51:70);
CEREB_mean_mid = mean_mid(51:70,51:70);
CEREB_mean_old = mean_old(51:70,51:70);


CEREB_YOUNG = reshape(CEREB_mean_young,[400 1]);
CEREB_MID = reshape(CEREB_mean_mid,[400 1]);
CEREB_OLD = reshape(CEREB_mean_old,[400 1]);

CEREB_CS_yo = CEREB_OLD-CEREB_YOUNG;
CEREB_CS_my = CEREB_MID-CEREB_YOUNG;
CEREB_CS_mo = CEREB_OLD-CEREB_MID;

CEREB_CS_DIST_YO = horzcat(CEREB_dist_r,CEREB_CS_yo);
CEREB_CS_DIST_MY = horzcat(CEREB_dist_r,CEREB_CS_my);
CEREB_CS_DIST_MO = horzcat(CEREB_dist_r,CEREB_CS_mo);

% Change variable (ex:'MY') to variable being used. 
scatter(DA_CS_DIST_MY(:,1),DA_CS_DIST_MY(:,2))
hold on
scatter(VA_CS_DIST_MY(:,1),VA_CS_DIST_MY(:,2))
scatter(FP_CS_DIST_MY(:,1),FP_CS_DIST_MY(:,2))
scatter(DMN_CS_DIST_MY(:,1),DMN_CS_DIST_MY(:,2))
scatter(Striat_CS_DIST_MY(:,1),Striat_CS_DIST_MY(:,2))
scatter(CEREB_CS_DIST_MY(:,1),CEREB_CS_DIST_MY(:,2))