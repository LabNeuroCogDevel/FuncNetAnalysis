thr = [.01:.01:.50];


for t = 1:length(thr);
   W=Y;
W(W<thr(t))=0;



%Step 5: Binarize matrices


W = double(W~=0);

for k = 1:94,
[R(:,:,k) eff(k)] = randmio_und_connected(W(:,:,k),ITER);
end

Master_rand(t).R=R;
Master_rand(t).eff=eff;

end