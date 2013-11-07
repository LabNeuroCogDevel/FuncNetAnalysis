function [Y,group_age,Master_thr] = dens_thr(n,g,y,age,w,thr)

% Written by: Scott Marek
% Last Modified: 11/7/2013
% Call: [Y,group_age,Master_thr] = dens_thr(n,g,y,age,w,thr);
% Read everything before using
% Meant to ONLY be used for BINARY, UNDIRECTED graphs!!!
% Functions imported from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

%-------------------------------------------------------------------------------------------
% 	Input:
%		 1. n = number of nodes
%		 2. g = number of groups
%		 3. y = Untresholded matrix with non-cleared diagonal
%		 4. age = vector containing ages of participants in ASCENDING order
%		 5. w = size of sliding boxcar (# of subjects in each group)
%		 6. thr = vector contaning range of correlation threshold values 
%                 (ex: thr = [.01:.01:.50];)
	
%	Output:
%		 1. Y_thr = Unthresholded matrix with cleared diagonal
%		 2. group_age = average age for each boxcar group
%	 	 3. Master_thr = Structure containing all network output for each thresholded network
%-------------------------------------------------------------------------------------------

% ! Before using this function, you must call the folder containing it into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

%-------------------------------------------------------------------------------------------

% MAKE SURE YOU CLEAR THE DIAGONAL FOR ALL MATRICES!
% 1. Create a square matrix of ones with a diagonal of zero.

ones_zeros = ~eye(n); % Creates an 82x82 matrix of ones with zero across the diagonal.

% 2. Multiple this matrix by your 3D adjacency matrix.

for k = 1:g,
Y(:,:,k) = y(:,:,k).*(ones_zeros);
end


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



%Step 2: Binarize matrices


W = double(W~=0);

%Step 3: Calculate # of connections and network density across age across a
%        range of thresholds. 

% 	1. Edges and Edge Density (Measures of cost)
% 	   These will obviously be equal across groups. If they are not, something's wrong. 

		for k = 1:g,
	        K(:,k) = nnz(triu(W(:,:,k)));
		end

		for k = 1:g,
		kden = K/((n^2-n)/2);
        end
%--------------------------------------------------------------------------

% Step 8: Make a structure called Master_thr that will contain network measures for 
% each network across densities. Master_thr structure contains the following. 

Master(t).K = K;
Master(t).kden = kden;

end
end

