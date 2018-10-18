% Global variables
innerradius = 10;             % meters
torusradius = 20;             % meters
totalradius = innerradius+torusradius;
N           = 100;            % number of turns
I           = .1;             % A
mu          = 4 * pi * 10^-7; % [Tm/A]
dtheta      = .001 / pi;      % radians
delt        = 1e-6;           % seconds
scale       = 100000;

% Main
	for i = 1:particles
		radiationEnvironment = generateRadiationEnvironment();
		wireGeometry = generateWireGeometry();
		simulation = simulateRadiation(radiationEnvironment, wireGeometry);
		plotParticle(simulation);
	end

% Randoimize machine
function generateEntropy()

% Simulation
function simulation = simulateRadiation(radiationEnvironment, wireGeometry)


% Create environment
function environments = generateRadiationEnvironment(particles)

        function vector = updateVector(algorithm)

            for i = 1:3
                if algorithm == 'p'
                    positionAlgorithm = (2 * 100 * rand) - 100;
                    value = positionAlgorithm;
                elseif algorithm == 'v'
                    velocityAlgorithm = (2 * 3e8 * rand) - 3e8;
                    value = velocityAlgorithm;
              % elseif algorithm == 'a'
                    % accelerationAlgorithm = (2 * 10000 * rand) - 10000;
                    % value = accelerationAlgorithm
                else
                    fprintf('unkown alogrithm');
                end

                vector(i) = value;
            end
        end

        for o = 1:particles
            charge = randi([-3, 3]);
            mass = rand * 3.952562528e-25;

            positionVector = updateVector('p');
            velocityVector = updateVector('v');

            while (abs(tan(acos(dot(velocityVector, -positionVector) / (norm(velocityVector) * norm(positionVector)))))) > abs((30 / norm(positionVector)))
                velocityVector = updateVector('v');

                while sqrt((velocityVector(1)^2) + (velocityVector(2)^2) + (velocityVector(3)^2)) >= 300000000
                    velocityVector = updateVector('v');
                end
            end

            % if px > 0 && vx > 0 || px < 0 && vx < 0
            %   vx = vx * (-1);
            % end

            % if py > 0 && vy > 0 || py < 0 && vy < 0
            %   vy *= -1;
            % end

            % if pz > 0 && vz > 0 || pz < 0 && vz < 0
            %   vz *= -1;
            % end

            accelerationVector = [0, 0, 0];

            line = [mass, charge, ...
                    positionVector(1), positionVector(2), positionVector(3), ...
                    velocityVector(1), velocityVector(2), velocityVector(3), ...
                    accelerationVector(1), accelerationVector(2), accelerationVector(3)];

            environment(o, :) = line;
        end
        environments = environment;
    end

% Wire geometry
function geometry = generateWireGeometry()
        phimax = asin(((torusradius - innerradius)/2) / (innerradius + (torusradius - innerradius)/2));
        dphi = N * dtheta;
        phi = pi/2 - phimax;

        geometry = zeros(uint16((2 * pi)/dtheta), 3);

        i = 1;
        for theta = 0:dtheta:(2 * pi)
            xyz = [0, 0, 0];
            xyz(1) = (torusradius + innerradius * cos(phi)) * cos(theta);
            xyz(2) = (torusradius + innerradius * cos(phi)) * sin(theta);
            xyz(3) = innerradius * sin(phi);
            
            geometry(i, :) = xyz;
            
            i = i + 1;
            phi = phi + dphi;
        end

        fprintf('Wire Geometry Complete\n')
    end

% Calculate fields
function

% Plot
function plotParticle(simulation)
        % Create particle and wire plot
        figure()
        
        % Create wire geometry
        plot3(wiregeometry(:, 1), wiregeometry(:, 2), wiregeometry(:, 3),'Color','b')
        hold on
        
        % Velocity plot
        quiver3(allposition(:, 1), allposition(:, 2), allposition(:, 3), allB(:, 1), allB(:, 2), allB(:, 3), 'MaxHeadSize', 2)
        
        % Plot particel path
        plot3(allposition(:, 1), allposition(:, 2), allposition(:, 3))

        % Plot Particle
        plot3(allposition(:, 1), allposition(:, 2), allposition(:, 3), '*')
        
        % Clean up
        grid on
        grid minor
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
    end