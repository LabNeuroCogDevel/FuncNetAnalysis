function [ Master_latt ] = latt_net_analysis(g,Rlatt)

% Written by: Scott Marek
% Last Modified: 11/6/2013
% Call: [Y,group_age,Master] = Func_Net_Calcs(n,g,y,age,w,por);
% Read everything before using
% Meant to ONLY be used for BINARY, UNDIRECTED random graphs!!!
% Functions imported from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

%-------------------------------------------------------------------------------------------

% 	Input:
%		 1. g = number of groups
%		 2. Rlatt = Tresholded 3D lattice matrix 		 
	
%	Output:
%	 	 1. Master_latt = Structure containing all network output for each thresholded network

%-------------------------------------------------------------------------------------------

% ! Before using this function, you must call the folder containing it into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

%-------------------------------------------------------------------------------------------


%Step 1: Calculate clustering coefficient and path length 

%	1. Clustering coefficient
%	   The clustering coefficient is the fraction of neighbors of a node that are also
%	   neighbors of each other.

	   for k = 1:g,
	   C(:,k) = clustering_coef_bu(W(:,:,k));
	   end
		
%	   Then take the mean of each group...
		  
	   meanC = mean(C);
       
%	2. Distance matrix
        
%      The distance matrix contains lengths of shortest paths between 
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

% Step 2: Make a Master_rand structure 

Master_latt(p).meanC = meanC;
Master_latt(p).D = D;
Master_latt(p).lambda = lambda;

% Output of importance will be in the Master_latt structure.

end
end
