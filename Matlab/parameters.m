% Simulation
particles = 100;
scale     = 100000;

% Spacecraft
innerRad  = 10;                % meters
torusRad  = 20;                % meters
totalRad  = innerRad+torusRad; % meters
coilTurns = 100;  		       

% Physics
I         = .1;                % amperes

% math
mu        = 4 * pi * 10^-7;    % [Tm/A]
dtheta    = .001 / pi;         % radians
delt      = 1e-6;              % seconds