function RadSimOld
    
    particlesPlotted = 0;
    particlesRequested = 100;
    hits = 0;

    % Need to move plotting into a validity check
    
    % Constraints
        innerradius = 10;             % meters
        torusradius = 20;             % meters
        totalradius = innerradius+torusradius;
        N           = 100;            % number of turns
        I           = .1;             % A
        mu          = 4 * pi * 10^-7; % [Tm/A]
        dtheta      = .001 / pi;      % radians
        delt        = 1e-6;           % seconds
        scale       = 1000;
        % q         = -1.6*10^-19;    % Coulombs
        % m         = 9.11*10^-31;    % kg
        % p0x       = -20;            % meters
        % p0y       = 0;              % meters
        % p0z       = 0;              % meters
        % v0x       = 1;              % m/s
        % v0y       = 0;              % m/s
        % v0z       = 0;              % m/s

        % LEAVE AS ZERO
        % a0x       = 0;              % m/s^2
        % a0y       = 0;              % m/s^2
        % a0z       = 0;              % m/s^2

    while particlesPlotted < particlesRequested
        tic
        ps  = radiationEnvironmentGenerator(particlesRequested);
        env = ps(particlesPlotted + 1, :);
        % m = env(1); q = env(2)
        
        % Initial Conditions
        % Uneccesary, but may be beneficial for code readability
        position        = [env(3), env(4), env(5)];
        velocity        = [env(6), env(7), env(8)];
        acceleration    = [env(9), env(10), env(11)];

        % Making Toroidal Wire Geometry
        wiregeometry = createWireGeometry();
        % Incorrect variable name
        validGeometry = false;

        % Reading In External Geometry
        % wiregeometry = xlsread('FILENAME.xlsx')

        % File in 3 Column Format. Column 1: X Coord. Column 2: Y Coord. Column 3: Z Coord.

        % Allocations are incorrect
        allB                  = zeros(10e3, 3);
        allposition           = zeros(10e3, 3);
        allvelocity           = zeros(10e3, 3);
        allacceleration       = zeros(10e3, 3);
        
        allposition(1, :)     = position;
        allvelocity(1, :)     = velocity;
        allacceleration(1, :) = acceleration;

        q_over_m        = env(2)/env(1);

        for iteration = 0:delt:10
            B = zeros(1,3);

            %Calculating B Field
            for n = 2:size(wiregeometry,1)
                L   = [wiregeometry(n, 1) - wiregeometry(n - 1, 1), ...
                       wiregeometry(n, 2) - wiregeometry(n - 1, 2), ...
                       wiregeometry(n, 3) - wiregeometry(n - 1, 3)];

                distanceVector = [position(1)-wiregeometry(n,1), ...
                                  position(2)-wiregeometry(n,2), ...
                                  position(3)-wiregeometry(n,3)];

                magdistvec = sqrt(distanceVector(1)^2 + distanceVector(2)^2 + distanceVector(3)^2);
                db = (mu / (4 * pi)) .* cross(I .* L, distanceVector) ./ magdistvec.^3;
                B = B + db;
            end
            
            acceleration(1) = q_over_m * (velocity(2)*B(3) - B(2)*velocity(3));
            acceleration(2) = q_over_m * -(velocity(1)*B(3) - B(1)*velocity(3));
            acceleration(3) = q_over_m * (velocity(1)*B(2) - B(1)*velocity(2));

            %ITERATIVE DEPENDENT ON EACH STEP delt-BETTER METHOD
            velocitynext = [delt * (acceleration(1)) + velocity(1), ...
                            delt * (acceleration(2)) + velocity(2), ...
                            delt * (acceleration(3)) + velocity(3)];

            positionnext = [velocitynext(1) * delt/2 + position(1), ...
                            velocitynext(2) * delt/2 + position(2), ...
                            velocitynext(3) * delt + position(3)];

            accelerationnext = acceleration;

            % Check if particle hit the spacecraft
            if (positionnext(3) >= -innerradius) && (positionnext(3) <= innerradius)
                if sqrt(positionnext(1)^2 + positionnext(2)^2) <= innerradius 
                    fprintf('Hit the Craft\n')
                    hits = hits + 1;
                    break
                end
            end

            % Check if wire geometry fits in view field
            if abs(positionnext(1)) > abs(scale * totalradius) || ...
               abs(positionnext(2)) > abs(scale * totalradius) || ...
               abs(positionnext(3)) > abs(scale * totalradius)
                fprintf('Outside of Viewing Area\n')
                break
            elseif validGeometry == false
                validGeometry = true;
                fprintf('Starting particle simulation...')
            end

            allMatrixIndex = uint32(iteration * 10e5 + 2);
            allposition(allMatrixIndex, :)     = positionnext;
            allvelocity(allMatrixIndex, :)     = velocitynext;
            allacceleration(allMatrixIndex, :) = accelerationnext;

            position     = positionnext;
            velocity     = velocitynext;
            acceleration = accelerationnext;

            allB(allMatrixIndex, :) = B;
            
            %fprintf('I: %f\t X: %f\t Y: %f\t Z: %f\n', iteration, position(1), position(2), position(3))
        end
        if validGeometry == true
            allB(1, :) = ones();
            allB = allB(any(allB, 2), :);
            allB(1, :) = zeros();
            allposition = allposition(any(allposition, 2), :);
            
            toc
            particlesPlotted = particlesPlotted + 1;
            k = particlesPlotted;
            plotParticle()
        end
    end

    function geometry = createWireGeometry()
        phimax = asin(((torusradius - innerradius)/2) / (innerradius + (torusradius - innerradius)/2));
        dphi = N * dtheta;
        phi = pi/2 - phimax;

        % Preallocate array memory
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

    function environments = radiationEnvironmentGenerator(environmentsRequested)
        environments = zeros(environmentsRequested, 11);
        function vector = updateVector(algorithm)
            vector = zeros(1, 3);

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

        for o = 1:environmentsRequested
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

            environments(o, :) = line;
        end
    end

    function plotParticle()
        % Create plot window
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
end