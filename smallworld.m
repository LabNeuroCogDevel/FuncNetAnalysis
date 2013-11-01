normCC_04 = Master(1,04).meanC./MasterR_ed_04.meanC;
normPL_04 = Master(1,04).lambda./MasterR_ed_04.lambda;
sw_04 = normCC_04./normPL_04;

normCC_06 = Master(1,06).meanC./MasterR_ed_06.meanC;
normPL_06 = Master(1,06).lambda./MasterR_ed_06.lambda;
sw_06 = normCC_06./normPL_06;

normCC_08 = Master(1,08).meanC./MasterR_ed_08.meanC;
normPL_08 = Master(1,08).lambda./MasterR_ed_08.lambda;
sw_08 = normCC_06./normPL_06;

normCC_10 = Master(1,10).meanC./MasterR_ed_10.meanC;
normPL_06 = Master(1,10).lambda./MasterR_ed_10.lambda;
sw_10 = normCC_06./normPL_06;

h_sw = figure;

t2 = [11.0:.1:19.3];


sub_one = subplot(2,2,1);
p1 = polyfit(group_age,sw_04,1);
y1=polyval(p1,t2);
plot(group_age,sw_04,'o',t2,y1)
   
sub_two = subplot(2,2,2);
p2 = polyfit(group_age,sw_06,1);
y2=polyval(p2,t2);
plot(group_age,sw_06,'o',t2,y2)

sub_three = subplot(2,2,3);
p3 = polyfit(group_age,sw_08,1);
y3=polyval(p3,t2);
plot(group_age,sw_08,'o',t2,y3)

sub_four = subplot(2,2,4);
p4 = polyfit(group_age,sw_10,1);
y4=polyval(p4,t2);
plot(group_age,sw_10,'o',t2,y4)


title(subplot(2,2,1),'Density = .04','Fontsize',14)
title(subplot(2,2,2),'Density = .06','Fontsize',14)
title(subplot(2,2,3),'Density = .08','Fontsize',14)
title(subplot(2,2,4),'Density = .10','Fontsize',14)

for i = 1:4,
    xlabel(subplot(2,2,i),'Age Group','Fontsize',14)
    xlim([11 19.75]);
end

for i = 1:4,
    ylabel(subplot(2,2,i),'Small Worldness','Fontsize',14)
end

set(gcf,'color',[1 1 1]);