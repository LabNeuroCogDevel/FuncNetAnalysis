% Created by: Scott Marek
% Last modified: 9/26/2013

%	Used to:
%		1. Calculate Euclidean distance
%		2. Compare connection stregnth vs distance for 3 age groups in adolescence
%		3. Indices remove correlation values < -0.1 and > 0.1. 
%		4. Make scatter plots of group differences.

n = 240;

for k = 1:n,
    for j = 1:n
    dist(j,k) = pdist2(coords_240(k,:),coords_240(j,:));
    end 
end

dist_r = reshape(dist,[n^2 1]);

young = Y(:,:,7:11);
mid = Y(:,:,45:49);
old = Y(:,:,80:84);

mean_young = mean(young,3);
mean_mid = mean(mid,3);
mean_old = mean(old,3);

YOUNG = reshape(mean_young,[n^2 1]);
MID = reshape(mean_mid,[n^2 1]);
OLD = reshape(mean_old,[n^2 1]);

CS_yo = OLD-YOUNG;
CS_my = MID-YOUNG;
CS_mo = OLD-MID;

CS_DIST_YO = horzcat(dist_r,CS_yo);
CS_DIST_MY = horzcat(dist_r,CS_my);
CS_DIST_MO = horzcat(dist_r,CS_mo);

indices_g_mo = find(CS_DIST_MO(:,2)>.1);
indices_l_mo = find(CS_DIST_MO(:,2)<-.1);


CS_DIST_MO_G = CS_DIST_MO(indices_g_mo,:);
CS_DIST_MO_L = CS_DIST_MO(indices_l_mo,:);

indices_dist = find(CS_DIST_MO_G(:,1)>20);
CS_DIST_MO_G_20 = CS_DIST_MO_G(indices_dist,:);

indices_dist = find(CS_DIST_MO_L(:,1)>20);
CS_DIST_MO_L_20 = CS_DIST_MO_L(indices_dist,:);

h = figure
set(gcf,'color',[1 1 1])

subplot(2,1,2);
scatter(CS_DIST_MO_G_20(:,1),CS_DIST_MO_G_20(:,2))
hold on
scatter(CS_DIST_MO_L_20(:,1),CS_DIST_MO_L_20(:,2))

indices_g_yo = find(CS_DIST_YO(:,2)>.1);
indices_l_yo = find(CS_DIST_YO(:,2)<-.1);

CS_DIST_YO_G = CS_DIST_YO(indices_g_yo,:);
CS_DIST_YO_L = CS_DIST_YO(indices_l_yo,:);

indices_dist = find(CS_DIST_YO_G(:,1)>20);
CS_DIST_YO_G_20 = CS_DIST_YO_G(indices_dist,:);

indices_dist = find(CS_DIST_YO_L(:,1)>20);
CS_DIST_YO_L_20 = CS_DIST_YO_L(indices_dist,:);

%subplot(2,2,3);
%scatter(CS_DIST_YO_G_20(:,1),CS_DIST_YO_G_20(:,2))
%hold on
%scatter(CS_DIST_YO_L_20(:,1),CS_DIST_YO_L_20(:,2))

indices_g_my = find(CS_DIST_MY(:,2)>.1);
indices_l_my = find(CS_DIST_MY(:,2)<-.1);

CS_DIST_MY_G = CS_DIST_MY(indices_g_my,:);
CS_DIST_MY_L = CS_DIST_MY(indices_l_my,:);

indices_dist = find(CS_DIST_MY_G(:,1)>20);
CS_DIST_MY_G_20 = CS_DIST_MY_G(indices_dist,:);

indices_dist = find(CS_DIST_MY_L(:,1)>20);
CS_DIST_MY_L_20 = CS_DIST_MY_L(indices_dist,:);

subplot(2,1,1)
scatter(CS_DIST_MY_G_20(:,1),CS_DIST_MY_G_20(:,2))
hold on
scatter(CS_DIST_MY_L_20(:,1),CS_DIST_MY_L_20(:,2))

title(subplot(2,1,1),'Strength Change: Middle - Young','Fontsize',14)
title(subplot(2,1,2),'Strength Change: Old - Middle','Fontsize',14)
% title(subplot(2,2,3),'Strength Change: Old - Young','Fontsize',14)

for i = 1:2,
    xlabel(subplot(2,1,i),'Euclidean Distance','Fontsize',14)
    xlim([0 180]);
end

for i = 1:2,
    ylabel(subplot(2,1,i),'Correlation Strength Change','Fontsize',14)
end