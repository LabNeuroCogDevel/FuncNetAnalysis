r=r(:);
n=n(:);
alpha=.05; %Set default

if nargin <2
    disp('Error: Not enough input arguments');
    return;
elseif nargin>2
    alpha=varargin{3};
end

%Compute the Fisher's z-transform for all correlation coefficients in r
z=fisherz(r);

%Estimate hypothetical value z0 and corresponding standard deviation s0
z0=sum(z.*(n-3))/sum(n-3);
s0=1/sqrt(sum(n-3));

%Compute Chi-square value
chi2=sum((n-3).*(z-z0).^2);

%Test the null hypothesis of homogeneity
if chi2<=chi2inv(1-alpha,length(r)-1)
    H=0; %Null hypothesis cannot be rejected, i.e. all rk are equal
    r0=ifisherz(z0); %Determine the mean correlation coefficient from z0
    z0lim=z0+[-1;1].*norminv(1-alpha/2,0,1)*s0; %1-alpha confidence interval
    r0lim=ifisherz(z0lim); %Transform back into correlation coefficients
else
    H=1;
    r0=[];
end

%Fill output arguments
out{1}=r0;
out{2}=r0lim;
out{3}=chi2;
if nargout>1
    for i=1:nargout-1
        varargout{i}=out{i};
    end
end