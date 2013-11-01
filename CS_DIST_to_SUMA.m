var = CS_DIST_MY_G_20;
a1 = var;
a1 = num2cell(a1);
a1 = sortcell(a1,[1]);
a2 = cell2mat(a1);
a3 = a2(1:2:end);
c1 = .5*length(a3);
CS_DIST_MY_G_use = reshape(a3,[c1 2]);
clear var a1 a2 a2 c1

var = CS_DIST_MY_L_20;
a1 = var;
a1 = num2cell(a1);
a1 = sortcell(a1,[1]);
a2 = cell2mat(a1);
a3 = a2(1:2:end);
c1 = .5*length(a3);
CS_DIST_MY_L_use = reshape(a3,[c1 2]);
clear var a1 a2 a3 c1

suma_MY = vertcat(CS_DIST_MY_G_use,CS_DIST_MY_L_use);
