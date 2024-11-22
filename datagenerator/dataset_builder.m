function [X, Y] = dataset_builder(N_LAGS,DATA_PATH, GEOHAR)
if nargin < 3
        GEOHAR = false;
end

data = readtable(DATA_PATH);
dataset_length = height(data);

for k = 1:dataset_length
    time_series(:,:,k) = invech(data(k,:)); %build time series of RCOV matrices
end


n_stocks = width(time_series(:,:,1));
%--BUILD TRAIN and TEST sets using Diagonal Input blocks--%

Y = {};
X = {};

if GEOHAR==true
    for i = 23:dataset_length;
    obs = time_series(:,:,i-22:i-1);
    obs_squeezed = squeeze(num2cell(obs, [1 2]));
    Y{end+1} = time_series(:,:,i);
    X{end+1} = diagblockhar(obs_squeezed{:});
    end

else
    for i = N_LAGS+1:dataset_length;
    obs = time_series(:,:,i-N_LAGS:i-1);
    obs_squeezed = squeeze(num2cell(obs, [1 2]));
    Y{end+1} = time_series(:,:,i);
    X{end+1} = diagblock(obs_squeezed{:});
    end

end

end

