function [H,varargout] = corrcoef_func(r,n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
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
z=.5.*log((1+r)./(1-r));

%Estimate hypothetical value z0 and corresponding standard deviation s0
z0=sum(z.*(n-3))/sum(n-3);
s0=1/sqrt(sum(n-3));

%Compute Chi-square value
chi2=sum((n-3).*(z-z0).^2);

%Test the null hypothesis of homogeneity
if chi2<=chi2inv(1-alpha,length(r)-1)
    H=0; %Null hypothesis cannot be rejected, i.e. all rk are equal
    r0=(exp(2*z0)-1)./(exp(2*z0)+1); %Determine the mean correlation coefficient from z0
    z0lim=z0+[-1;1].*norminv(1-alpha/2,0,1)*s0; %1-alpha confidence interval
    r0lim=(exp(2*z)-1)./(exp(2*z)+1);%Transform back into correlation coefficients
else
    H=1;
    r0=[];
end

%Fill output arguments
out{1}=r0;
out{2}=chi2;
if nargout>1
    for i=1:nargout-1
        varargout{i}=out{i};
    end
end
