h_kden = figure;

t2 = [11.0:.1:19.3];


sub_one = subplot(2,2,1);
p1 = polyfit(group_age,Master(1,25).kden,3);
y1=polyval(p1,t2);
plot(group_age,Master(1,25).kden,'o',t2,y1)
   
sub_two = subplot(2,2,2);
p2 = polyfit(group_age,Master(1,30).kden,3);
y2=polyval(p2,t2);
plot(group_age,Master(1,30).kden,'o',t2,y2)

sub_three = subplot(2,2,3);
p3 = polyfit(group_age,Master(1,35).kden,3);
y3=polyval(p3,t2);
plot(group_age,Master(1,35).kden,'o',t2,y3)

sub_four = subplot(2,2,4);
p4 = polyfit(group_age,Master(1,40).kden,3);
y4=polyval(p4,t2);
plot(group_age,Master(1,40).kden,'o',t2,y4)


title(subplot(2,2,1),'Threshold = .25','Fontsize',16,'Fontweight','bold')
title(subplot(2,2,2),'Threshold = .30','Fontsize',16,'Fontweight','bold')
title(subplot(2,2,3),'Threshold = .35','Fontsize',16,'Fontweight','bold')
title(subplot(2,2,4),'Threshold = .40','Fontsize',16,'Fontweight','bold')

for i = 1:4,
    xlabel(subplot(2,2,i),'Age Group','Fontsize',16,'Fontweight','bold')
    xlim([11 19.75]);
end

for i = 1:4,
    ylabel(subplot(2,2,i),'Network Density','Fontsize',16,'Fontweight','bold')
end

set(gcf,'color',[1 1 1]);

