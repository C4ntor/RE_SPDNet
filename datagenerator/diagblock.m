function block_diag_matrix = diagblock(varargin)
    % DIAGBLOCKS build a diagonal block input matrix (A) starting from a
    % collection of lagged RCOV matrices

    block_diag_matrix = blkdiag(varargin{:});
end
