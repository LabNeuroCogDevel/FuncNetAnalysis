% This script computes graph parameters from sliding window cell array
% Read everything.
% Meant to ONLY be used for BINARY, UNDIRECTED graphs!!!
% Scripts borrowed from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

% ! Before using these scripts, you must call the folder containing them into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

% Create a 2d matrix of ones equal to number of ROIs. For example, if you have 82 ROIs,
% then you would do: var = ones(82,82). Then, replace diagonal with zeros. Then run this script.



%Step 1: Threshold your matrices (Should use a range of threshold values)

%Need to define a threshold

thr = [.01:.01:.50];


for t = 1:length(thr); %This number is your threshold. Change accordingly. 

% Script modified from threshold_absolute.m

%   This function thresholds the connectivity matrix by absolute weight
%   magnitude. All weights below the given threshold, and all weights
%   on the main diagonal (self-self connections) are set to 0.
%
%   Inputs: W           weighted or binary connectivity matrix
%           thr         weight treshold
%
%   Output: W      thresholded connectivity matrix

W=Y;
W(W<thr(t))=0;






    
    % 3.Modularity 
        %   The optimal community structure is a subdivision of the network
        %   into nonoverlapping groups of nodes in a way that maximizes the 
        %   number of within-group edges, and minimizes the number of 
        %   between-group edges. The modularity is a statistic that 
        %   quantifies the degree to which the network may be subdivided 
        %   into such clearly delineated groups.
        
        for k = 1:83,
            [Ci(:,k), Q(k)]=modularity_finetune_und_sign(W(:,:,k),'sta',Ci0);
		end


Master(t).Ci = Ci;
Master(t).Q = Q;
end

