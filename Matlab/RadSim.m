clear
clc

% Set up
parallel           = true;
useCSV             = true;
prefix             = 'a';

% Parameters
particlesSimualted = 0;

delta              = 1e-8; % seconds
scale              = 150; % meters

innerRadius        = 10;   % meters
torusRadius        = 20;   % meters

% Data
hits               = 3;
misses             = 4;
allTocs            = 0;

% Uncomment if not loading a pregenerated wireGeometry
% wireGeometry = generateWireGeometry(innerRadius, torusRadius);
% Read in wireGeometry from .mat file
load('wireGeometry/1e4.mat');

if parallel == false
    while particlesSimualted < particlesRequested
        tic

        fprintf('\nStarting simulation: %3.0f \nTotal simulation time: %7.3f seconds \n', uint8(particlesSimualted + 1), allTocs)

        [position, B] = simulateParticle(wireGeometry, delta, scale);
        particlesSimualted = particlesSimualted + 1;
        
        if useCSV == false
            plotParticle(wireGeometry, position, B)
        else
            fileName = [prefix num2str(particlesSimualted) '.txt'];
            data = [position, B];
            csvwrite(['data/' fileName], data)
        end
        
        thisToc = toc
        allTocs = allTocs + thisToc;
    end

    averageToc = allTocs ./ particlesRequested
    fprintf('Average particle simulation time: %7.3f seconds', averageToc)
else
    tic
    parfor sim = 1:particlesRequested
        fprintf('\nStarting simulation: %3.0f \nTotal simulation time: %7.3f seconds \n', uint8(sim))

        [position, B] = simulateParticle(wireGeometry, delta, scale);
        
        if useCSV == true
            fileName = [prefix num2str(sim) '.txt'];
            data = [position, B];
            csvwrite(['data/' fileName], data)
        end
    end
    toc
end

fprintf('\n\n All particles generated \nHits: %f \nMisses: %f \n', hits, misses)
