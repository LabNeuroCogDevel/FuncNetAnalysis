fid = fopen('network_video.csv','w');
fprintf(fid,'Source\tTarget\tType\tWeight\n')
for i = 1:82,
    for j = (i+1):82,
        wei = reshape(X(i,j,:),[83 1]);
        
        wei_ind = find(wei~=0);
        
        if(length(wei_ind) < 1)
            continue
        end
        
        wei_nz = [wei_ind, wei_ind+1, wei(wei_ind)];
        
        weight_string = sprintf('[%d, %d, %f);', wei_nz');
        
        fprintf(fid,'%d\t%d\tUndirected\t<%s>\n', i,j,weight_string);
        
    end
    
end
fclose(fid)