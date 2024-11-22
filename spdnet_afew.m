close all; clear all; clc; pause(0.01);
confPath;
rng('default');
rng(0) ;
format long;

cd('C:\Users\andre\OneDrive - Università degli Studi di Macerata\Articolo Zhang Palma\matlabSPDNET_final\')

%--ARGS--%

opts.loss_function= "frob"; %values: mse, loge, frob
n_lags=10;
data_filename = "RCOV50.csv";
training_index= 2387-n_lags;
opts.dataDir = fullfile('./data') ;
opts.imdbPathtrain = fullfile(opts.dataDir, data_filename);
opts.batchSize = 1;  %ignore: from the spdnet_train.afew we set it to dataset size (train/val)
opts.numEpochs = 5;
opts.gpus =  [];
opts.learningRate = 0.01*ones(1,opts.numEpochs);
opts.weightDecay = 0.0005 ;
opts.continue = 0;
[Btrain,Xtrain,Ytrain,Btest,Xtest,Ytest] = dataset_builder(n_lags, training_index, opts.imdbPathtrain);
opts.train = struct('X', Xtrain, 'Y', Ytrain, 'B', Btrain);
opts.test = struct('X', Xtest, 'Y', Ytest, 'B', Btest);

%spdnet initialization
net = spdnet_init_afew(opts) ;

%spdnet training
[net, info, train_predictions, val_predictions] = spdnet_train_afew(net, opts);

filename = strcat(num2str(opts.numEpochs),'_');
filename = strcat(filename, opts.loss_function);
filename = strcat(strcat(filename,'_'), 'test_predictions.csv');
n = length(opts.train(1).Y);
n= n*(n+1)/2;
headers = cell(1, n); 
for i = 1:n
    headers{i} = sprintf('y%d', i);
end
fid = fopen(filename, 'w');
fprintf(fid, '%s,', headers{1:end-1});
fprintf(fid, '%s\n', headers{end});
fclose(fid);
data = readtable("data\RCOV50.csv");
dataset_length = height(data);
ntest = dataset_length - training_index-n_lags+1;
predictions = array2table(zeros(ntest, n), 'VariableNames', headers');
for i=1 : length(val_predictions)
    row= vech(val_predictions{i})';
    predictions{i,:} = row;
end
writetable(predictions, '5.SPDNetF50_10lag.csv');

