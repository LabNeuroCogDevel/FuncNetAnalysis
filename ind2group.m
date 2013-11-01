function [files,a,b,sortedb,y] = ind2group(n,w,path) 
% Script's functions include:
%   1. Importing individual timeseries of each region
%      into Matlab. Should be in the format of 
%      # of ROIs x length of timeseries
%   2. Correlate every ROI with every other ROI
%      for each subject.
%   3. Sort matrices by age if needed.
%   4. Generate average group correlation matrices
%      using a sliding boxcar of n subjects. 
%   Output  y: n x n x g matrix, where n = # of ROIs
%              and g = # of groups. 

% Written by: Scott Marek
% Last updated: 11/1/2013

%Import individual subject files. 
files = dir(path);
    for i = 3:(n+2)(files),
        a{i-2} = dlmread([path '/' files(i).name,'\t',3,2]);
    end
    
    
% Now all of your individual subject files are in Matlab.
% Next step is to correlate each subject's timeseries for
% each ROI.

for i = 1:n,
    b{i} = corrcoef(a{i});
end


% Now that all your matrices are imported and have been
% correlated, you need to sort them.
% If sorting ascendingly by age, use Matlab function
% sortcell. 
% If you don't have sortcell this will error out, so get it! 
% Ex call:
% var = sortcell(b,[2]); 2 refers to column of the variable.



% Average group correlation matrices using a sliding boxcar.
% If you're not interested in using a sliding boxcar,
% comment out what is below. 

for r1=1:n
    for r2=1:n
        for i=0:(length(b)-w)
        y(r1,r2,i+1) = mean ( cellfun(@(x)(x(r1,r2)),b((i+1):(w+i)) ));
        end
    end
end

% Output variable containing all averaged correlation 
% matrices is 'y'. 

% Use variable, y, for generating network metrics.
% Script for network metrics: Network_Calculations_script.m


end

