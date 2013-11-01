
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
 
n = 82;
g = 83;


% STEP 2: MAKE SURE YOU CLEAR THE DIAGONAL FOR ALL MATRICES!
%	1. Create a square matrix of ones with a diagonal of zero.

ones_zeros = ~eye(82); % Creates an 82x82 matrix of ones with zero across the diagonal.

%	2. Multiple this matrix by your 3D adjacency matrix.

		for k = 1:g,
			Y(:,:,k) = y(:,:,k).*(ones_zeros);
		end
%-------------------------------------------------------------------------------------------

% BE SURE Ci0,n,g  ARE PROPERLY DEFINED, OR THIS WILL ERROR OUT!!

%-------------------------------------------------------------------------------------------

% Step 3: Create a vector containing the mean age for each group of your sliding boxcar. 

	for i=0:(length(age)-w)
		group_age(i+1) = mean(age((i+1):(w+i)));
	end

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

W=Y;
W(W<thr(t))=0;


%-------------------------------------------------------------------------------------------

%Step 5: Now the fun begins! Start calculating some network parameters

% !! All scripts I am using are from the Brain Connectivity Toolbox:
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
            C_tri(k)=transitivity_wu(W(:,:,k));
        end
    

	% 4.Clustering coefficient
		% The clustering coefficient is the fraction of triangles around a node.

		for k = 1:g,
			C(:,k) = clustering_coef_wu(W(:,:,k));
		end
		
		% Then take the mean of each group!
		  
		meanC = mean(C);

	% 5.Strength
		%   Node strength is the sum of weights of links connected to the node.

		for k = 1:g,
			[Spos Sneg vpos vneg] = strengths_und_sign(W(:,:,k));
		end
	
      
% MEAURES OF FUNCTIONAL INTEGRATION

    % 1.Distance matrix
        
        %   The distance matrix contains lengths of shortest paths between 
        %   all pairs of nodes. An entry (u,v) represents the length of 
        %   shortest path from node u to node v. The average shortest path 
        %   length is the characteristic path length of the network.
        
        for k = 1:g,
			D(:,:,k)=distance_wei(W(:,:,k));
		end
        
    % 2.Script for:
            %   Characteristic Path Length 
            %   Global Efficiency
            %   Eccentricity
            %   Radius of graph
            %   Diameter of graph
	for k = 1:g,
 [lambda(:,k), ecc(k), radius(:,k), diameter(:,k)] = charpath(D(:,:,k));
	end

	% 3. Global and Local Efficiency

		% Global Efficiency
		for k = 1:g,
			E_global(:,k) = efficiency_wei(W(:,:,k));
		end
		
		% Local Efficiency
		local = 1;
		for k = 1:g,
			E_local(:,k) = efficiency_wei(W(:,:,k),local);
		end


 % MEASURES OF CENTRALITY
    
    % 1.Betweeness centrality
        
        % Node betweenness centrality is the fraction of all shortest paths in 
        % the network that contain a given node. Nodes with high values of 
        % betweenness centrality participate in a large number of shortest paths.
        
		for k = 1:g,
			BC = betweenness_wei(W(:,:,k));
        end

	% 2. Edges and Edge Density

		for k = 1:g,
			K(:,k) = nnz(triu(W(:,:,k)));
		end

		for k = 1:g,
			kden = K/((n^2-n)/2);
		end
    
    % 3.Edge betweenness centrality 

        for k = 1:g,
            EBC = edge_betweenness_wei(W(:,:,k));
        end
        
        

  % ** High within-module degree centrality and low participation
  % coefficient = PROVINCIAL HUB
  % ** CONNECTOR HUB = nodes with high participation coefficient 


%---------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------	

% Step 6: Make a structure called Master that will contain network measures for 
% each threshold. Master structure contains the following. 

Master(t).thr = thr(t);
Master(t).BC = BC;
Master(t).C_tri = C_tri;
Master(t).D = D;
Master(t).deg = deg;
Master(t).mean_deg = mean_deg;
Master(t).lambda = lambda;
Master(t).meanC = meanC;
Master(t).k = k;
Master(t).kden = kden;
Master(t).E_global = E_global;
Master(t).E_local = E_local;
Master(t).EBC = EBC;
Master(t).Spos = Spos;
Master(t).Sneg = Sneg;
Master(t).vpos = vpos;
Master(t).vneg = vneg;
end

% Output of importance will be in your Master structure. 

