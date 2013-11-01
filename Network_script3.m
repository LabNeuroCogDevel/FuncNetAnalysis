% This script computes graph parameters from sliding window cell array
% Read everything.
% Meant to ONLY be used for BINARY, UNDIRECTED graphs!!!
% Scripts borrowed from Brain Connectivity Toolbox 
% (Rubinov & Sporns, 2010,NeuroImage)

% ! Before using these scripts, you must call the folder containing them into Matlab
% In Matlab window: addpath('xxxxxxxx')
% Need to add path for this script and for Brain Connectivity Toolbox folder.

% Create a 2d matrix of ones equal to number of ROIs. For example, if you have 82 ROIs,
% then you would do: var = ones(82,82). Then, replace diagonal with zeros. 
% Multiple your weighted matrix by ones/zeros matrix
%	for k = 1:83,
%		W(:,:,k) = y(:,:,k).*(zeros/ones matrix);
%	end



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

W=net_four; 
W(W<thr(t))=0;





%Step 2: Binarize matrices

%Step 2: Binarize matrices

%Input:    W,   thresholded, weighted connection matrix

%Output:    W, thresholed, binary connection matrix

% ensure W is binary...

W = double(W~=0);




%Step 3: Now the fun begins! Start calculating some network parameters

% !! All scripts I am using are from the Brain Connectivity Toolbox:
% Available for free at: https://sites.google.com/site/bctnet/



% MEAURES OF FUNCTIONAL SEGREGATION

    % 1.Degree
        % The degree of a node is equal to the number of edges connected to 
        % that node.

		deg = sum(W);

    % 2.Transitivity
        % Transitivity is the ratio of 'triangles to triplets' in the network.
        % (A classical version of the clustering coefficient).
        
        for k = 1:83, % !! 83 = number of groups (for me) so replace 83 with your number!!!
            C_tri(k)=transitivity_bu(W(:,:,k));
        end
    
    % 3.Modularity 
        %   The optimal community structure is a subdivision of the network
        %   into nonoverlapping groups of nodes in a way that maximizes the 
        %   number of within-group edges, and minimizes the number of 
        %   between-group edges. The modularity is a statistic that 
        %   quantifies the degree to which the network may be subdivided 
        %   into such clearly delineated groups.
        
        for k = 1:83,
            [Ci(:,k), Q(k)]=modularity_und(W(:,:,k));
		end

	% 4.Clustering coefficient
		% The clustering coefficient is the fraction of triangles around a node.

		for k = 1:83,
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
        
        for k = 1:83,
			D(:,:,k)=distance_bin(W(:,:,k));
		end
        
    % 2.Script for:
            %   Characteristic Path Length 
            %   Global Efficiency
            %   Eccentricity
            %   Radius of graph
            %   Diameter of graph
	for k = 1:83,
 [lambda(:,k), ecc(k), radius(:,k), diameter(:,k), efficiency(k)] = charpath(D(:,:,k));
	end

 % MEASURES OF CENTRALITY
    
    % 1.Betweeness centrality
        
        % Node betweenness centrality is the fraction of all shortest paths in 
        % the network that contain a given node. Nodes with high values of 
        % betweenness centrality participate in a large number of shortest paths.
        
		for k = 1:83,
			BC = betweenness_bin(W(:,:,k));
        end
    
    % 2.Edge betweenness centrality 

        for k = 1:83,
            EBC = edge_betweenness_bin(W(:,:,k));
        end
        
        
    % 3.Within-module degree z-score
        
        % The within-module degree z-score is a within-module version of degree
        % centrality.
    
		for k = 1:83,
            Z(:,k) = module_degree_zscore(W(:,:,k),Ci(:,k));
		end
    
    % 4.Participation coefficient
        % Measure of diversity of intermodular connections of individual
        % nodes
        
		for k = 1:83,
            P(:,k) = participation_coef(W(:,:,k),Ci(:,k));
		end
  
  % ** High within-module degree centrality and low participation
  % coefficient = PROVINCIAL HUB
  % ** CONNECTOR HUB = nodes with high participation coefficient 
        

  
 % MEASURES OF NETWORK RESILIENCE 
 
    % 1.Assortativity 
        
        % The assortativity coefficient is a correlation coefficient 
        % between the degrees of all nodes on two opposite ends of a link. 
        % A positive assortativity coefficient indicates that nodes tend to 
        % link to other nodes with the same or similar degree.
    
		for k = 1:83,
            r(k) = assortativity_bin(W(:,:,k),flag);
        end 


% Now just to clean up some variables (i.e., reshape them into a more user friendly form :)

	
	deg = reshape(deg,[12 83]);
	Q = reshape(Q,[1 83]);
	C = reshape(C, [12 83]);

% Make variable for average age at each group:

	for i=0:(length(age)-w)
		group_age(i+1) = mean(age((i+1):(w+i)));
	end


Master(t).thr = thr(t);
Master(t).BC = BC;
Master(t).C_tri = C_tri;
Master(t).Ci = Ci;
Master(t).D = D;
Master(t).P = P;
Master(t).Q = Q;
Master(t).deg = deg;
Master(t).diameter = diameter;
Master(t).ecc = ecc;
Master(t).efficiency = efficiency;
Master(t).lambda = lambda;
Master(t).r = r;
Master(t).radius = radius;
Master(t).Z = Z;
Master(t).meanC = meanC;
Master(t).EBC = EBC;
end

