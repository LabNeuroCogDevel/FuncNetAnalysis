% Created by: Scott Marek
% Last modified: 9/30/2013

%	Used to:
%       1. Make a matrix of coordinate comparisons
%		2. Calculate Euclidean distance
%		3. Compare connection stregnth vs distance for 3 age groups in adolescence
%		4. Indices remove correlation values < -0.1 and > 0.1. 
%       5. Indices remove connections < 20mm apart.
%		6. Create variables to write out to csv files for SUMA.

n = 240;
i=1;
for k = 1:n,
    for j = 1:n
    coords(i,:) =[coords_240(k,:),coords_240(j,:)];
   i=i+1;
    end 
end


for k = 1:n,
    for j = 1:n
    dist(j,k) = pdist2(coords_240(k,:),coords_240(j,:));
    end 
end

dist_r = reshape(dist,[n^2 1]);

young = Y(:,:,1:5);
mid = Y(:,:,40:44);
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

suma_YO_all = horzcat(dist_r,CS_yo);
suma_MY_all = horzcat(dist_r,CS_my);
suma_MO_all = horzcat(dist_r,CS_mo);

suma_YO_all = horzcat(coords,suma_YO_all);
suma_MY_all = horzcat(coords,suma_MY_all);
suma_MO_all = horzcat(coords,suma_MO_all);

% Index to fund corr values <-.1 or >.1, 
indices_g_mo = find(suma_MO_all(:,8)>.1);
indices_l_mo = find(suma_MO_all(:,8)<-.1);


suma_MO_all_G = suma_MO_all(indices_g_mo,:);
suma_MO_all_L = suma_MO_all(indices_l_mo,:);

indices_dist = find(suma_MO_all_G(:,7)>20);
suma_MO_all_G_20 = suma_MO_all_G(indices_dist,:);

indices_dist = find(suma_MO_all_L(:,7)>20);
suma_MO_all_L_20 = suma_MO_all_L(indices_dist,:);


suma_MO_output = vertcat(suma_MO_all_G_20,suma_MO_all_L_20);

% Index to fund corr values <-.1 or >.1, 
indices_g_yo = find(suma_YO_all(:,8)>.1);
indices_l_yo = find(suma_YO_all(:,8)<-.1);

suma_YO_all_G = suma_YO_all(indices_g_yo,:);
suma_YO_all_L = suma_YO_all(indices_l_yo,:);

indices_dist = find(suma_YO_all_G(:,7)>20);
suma_YO_all_G_20 = suma_YO_all_G(indices_dist,:);

indices_dist = find(suma_YO_all_L(:,7)>20);
suma_YO_all_L_20 = suma_YO_all_L(indices_dist,:);

suma_YO_output = vertcat(suma_YO_all_G_20,suma_YO_all_L_20);


% Index to fund corr values <-.1 or >.1, 

indices_g_my = find(suma_MY_all(:,8)>.1);
indices_l_my = find(suma_MY_all(:,8)<-.1);

suma_MY_all_G = suma_MY_all(indices_g_my,:);
suma_MY_all_L = suma_MY_all(indices_l_my,:);

indices_dist = find(suma_MY_all_G(:,7)>20);
suma_MY_all_G_20 = suma_MY_all_G(indices_dist,:);

indices_dist = find(suma_MY_all_L(:,7)>20);
suma_MY_all_L_20 = suma_MY_all_L(indices_dist,:);

suma_MY_output = vertcat(suma_MY_all_G_20,suma_MY_all_L_20);

xlswrite('suma_YO_edge',suma_YO_output);
xlswrite('suma_MY_edge',suma_MY_output);
xlswrite('suma_MO_edge',suma_MO_output);
