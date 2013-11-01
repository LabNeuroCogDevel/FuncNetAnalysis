
% This script computes graph parameters from sliding window cell array
% Written by: Scott Marek
% Last Modified: 8/21/2013
% Read everything before using.
% Meant to ONLY be used for BINARY, UNDIRECTED graphs!!!
% Scripts borrowed from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

% ! Before using these scripts, you must call the folder containing them into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

%-------------------------------------------------------------------------------------------
% Step 1: Define your # of nodes and groups. 
 
n = 240;
g = 103;


%-------------------------------------------------------------------------------------------

%Step 4: Threshold your matrices (Should use a range of threshold values)

%Need to define a range of thresholds; can go higher if you please. 

thr = [.01:.01:.50];


for t = 1:length(thr); %This number is your threshold. Change accordingly. 

%-------------------------------------------------------------------------------------------

% Script modified from threshold_absolute.m

%   This function thresholds the connectivity matrix by absolute weight
%   magnitude. All weights below the given threshold, and all weights
%   on the main diagonal (self-self connections) are set to 0.
%
%   Inputs: Y           weighted or binary connectivity matrix
%           thr         weight treshold
%
%   Output: W      thresholded connectivity matrix

W=ind_matrix;
W(W<thr(t))=0;



%Step 5: Binarize matrices


W = double(W~=0);

%-------------------------------------------------------------------------------------------

%Step 6: Now the fun begins! Start calculating some network parameters

% !! All scripts I am using are from the Brain Connectivity Toolbox:
% Available for free at: https://sites.google.com/site/bctnet/





		for k = 1:g,
			K(:,k) = nnz(triu(W(:,:,k)));
		end

		for k = 1:g,
			kden = K/((n^2-n)/2);
		end
    
        
  
  
 
    



%---------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------	

% Step 7: Make a structure called Master that will contain network measures for 
% each threshold. Master structure contains the following. 

Master(t).thr = thr(t);
Master(t).k = k;
Master(t).kden = kden;

end

% Output of importance will be in your Master structure. 

