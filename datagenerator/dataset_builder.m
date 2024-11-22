function [Btrain, Xtrain, Ytrain, Btest, Xtest, Ytest] = dataset_builder(N_LAGS,TRAINING_F_INDEX,DATA_PATH)
data = readtable(DATA_PATH);
dataset_length = height(data);

for k = 1:dataset_length
    time_series(:,:,k) = invech(data(k,:)); %build time series of RCOV matrices
end

n_stocks = width(time_series(:,:,1));

%--BUILD TRAIN and TEST sets using Diagonal Input blocks--%
Yset = {};
Xset = {};
Bset = {};
for i = N_LAGS+1:dataset_length;
    obs = time_series(:,:,i-N_LAGS:i-1);
    obs_squeezed = squeeze(num2cell(obs, [1 2]));
    Bset{end+1} = time_series(:,:,i-1);
    Yset{end+1} = time_series(:,:,i);
    Xset{end+1} = diagblock(obs_squeezed{:});
end

Btrain = Bset(1:TRAINING_F_INDEX-1);
Xtrain = Xset(1:TRAINING_F_INDEX-1);
Ytrain = Yset(1:TRAINING_F_INDEX-1);

Btest = Bset(TRAINING_F_INDEX:end);
Xtest = Xset(TRAINING_F_INDEX:end);
Ytest = Yset(TRAINING_F_INDEX:end);

end
