function [group_age,Master] = Func_Net_Calcs(n,g,y,age,w)

% Written by: Scott Marek
% Last Modified: 10/31/2013
% Call: [group_age,Master] = Func_Net_Calcs(n,g,w);
% Read everything before using.
% Meant to ONLY be used for BINARY, UNDIRECTED graphs!!!
% Functions imported from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

% ! Before using this function, you must call the folder containing it into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

%-------------------------------------------------------------------------------------------

% STEP 1: MAKE SURE YOU CLEAR THE DIAGONAL FOR ALL MATRICES!
%	1. Create a square matrix of ones with a diagonal of zero.

ones_zeros = ~eye(n); % Creates an n x n  matrix of ones with zero across the diagonal.

%	2. Multiple this matrix by your 3D adjacency matrix.

		for k = 1:g,
			Y(:,:,k) = y(:,:,k).*(ones_zeros);
		end
%-------------------------------------------------------------------------------------------

% BE SURE n, g, and Ci0 (See step 6 [Modularity]) ARE PROPERLY DEFINED, OR THIS WILL ERROR OUT!!

%-------------------------------------------------------------------------------------------

% Step 2: Create a vector containing the mean age for each group of your sliding boxcar. 

	for i=0:(length(age)-w)
		group_age(i+1) = mean(age((i+1):(w+i)));
	end

%-------------------------------------------------------------------------------------------


%Step 3: Threshold your matrices (Should use a range of threshold values)

%Need to define a range of thresholds; can go higher if you please. 

por = [.01:.01:.30];


for p = 1:length(por); %This number is your threshold. Change accordingly. 

%-------------------------------------------------------------------------------------------

% Step 4: Threhsold the matrices by network density

% Script modified from threshold_proportional.m

%   This function thresholds the connectivity matrix by network density.
%   All weights below the given threshold, and all weights
%   on the main diagonal (self-self connections) are set to 0.
%
%   Inputs: W           weighted or binary connectivity matrix
%           thr         weight treshold
%
%   Output: W      thresholded connectivity matrix

W=Y;
for k = 1:g,
W(:,:,k) = threshold_proportional(W(:,:,k),por(p));
end


%Step 5: Binarize matrices


W = double(W~=0);

%-------------------------------------------------------------------------------------------

%Step 6: Now the fun begins! Start calculating some network parameters

% All scripts I am using are from the Brain Connectivity Toolbox:
% Available for free at: https://sites.google.com/site/bctnet/



% MEAURES OF FUNCTIONAL SEGREGATION

    % 1.Degree
        % The degree of a node is equal to the number of edges connected to 
        % that node.

		deg = sum(W);

		deg = reshape(deg, [n g]);

		mean_deg = mean(deg);

    % 2.Transitivity
        % Transitivity is the ratio of 'triangles to triplets' in the network.
        % (A classical version of the clustering coefficient).
        
        for k = 1:g,
            C_tri(k)=transitivity_bu(W(:,:,k));
        end


	% 4.Clustering coefficient
		% The clustering coefficient is the fraction of triangles around a node.

		for k = 1:g,
			C(:,k) = clustering_coef_bu(W(:,:,k));
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
			D(:,:,k)=distance_bin(W(:,:,k));
		end
        
    % 2.Script for:
            %   Characteristic Path Length 
            %   Global Efficiency
            %   Eccentricity
            %   Radius of graph
            %   Diameter of graph
	for k = 1:g,
 lambda(:,k) = charpath(D(:,:,k));
    end

    
     for k =1:g,
		[Ci(:,k) Q(k)] = modularity_und(W(:,:,k));
        end
        

	
 % MEASURES OF BRAIN ECONOMY

	% 1. Edges and Edge Density (Measures of cost)

		for k = 1:g,
			K(:,k) = nnz(triu(W(:,:,k)));
		end

		for k = 1:g,
			kden = K/((n^2-n)/2);
		end

	% 2. Global and Local Efficiency

		% Global Efficiency
			for k = 1:g,
				E_global(:,k) = efficiency_bin(W(:,:,k));
			end

		% Local Efficiency
		local = 1;
			for k = 1:g,
				E_local(:,k) = efficiency_bin(W(:,:,k),local);
			end



 % MEASURES OF CENTRALITY
    
    % 1.Betweeness centrality
        
        % Node betweenness centrality is the fraction of all shortest paths in 
        % the network that contain a given node. Nodes with high values of 
        % betweenness centrality participate in a large number of shortest paths.
        
		for k = 1:g,
			BC = betweenness_bin(W(:,:,k));
        end
        

  
 % MEASURES OF NETWORK RESILIENCE 
 
    % 1.Assortativity 
        
        % The assortativity coefficient is a correlation coefficient 
        % between the degrees of all nodes on two opposite ends of a link. 
        % A positive assortativity coefficient indicates that nodes tend to 
        % link to other nodes with the same or similar degree.
    
		for k = 1:g,
            r(k) = assortativity_bin(W(:,:,k),flag);
        end 


%---------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------	

% Step 7: Make a structure called Master that will contain network measures for 
% each threshold. Master structure contains the following. 

Master(p).por = por(p);
Master(p).BC = BC;
Master(p).C_tri = C_tri;
Master(p).D = D;
Master(p).deg = deg;
Master(p).mean_deg = mean_deg;
Master(p).lambda = lambda;
Master(p).r = r;
Master(p).meanC = meanC;
Master(p).k = k;
Master(p).kden = kden;
Master(p).E_global = E_global;
Master(p).E_local = E_local;
Master(p).Ci = Ci;
Master(p).Q = Q;
end

% Output of importance will be in your Master structure. 
end

