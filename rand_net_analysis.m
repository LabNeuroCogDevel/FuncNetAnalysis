function [ Master_rand ] = rand_net_analysis(n,g,por,R)

% Written by: Scott Marek
% Last Modified: 11/6/2013
% Call: [Y,group_age,Master] = Func_Net_Calcs(n,g,y,age,w,por);
% Read everything before using
% Meant to ONLY be used for BINARY, UNDIRECTED random graphs!!!
% Functions imported from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

%-------------------------------------------------------------------------------------------

% 	Input:
%		 1. n = number of nodes
%		 2. g = number of groups
%		 3. R = Untresholded random matrix 		 
%		 4. por = vector contaning range of densities (ex: por = [.01:.01:.30];)
	
%	Output:
%	 	 3. Master_rand = Structure containing all network output for each thresholded network

%-------------------------------------------------------------------------------------------

% ! Before using this function, you must call the folder containing it into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

%-------------------------------------------------------------------------------------------

% STEP 1: CLEAR THE DIAGONAL FOR ALL MATRICES

	% 1. Create a square matrix of ones with a diagonal of zero.

	ones_zeros = ~eye(n); % Creates an n x n  matrix of ones with zero across the diagonal.

	% 2. Multiple this matrix by the 3D adjacency matrix.

		for k = 1:g,
			Rand(:,:,k) = R(:,:,k).*(ones_zeros);
		end

%-------------------------------------------------------------------------------------------


% Step 2: Threshold your matrices (Vector should contain a range of threshold values)


for p = 1:length(por); 
% Beginning of for loop. Calculating each network metric for each threshold. 

%-------------------------------------------------------------------------------------------

% Step 3: Threhsold the matrices by network density

% Script modified from threshold_proportional.m

%   This function thresholds the connectivity matrix by network density.
%   All weights below the given threshold are set to 0.
%
%   Inputs: Rand           weighted or binary random connectivity matrix
%           por            edge density
%
%   Output: W              thresholded connectivity matrix

W=Rand;
for k = 1:g,
W(:,:,k) = threshold_proportional(W(:,:,k),por(p));
end


%Step 4: Binarize matrices


W = double(W~=0);


%Step 5: Calculate clustering coefficient and path length 

%	1. Clustering coefficient
%	   The clustering coefficient is the fraction of neighbors of a node that are also
%	   neighbors of each other.

	   for k = 1:g,
	   C(:,k) = clustering_coef_bu(W(:,:,k));
	   end
		
%	   Then take the mean of each group...
		  
	   meanC = mean(C);
       
%	2. Distance matrix
        
%   	   The distance matrix contains lengths of shortest paths between 
%	   all pairs of nodes. An entry (u,v) represents the length of 
%  	   shortest path from node u to node v. The average shortest path 
%	   length is the characteristic path length of the network.
        
	   for k = 1:g,
	   D(:,:,k)=distance_bin(W(:,:,k));
	   end
        
% 	3. Path Length:

	   for k = 1:g,
 	   lambda(:,k) = charpath(D(:,:,k));
       end
       
%-------------------------------------------------------------------------------------------

% Step 6: Make a Master_rand structure 

Master_rand(p).meanC = meanC;
Master_rand(p).D = D;
Master_rand(p).lambda = lambda;

% Output of importance will be in the Master_rand structure.

end
end
