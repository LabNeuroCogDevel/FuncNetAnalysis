Y_O = Y(:,:,80:84)-Y(:,:,7:11);
Y_O = mean(Y_O,3);
M_O = Y(:,:,80:84)-Y(:,:,40:44);
M_O = mean(M_O,3);
M_Y = Y(:,:,40:44)-Y(:,:,1:5);
M_Y = mean(M_Y,3);

CS_my = reshape(M_Y,[57600 1]);

CS_my= horzcat(dist_r,CS_my);
var = CS_my;
a1 = var;
a1 = num2cell(a1);
a1 = sortcell(a1,[1]);
a2 = cell2mat(a1);
a3 = a2(1:2:end,:);
connections = a3(:,2);
connections = connections(121:28680);
zc_my = zscore(connections);
zc1 = num2cell(zc_my);
zc1 = sortcell(zc1);
zc_my = cell2mat(zc1);

% ------------------------------------------------------------

M_Y_sorted = sort(CS_my(:,2));
M_Y_copy = M_Y;
M_Y_copy(intersect(find(M_Y_copy>-.2320),find(M_Y_copy<.1990)))=0;


xlswrite('MY_brainnet',M_Y_copy);
xlswrite('OM_brainnet',M_O_copy);
xlswrite('YO_brainnet',Y_O_copy);
