function[b,bint,r,rint,stats] = jenregr(y,X,alpha);


if nargin == 2, 
    alpha = 0.05; 
end

% Check that matrix (X) and left hand side (y) have compatible dimensions
[n,p] = size(X);
[n1,collhs] = size(y);
if n ~= n1, 
    error('The number of rows in Y must equal the number of rows in X.'); 
end 

if collhs ~= 1, 
    error('Y must be a vector, not a matrix'); 
end

% Remove missing values, if any
wasnan = (isnan(y) | any(isnan(X),2));
if (any(wasnan))
   y(wasnan) = [];
   X(wasnan,:) = [];
   n = length(y);
end

% Find the least squares solution.
[Q, R]=qr(X,0);
b = R\(Q'*y);

% Find a confidence interval for each component of x
% Draper and Smith, equation 2.6.15, page 94

RI = R\eye(p);
xdiag=sqrt(sum((RI .* RI)',1))';
nu = n-p;                       % Residual degrees of freedom
yhat = X*b;                     % Predicted responses at each datapoint.
r = y-yhat;                     % Residuals.
if nu ~= 0
   rmse = norm(r)/sqrt(nu);        % Root mean square error.
else
   rmse = Inf;
end
s2 = rmse^2;                    % Estimator of error variance.
%tval = tinv((1-alpha/2),nu);
%bint = [b-tval*xdiag*rmse, b+tval*xdiag*rmse];
bint=1;
% Calculate R-squared.
if nargout==5,
   RSS = norm(yhat-mean(y))^2;  % Regression sum of squares.
   TSS = norm(y-mean(y))^2;     % Total sum of squares.
   r2 = RSS/TSS;                % R-square statistic.
   if (p>1)
      F = (RSS/(p-1))/s2;       % F statistic for regression
   else
      F = NaN;
   end
   prob = 1 - fcdf(F,p-1,nu);   % Significance probability for regression
   stats = [r2 F prob];

   % All that requires a constant.  Do we have one?
   if (~any(all(X==1)))
      % Apparently not, but look for an implied constant.
      b0 = R\(Q'*ones(n,1));
      if (sum(abs(1-X*b0))>n*sqrt(eps))
         warning(sprintf(['R-square is not well defined unless X has'
...
                       ' a column of ones.\nType "help regress" for' ...
                       ' more information.']));
      end
   end
end

% Find the standard errors of the residuals.
% Get the diagonal elements of the "Hat" matrix.
% Calculate the variance estimate obtained by removing each case (i.e.sigmai)
% see Chatterjee and Hadi p. 380 equation 14.
T = X*RI;
hatdiag=sum((T .* T)',1)';
ok = ((1-hatdiag) > sqrt(eps));
hatdiag(~ok) = 1;
if nu < 1, 
  ser=rmse*ones(length(y),1);
elseif nu > 1
  denom = (nu-1) .* (1-hatdiag);
  sigmai = zeros(length(denom),1);
  sigmai(ok) = sqrt((nu*s2/(nu-1)) - (r(ok) .^2 ./ denom(ok)));
  ser = sqrt(1-hatdiag) .* sigmai;
  ser(~ok) = Inf;
elseif nu == 1
  ser = sqrt(1-hatdiag) .* rmse;
  ser(~ok) = Inf;
end

% Create confidence intervals for residuals.
%Z=[(r-tval*ser) (r+tval*ser)]';
%rint=Z';
rint=1;

% Restore NaN so inputs and outputs conform
if (nargout>2 & any(wasnan))
   tmp = ones(size(wasnan));
   tmp(:) = NaN;
   tmp(~wasnan) = r;
   r = tmp;
end
if (nargout>3 & any(wasnan))
   tmp = ones(length(wasnan),2);
   tmp(:) = NaN;
   tmp(~wasnan,:) = rint;
   rint = tmp;
end

