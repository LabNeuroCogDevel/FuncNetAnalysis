
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



%Step 5: Binarize matrices


W = double(W~=0);

%-------------------------------------------------------------------------------------------

%Step 6: Now the fun begins! Start calculating some network parameters

% !! All scripts I am using are from the Brain Connectivity Toolbox:
% Available for free at: https://sites.google.com/site/bctnet/



% MEAURES OF FUNCTIONAL SEGREGATION

    % 1.Degree
        % The degree of a node is equal to the number of edges connected to 
        % that node.

		deg = sum(W);

		deg = reshape(deg, [n g]);

		mean_deg = mean(deg);

   
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
 [lambda(:,k)] = charpath(D(:,:,k));
	end

	% 3. Global and Local Efficiency

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

	% 2. Edges and Edge Density

		for k = 1:g,
			K(:,k) = nnz(triu(W(:,:,k)));
		end

		for k = 1:g,
			kden = K/((n^2-n)/2);
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

Master(t).thr = thr(t);
Master(t).BC = BC;
Master(t).D = D;
Master(t).deg = deg;
Master(t).mean_deg = mean_deg;
Master(t).lambda = lambda;
Master(t).r = r;
Master(t).meanC = meanC;
Master(t).k = k;
Master(t).kden = kden;
Master(t).E_global = E_global;
Master(t).E_local = E_local;
end

% Output of importance will be in your Master structure. 

