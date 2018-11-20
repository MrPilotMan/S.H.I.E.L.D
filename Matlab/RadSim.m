clear
clc

% Set up
parallel           = true;
useCSV             = true;
prefix             = 'a';

% Parameters
particlesRequested = 18;
particlesSimualted = 0;

delta              = -8; % seconds
scale              = 150; % meters

innerRadius        = 10;   % meters
torusRadius        = 20;   % meters

% Data
hits               = 0;
misses             = 0;
allTocs            = 0;

% Comment out if loading a pregenerated wireGeometry
% wireGeometry = generateWireGeometry(innerRadius, torusRadius);
% Read in wireGeometry from .mat file
load('wireGeometry/1e4.mat');

if parallel == false
    while particlesSimualted < particlesRequested
        tic

        fprintf('\nStarting simulation: %3.0f \nTotal simulation time: %7.3f seconds \n', uint8(particlesSimualted + 1), allTocs)

        [position, B, hit] = simulateParticle(wireGeometry, delta, scale);
        particlesSimualted = particlesSimualted + 1;
        hits = hits + hit;
        misses = misses + abs(1 - hits);
        
        if useCSV == false
            plotParticle(wireGeometry, position, B)
        else
            fileName = [prefix num2str(particlesSimualted) '.csv'];
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
        fprintf('\nStarting simulation: %3.0f\n', sim)

        [position, B, hit] = simulateParticle(wireGeometry, delta, scale);
        disp(hit)
        %hit = hits + hit;
        
        if useCSV == true
            fileName = [prefix num2str(sim) '.csv'];
            data = [position, B];
            csvwrite(['data/' fileName], data)
        end
    end
    toc
end

misses = particlesRequested - hits;
fprintf('\n\n All particles generated \nHits: %.0f \nMisses: %.0f \n', hits, misses)
