function block_diag_matrix = diagblockhar(varargin)
    % DIAGBLOCKS build a diagonal block input matrix (A) following HAR structure starting from a
    % collection of lagged RCOV matrices
    % varargin contains 22 prec matrices, where the one in position 22 is the most recent one
    
    
    frecw = frechet_mean(varargin{end-4:end});
    frecm = frechet_mean(varargin{:});
    block_diag_matrix = blkdiag(varargin{22}, frecw, frecm);
end
