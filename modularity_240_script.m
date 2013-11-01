
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
g = 84;


%-------------------------------------------------------------------------------------------

%Step 4: Threshold your matrices (Should use a range of threshold values)

%Need to define a range of thresholds; can go higher if you please. 

por = [.02:.01:.10];


for p = 1:length(por); %This number is your threshold. Change accordingly. 

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

W=Y;
for k = 1:g,
W(:,:,k) = threshold_proportional(W(:,:,k),por(p));
end


%Step 5: Binarize matrices


W = double(W~=0);

        for k =1:g,
		[Ci(:,k) Q(k)] = modularity_und(W(:,:,k));
        end
        

Master_den(p).por = por(p);
Master_den(p).Ci = Ci;
Master_den(p).Q = Q;

end

% Output of importance will be in your Master_dens structure. 

