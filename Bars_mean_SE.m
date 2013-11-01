% Script for making a cool bar graph.
% Written by: Scott Marek
% Last modified: 8/19/2013

%   WHAT THIS DOES:
%   1. Bars displaying mean for each group.
%   2. SEM for each group
%   3. Adding observed data points to graph
%   4. Running a test between groups
%   5. Displaying results of ttest
%   6. Adding comparison bar and stars for significance




%Define a structure called "data" containing your variables.
% This example has data as structure containing 3 variables (fields).

a = young_CC(20,:)
b = mid_CC(20,:)
c = old_CC(20,:)

data.young_CC = a;
data.mid_CC = b;
data.old_CC = c;

% Now loop through the fields of the structure and calculate the mean 
% of each then plot these. 

f = fields(data); %makes a cell array of strings containing field names

% Anywhere in the script where you see 'mu_....', change '...' to your 
% variable and SAVE AS something else!!!!


for ii=1:length(f)
    mu(ii)=mean( data.(f{ii}) ); 
    sem(ii)=std( data.(f{ii}) )/sqrt(length(( data.(f{ii}) ))); 
end

% Plot all this in a pretty way (Change color with numbers in brackets).
% Change 'ylabel' to your own label
H=bar(mu); 
set(H,'FaceColor',[1,1,1]*0.5,'LineWidth',2)
set(gca,'XTickLabel',f)
ylabel('Clustering Coefficient') 

hold on
for ii=1:length(f)
  plot([ii,ii],[mu(ii)-sem(ii),mu(ii)+sem(ii)],'-k','LineWidth',4)
end
hold off

% Comment this all out below 'if' you do not want your actual data overlaid
% on your bar graphs!!!

hold on
for ii=1:length(f)
    tmp=data.(f{ii}); % temporarily store data in variable "tmp"
    x = repmat(ii,1,length(tmp)); % the x axis location
    x = x+(rand(size(x))-0.5)*0.1; % add a little random jitter to aid visibility

    plot(x,tmp,'.k') % This displays your data in black ('.k')
end
hold off


% Un-paired t-test (needs stats toolbox)
% Add your variables in for ttest2(x,y)!
[H,P,CI,STATS]=ttest2(a,c);

hold on

% Now add the t-test result as text.
% You will need to play with the numbers for your own personal alignment!!!
str=sprintf('t(%d)=%0.2f, p<0.001',STATS.df,STATS.tstat);
ylim([0,2.99])
text(3.05,2.65,str,'FontWeight','bold')

% Finally, manually add the line and the star(s). 
% You will need to play with the numbers for your own personal alignment!!!
hold on
p=plot([1,1,3,3],[2.6,2.73,2.73,2.6],'-k','LineWidth',2)
hold off



% Un-paired t-test (needs stats toolbox)
% Add your variables in for ttest2(x,y)!
[H,P,CI,STATS]=ttest2(b,c);

hold on

% Now add the t-test result as text.
% You will need to play with the numbers for your own personal alignment!!!
str=sprintf('t(%d)=%0.2f, p<0.001',STATS.df,STATS.tstat);
ylim([0,2.99])
text(3.05,2.3,str,'FontWeight','bold')

% Finally, manually add the line and the star(s). 
% You will need to play with the numbers for your own personal alignment!!!
hold on
p=plot([2.1,2.1,3,3],[2.2,2.4,2.4,2.2],'-k','LineWidth',2)
hold off
text(2.5,2.46,'***','backgroundcolor','w','horizontalalignment','center')



% Un-paired t-test (needs stats toolbox)
% Add your variables in for ttest2(x,y)!
[H,P,CI,STATS]=ttest2(a,b);

hold on

% Now add the t-test result as text.
% You will need to play with the numbers for your own personal alignment!!!
str=sprintf('t(%d)=%0.2f, p<0.001',STATS.df,STATS.tstat);
ylim([0,2.99])
text(.55,2.3,str,'FontWeight','bold')

% Finally, manually add the line and the star(s). 
% You will need to play with the numbers for your own personal alignment!!!
hold on
p=plot([1,1,1.9,1.9],[2.2,2.4,2.4,2.2],'-k','LineWidth',2)
hold off
text(1.5,2.46,'***','backgroundcolor','w','horizontalalignment','center')



