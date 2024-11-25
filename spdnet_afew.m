close all; clear all; clc; pause(0.01);
confPath;
rng('default');
rng(0) ;
format long;

%--ARGS--%
opts.loss_function= "mse"; %other values: loge, frob
n_lags=5;
compute_geohar=false;
if compute_geohar==true
    n_lags=3;  %as the diag block will always contain 3 matrices of size nxn where n is the number of stocks
end
data_filename = "RCOVReal.csv"; %RCOVReal.csv
opts.dataDir = fullfile('./data') ;
opts.imdbPathtrain = fullfile(opts.dataDir, data_filename);
opts.batchSize = 1; 
[X,Y] = dataset_builder(n_lags, opts.imdbPathtrain, compute_geohar);
opts.data = struct('X', X, 'Y', Y);

opts.training_index= 2364;  % - determines the number of (test) predictions to be made as length(X) - training_index
opts.numEpochs = opts.training_index+1;
opts.gpus = [] ;
opts.learningRate = 0.01*ones(1,opts.training_index);
opts.weightDecay = 0.0005 ;
opts.continue = 0;

%spdnet initialization (new network)
net = spdnet_init_afew(opts) ;
[net, info, train_predictions, val_predictions] = spdnet_train_afew(net, opts, X, Y);


filename = strcat(num2str(opts.numEpochs),'_');
filename = strcat(filename, opts.loss_function);
filename = strcat(strcat(filename,'_'), strcat(strcat(num2str(n_lags),'_'),'batch'));
filename = strcat(filename, num2str(opts.batchSize));
filename = strcat(filename, '_test_predictions.csv');
n = length(opts.data(1).Y);
n= n*(n+1)/2;
headers = cell(1, n); 
for i = 1:n
    headers{i} = sprintf('y%d', i);
end
fid = fopen(filename, 'w');
fprintf(fid, '%s,', headers{1:end-1});
fprintf(fid, '%s\n', headers{end});
fclose(fid);
for i=1 : length(val_predictions)
    row= vech(val_predictions{i})';
    dlmwrite(filename, row, '-append');
end

disp('finished')