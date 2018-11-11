clear
clc

% Global variables
particlesSimualted = 0;
particlesRequested = 20;

delta              = 1e-6; % seconds
scale              = 5000; % meters

innerRadius        = 10;   % meters
torusRadius        = 20;   % meters

%hits              = 0;
%misses            = 0;

%runLetter          = 'a';
allTocs            = 0;

wireGeometry = generateWireGeometry(innerRadius, torusRadius);
csvwrite('wireGeometry.txt', wireGeometry)

% Since wireGeometry is constant, it can be read in rather than calculated depending on performance results
% wireGeometry = csvread('wireGeometry.txt');

while particlesSimualted < particlesRequested
	tic
	
	fprintf('\nStarting simulation: %3.0f \nTotal simulation time %7.3f seconds \n', uint8(particlesSimualted + 1), allTocs)
	
	particleSimulation = simulateParticle(wireGeometry, innerRadius, torusRadius, delta, scale);
	particlesSimualted = particlesSimualted + 1;
    
    %fileName = [runLetter num2str(particlesSimualted) '-particleMatrix.txt'];
    %csvwrite(fileName, particleSimulation)

	thisToc = toc
    allTocs = allTocs + thisToc;
end

averageToc = allTocs ./ particlesRequested
fprintf('Average particle simulation time: %7.3f seconds', averageToc)
