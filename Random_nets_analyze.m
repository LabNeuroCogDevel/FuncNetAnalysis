
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
g = 88;

por = .10;

W=Y;
for k = 1:g,
W(:,:,k) = threshold_proportional(W(:,:,k),por);
end



%Step 5: Binarize matrices


W = double(W~=0);

for k = 1:g,
[R_ed_10(:,:,k) eff(k)] = randmio_und_connected(W(:,:,k),ITER);
end

% MEAURES OF FUNCTIONAL SEGREGATION

    % 1.Degree
        % The degree of a node is equal to the number of edges connected to 
        % that node.

		deg = sum(R_ed_10);

		deg = reshape(deg, [n g]);

		mean_deg = mean(deg);

 

	% 4.Clustering coefficient
		% The clustering coefficient is the fraction of triangles around a node.

		for k = 1:g,
			C(:,k) = clustering_coef_bu(R_ed_10(:,:,k));
		end
		
		% Then take the mean of each group!
		  
		meanC = mean(C);
	
      
% MEAURES OF FUNCTIONAL INTEGRATION

    % 1.Distance matrix
        
        %   The distance matrix contains lengths of shortest paths between 
        %   all pairs of nodes. An entry (u,v) represents the length of 
        %   shortest path from node u to node v. The average shortest path 
        %   length is the characteristic path length of the network.
        
        for k = 1:g,
			D(:,:,k)=distance_bin(R_ed_10(:,:,k));
		end
        
    % 2.Script for:
            %   Characteristic Path Length 
            %   Global Efficiency
            %   Eccentricity
            %   Radius of graph
            %   Diameter of graph
	for k = 1:g,
 [lambda(:,k)] = charpath(D(:,:,k));
	end

	
 % MEASURES OF BRAIN ECONOMY

	% 1. Edges and Edge Density (Measures of cost)

		for k = 1:g,
			K(:,k) = nnz(triu(R_ed_10(:,:,k)));
		end

		for k = 1:g,
			kden = K/((n^2-n)/2);
		end

	% 2. Global and Local Efficiency

		% Global Efficiency
			for k = 1:g,
				E_global(:,k) = efficiency_bin(R_ed_10(:,:,k));
			end

		% Local Efficiency
		local = 1;
			for k = 1:g,
				E_local(:,k) = efficiency_bin(R_ed_10(:,:,k),local);
			end


%---------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------	

% Step 7: Make a structure called MasteRR_ed_10 that will contain network measures for 
% each threshold. MasteRR_ed_10 structure contains the following. 


MasterR_ed_10.D = D;
MasterR_ed_10.deg = deg;
MasterR_ed_10.mean_deg = mean_deg;
MasterR_ed_10.lambda = lambda;
MasterR_ed_10.meanC = meanC;
MasterR_ed_10.k = k;
MasterR_ed_10.kden = kden;
MasterR_ed_10.E_global = E_global;
MasterR_ed_10.E_local = E_local;


% Output of importance will be in your MasteRR_ed_10 structure. 

