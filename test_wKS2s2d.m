function [H, pValue, KSstatistic] = test_wKS2s2d(x1,w1, x2,w2, alpha)

% [H, pValue, KSstatistic] = kstest_2s_2d(x1,w1, x2,w2, alpha)
%
% Two-sample Two-diensional Kolmogorov-Smirnov Test
%
% The paired-sample Kolmogorov-Smirnov test is a statistical test used to
% determine whether two sets of data arise from the same or different
% distributions.  The null hypothesis is that both data sets were drawn
% from the same continuous distribution.
% 
% The algorithm in this function is taken from Peacock [1].
% 
% 'x1' is an [Nx2] matrix, each row containing a two-dimensional sample.
% 'x2' is an [Mx2] matrix, each row likewise containing a two-dimensional
% sample. The optional argument 'alpha' is used to set the desired
% significance level for rejecting the null hypothesis.
% 
% 'H' is a logical value: true indicates that the null hypothesis should be
% rejected.  'pValue' is an estimate for the P value of the test statistic.
% 'KSstatistic' is the raw value for the test statistic ('D' in [1]).
% 
% In contrast to kstest2, this function can only perform a two-tailed test.
% This is because Peacock does not provide a method for estimating P in the
% one-tailed case [1].  Suggestions for a one-tailed test are welcome.
%
% References: [1] J. A. Peacock, "Two-dimensional goodness-of-fit testing
%  in astronomy", Monthly Notices Royal Astronomy Society 202 (1983)
%  615-627.
%    Available from: http://articles.adsabs.harvard.edu/cgi-bin/nph-iarticle_query?1983MNRAS.202..615P&defaultprint=YES&filetype=.pdf
%

% Author: Dylan Muir (From kstest_2s_2d by Qiuyan Peng @ ECE/HKUST) Date:
% 13th October, 2012

%%

if nargin < 2
   error('stats:kstest2:TooFewInputs','At least 2 inputs are required.');
end


%%
%
% x1,x2 are both 2-column matrices
%

if ((size(x1,2)~=2)||(size(x2,2)~=2))
   error('stats:kstest2:TwoColumnMatrixRequired','The samples X1 and X2 must be two-column matrices.');
end
n1 = size(x1,1);
n2 = size(x2,1);

% w1, w2 are both 1-column matrices
if ((size(w1,1)~=n1)||(size(w2,1)~=n2))
   error('stats:kstest2:WrongSizeOfWeightVectors','The weights w1 and w2 must be column vectors with sizes n1, n2 respectively.');
end

%%
%
% Ensure the significance level, ALPHA, is a scalar
% between 0 and 1 and set default if necessary.
%

if (nargin >= 3) && ~isempty(alpha)
   if ~isscalar(alpha) || (alpha <= 0 || alpha >= 1)
      error('stats:kstest2:BadAlpha',...
         'Significance level ALPHA must be a scalar between 0 and 1.');
   end
else
   alpha  =  0.05;
end



%%
%
% Calculate F1(x) and F2(x), the empirical (i.e., sample) CDFs.
%

% - A function handle to perform comparisons in all possible directions
fhCounts = @(x, w, edge)...
	([...
	w((x(:, 1) >= edge(1)) & (x(:, 2) >= edge(2))),...
	w((x(:, 1) < edge(1)) & (x(:, 2) >= edge(2))),...
	w((x(:, 1) < edge(1)) & (x(:, 2) < edge(2))),...
	w((x(:, 1) >= edge(1)) & (x(:, 2) < edge(2)))...
	]);

KSstatistic = -inf;

w1 = (w1 ./ sum(w1))';
w2 = (w2 ./ sum(w2))';

X = [x1;x2];

for iX = 1:(n1+n2)
    % - Choose a starting point
    edge = X(iX,:);
    % - Estimate the CDFs for both distributions around this point
    vfCDF1 = sum(fhCounts(x1, w1, edge));
    vfCDF2 = sum(fhCounts(x2, w2, edge));
    % - Two-tailed test statistic
    % - Final test statistic is the maximum absolute difference in CDFs
    KSstatistic = max(KSstatistic, max(abs(vfCDF1 - vfCDF2)));
end

%% Peacock Z calculation and P estimation

n      =  n1 * n2 /(n1 + n2);
Zn = sqrt(n) * KSstatistic;
Zinf = Zn / (1 - 0.53 * n^(-0.9));
pValue = 2 * exp(-2 * (Zinf - 0.5).^2);

% Clip invalid values for P
if (pValue > 0.2)
   pValue = 0.2;
end

H = (pValue <= alpha);
