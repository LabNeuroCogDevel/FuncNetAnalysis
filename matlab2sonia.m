function [sonia_output] = matlab2sonia(n,g,W )

% Function for organizing a spreadsheet for SONIA video.
% Written by: Scott Marek
% Last Modified: 11/7/2013

%   Input: n = numbers of nodes
%          g = number of groups
%          W = Thresholded connectivity matrix

%   Output: sonia_output = edge file for SONIA

%-----------------------------------------------------------------------

% Make a column of 'From Ids'
U = 1:n;
U = U';
U = repmat(U,1,(g));
U = reshape(U,[n*(g) 1]);
U = repmat(U,1,n);
U = reshape(U,[(n^2*(g)) 1]);

% Make a column of 'To Ids'
for i = 1:n,
    S(i,1:n) = i;
end
S = S';
S = reshape(S,[(n^2) 1]);
S = repmat(S,1,(g));
S = reshape(S,[(n^2*(g)) 1]);

% ArcWeight
for k = 1:g,
    ArcWeight(:,k) = reshape(W(:,:,k),[(n^2) 1]);
end

ArcWeight = reshape(ArcWeight,[(n^2*(g)) 1]);

% Create Columns for Begin Time and End Time (i.e., groups). 
for i = 1:g,
    EndTime(i,1:(n^2)) = i;
end
EndTime = EndTime';

% Clear last row; want an n x (n+1) matrix


EndTime = reshape(EndTime,[(n^2*(g)) 1]);

BeginTime = EndTime - 1;

output = horzcat(S,U,ArcWeight,BeginTime,EndTime);

% Pull out only values greater than 0.
indices = find(output(:,3)>0);

% Apply indexed values to the output. 
final_output = output(indices,:);

duplicate_index = find(output(:,1)>output(:,2));

final_output = output(duplicate_index,:);

% Delete % below to write to Excel (.csv)
% xlswrite('filename',final_output);

end

