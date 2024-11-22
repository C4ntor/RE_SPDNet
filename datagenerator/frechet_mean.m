function M = frechet_mean(varargin)
    % Input:
    % varargin -  a variable number of SPD matrices passed as individual arguments
    % Output:
    % M - the Fréchet mean of the SPD matrices under Log-Euclidean Metric

    n = nargin; % Number of matrices passed
    d = size(varargin{1}, 1); % Dimensionality of the SPD matrices (assuming all matrices are the same size)

    % Compute the mean in the logarithmic domain
    sumLog = zeros(d);
    for i = 1:n
        sumLog = sumLog + logm(makespd(varargin{i})); % logm computes the matrix logarithm
    end

    % Map back to the SPD manifold
    M = expm(sumLog / n); % expm computes the matrix exponential
end

