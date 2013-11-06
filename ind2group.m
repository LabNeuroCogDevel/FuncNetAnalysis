function [files,a,b,c,d,y] = ind2group(n,w,path,age,nodes) 

% Written by: Scott Marek
% Last updated: 11/6/2013


% What this does:
%   1. Imports individual timeseries of each region
%      into Matlab. Should be in the format of 
%      # of ROIs x TRs
%   2. Correlate every ROI with every other ROI
%      for each subject.
%   3. Sort matrices by age if needed.
%   4. Generate average group correlation matrices
%      using a sliding boxcar of n subjects. 

%------------------------------------------------------------------------------------------
  
%   Output:	files = individual subject files 
%			a = 1xn cell containing individual timeseries x ROI for each subject
%			b = nx1 cell containing individual correlation matrices
%			c = cell containing vector of individual correlation matrices and 
%				age sorted ascendingly 
%			d = Vector of age-sorted individual correlation matrices
%			y = n x n x g matrix of group averaged correlation matrices, 
%				where n = # of ROIs and g = # of groups.
%              
%
%	Input:  n = number of subjects
%			w = group size (sliding boxcar size)
%			path = string containing the path to your individual subject files 
%			age = column containing ages of subject 
%					*** Be sure this vector lines up with the order of the files you
%						are importing ***
%			nodes = number of nodes (regions of interest)

%------------------------------------------------------------------------------------------

%Import individual subject files. 
files = dir(path);
    for i = 4:(n+3)(files),
        a{i-3} = dlmread([path '/' files(i).name],'\t',3,2);
    end
    
    
% Now all of your individual subject files are in Matlab.
% Next step is to correlate each subject timeseries for
% each ROI.

for i = 1:n,
    b{i} = corrcoef(a{i});
end

b=b';

age=num2cell(age);

c = [b,age];

% Now that all your matrices are imported and have been
% correlated, you need to sort them.
% If sorting ascendingly by age, use Matlab function
% sortcell. 
% If you don't have sortcell this will error out, so get it! 
% Ex call:
% var = sortcell(b,[2]); 2 refers to column of the variable.

c = sortcell(c,[2]);
d = c(:,1);

% Average group correlation matrices using a sliding boxcar.
% If you are not interested in using a sliding boxcar,
% comment out what is below. 

for r1=1:nodes
    for r2=1:nodes
        for i=0:(length(d)-w)
        y(r1,r2,i+1) = mean ( cellfun(@(x)(x(r1,r2)),d((i+1):(w+i)) ));
        end
    end
end

% Output variable containing all averaged correlation 
% matrices is 'y'. 

% Use variable, y, for generating network metrics.
% Function for network metrics: Func_Net_Calcs.m


end


