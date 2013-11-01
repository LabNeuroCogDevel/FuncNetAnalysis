k = 0;
idx = find(M_Y_copy);
pairs = zeros(size(idx),2);
for a = (1:length(idx));
   b = idx(a);
    i = floor(b/240)+1
    j = mod(b,240)
    if j == 0, j=240; end
   k=k+1
  pairs(k,:) = [i,j]
end

