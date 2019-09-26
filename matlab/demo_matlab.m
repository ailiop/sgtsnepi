%
% SCRIPT: DEMO_MATLAB
%
%   Demo usage of t-SNE-Pi through MATLAB wrapper
% 
%   Before executing, issue the following commands in terminal
% 
%     cp <MROOT>/toolbox/stats/stats/private/tsnelossmex.<MEXEXT> ./
%     cp <MROOT>/toolbox/stats/stats/private/tsnebhmex.<MEXEXT> ./
% 
%   where <MROOT> is the path to MATLAB installation
%   and <MEXEXT> is the extension for the MEX executables on your system.
% 
%   Issue  matlabroot  to find the path
% 
%   The changes to the MATLAB function can be seen by issuing
% 
%   diff tsne_custom.m <MROOT>/toolbox/stats/stats/tsne.m
%


%% CLEAN-UP

clear
close all


%% PARAMETERS

urlMNIST = 'https://github.com/daniel-e/mnist_octave/raw/master/mnist.mat';

% subsample MNIST? (empty for full)
nSub = 1e4;

alg  = 'tsnepi';     % algorithm for tSNE
pca  = 50;           % PCA components (prior to tSNE)
dist = 'euclidean';  % distance metric
u    = 30;           % perplexity
dEmb = 2;            % 1, 2 and 3 dimensional embeddings are supported
verb = 2;            % verbose level


%% (BEGIN)

rng default
fprintf('\n *** begin %s ***\n\n',mfilename);

%% LOAD MNIST DIGITS

fprintf( '...load MNIST digits...\n' ); 

fprintf( '   - getting data in memory...\n')

if exist('/tmp/mnist.mat', 'file') ~= 2
  websave('/tmp/mnist.mat', urlMNIST );
end

d = load( '/tmp/mnist.mat' );
X = d.trainX;
X = im2double( X );
L = d.trainY';
clear d;

if ~isempty(nSub)
  prand = randperm( size(X,1), nSub );
  X = X(prand,:);
  L = L(prand);
end

n = size(X,1);

fprintf( '   - DONE\n');


%% T-SNE EMBEDDING

fprintf( '...t-SNE embedding...\n' ); 

Y = tsne_custom(X, ...
                'Algorithm', alg, ...
                'NumPCAComponents', pca, ...
                'NumDimensions', dEmb, ...
                'Distance', dist, ...
                'Perplexity', u, ...
                'Verbose', verb);

fprintf( '   - DONE\n');

%% VISUALIZE EMBEDDING

fprintf( '...visualize embedding...\n' ); 

figure

switch dEmb
  case 1
    scatter(Y(:,1), Y(:,1), eps, L, '.' )
  case 2
    scatter( Y(:,1), Y(:,2), eps, L, '.' )
  case 3
    scatter3( Y(:,1), Y(:,2), Y(:,3), eps, L, '.' )
end

axis image off
colormap( jet(10) )
colorbar
title(sprintf( 't-SNE MNIST embedding | u: %d', u ) )

fprintf( '   - DONE\n');


%% (END)

fprintf('\n *** end %s ***\n\n',mfilename);




%%------------------------------------------------------------
%
% AUTHORS
%
%   Dimitris Floros                         fcdimitr@auth.gr
%
% VERSION       0.1
%
% TIMESTAMP     <Sep 26, 2019: 11:41:02 Dimitris>
%
% ------------------------------------------------------------

