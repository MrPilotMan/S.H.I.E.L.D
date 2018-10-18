function RadSimOld
    
    particlesPlotted = 0;
    particlesRequested = 100;
    hits = 0;

    % Need to move plotting into a validity check
    
    % Constraints
        innerRadius = 10;             % meters
        torusRadius = 20;             % meters
        totalradius = innerRadius+torusRadius;
        N           = 100;            % number of turns
        I           = .1;             % A
        mu          = 4 * pi * 10^-7; % [Tm/A]
        dTheta      = .001 / pi;      % radians
        delta        = 1e-6;           % seconds
        % Is there a reason this has to be 10e5?
        scale       = 1000;


    while particlesPlotted < particlesRequested
        tic
        ps  = radiationEnvironmentGenerator(particlesRequested);
        env = ps(particlesPlotted + 1, :);
        % m = env(1) 
        % q = env(2)
        
        % Initial Conditions
        % Uneccesary, but may be beneficial for code readability
        position        = [env(3), env(4), env(5)];
        velocity        = [env(6), env(7), env(8)];
        acceleration    = [env(9), env(10), env(11)];

        % Making Toroidal Wire Geometry
        wireGeometry = createWireGeometry();
        % Incorrect variable name
        validGeometry = false;

        % Preallocate all-Matricies memory
        % Allocations are only estimates, marticies will be resized as needed
        allB            = zeros(10e3, 3);
        allPosition     = zeros(10e3, 3);
        allVelocity     = zeros(10e3, 3);
        allAcceleration = zeros(10e3, 3);
        
        allPosition(1, :)     = position;
        allVelocity(1, :)     = velocity;
        allAcceleration(1, :) = acceleration;

        q_over_m  = env(2)/env(1);

        for iteration = 0:delta:10
            B = zeros(1,3);

            %Calculating B Field
            for n = 2:size(wireGeometry,1)
                L   = [wireGeometry(n, 1) - wireGeometry(n - 1, 1), ...
                       wireGeometry(n, 2) - wireGeometry(n - 1, 2), ...
                       wireGeometry(n, 3) - wireGeometry(n - 1, 3)];

                distanceVector = [position(1)-wireGeometry(n,1), ...
                                  position(2)-wireGeometry(n,2), ...
                                  position(3)-wireGeometry(n,3)];

                distanceVectorMagnitude = sqrt(distanceVector(1)^2 + distanceVector(2)^2 + distanceVector(3)^2);
                db = (mu / (4 * pi)) .* cross(I .* L, distanceVector) ./ distanceVectorMagnitude.^3;
                B = B + db;
            end
            
            acceleration(1) = q_over_m * (velocity(2)*B(3) - B(2)*velocity(3));
            acceleration(2) = q_over_m * -(velocity(1)*B(3) - B(1)*velocity(3));
            acceleration(3) = q_over_m * (velocity(1)*B(2) - B(1)*velocity(2));

            %ITERATIVE DEPENDENT ON EACH STEP delt-BETTER METHOD
            nextPosition = [nextVelocity(1) * delta/2 + position(1), ...
                            nextVelocity(2) * delta/2 + position(2), ...
                            nextVelocity(3) * delta + position(3)];
            
            nextVelocity = [delta * (acceleration(1)) + velocity(1), ...
                            delta * (acceleration(2)) + velocity(2), ...
                            delta * (acceleration(3)) + velocity(3)];

            nextAcceleration = acceleration;

            % Check if particle hit the spacecraft
            if (nextPosition(3) >= -innerRadius) && (nextPosition(3) <= innerRadius)
                if sqrt(nextPosition(1)^2 + nextPosition(2)^2) <= innerRadius 
                    fprintf('Hit the Craft\n')
                    hits = hits + 1;
                    break
                end
            end

            % Check if wire geometry fits in view field
            viewField = abs(scale * totalradius);
            if abs(nextPosition(1)) > viewField || ...
               abs(nextPosition(2)) > viewField || ...
               abs(nextPosition(3)) > viewField
                fprintf('Particle outside of view field \n')
                break
            elseif validGeometry == false
                validGeometry = true;
                fprintf('Starting particle simulation... \n')
            end

            % Convert iteration to integer for martrix appending
            allMatrixIndex = uint32(iteration * 10e5 + 2);

            allB(allMatrixIndex, :)            = B;
            allPosition(allMatrixIndex, :)     = nextPosition;
            allVelocity(allMatrixIndex, :)     = nextVelocity;
            allAcceleration(allMatrixIndex, :) = nextAcceleration;

            position     = nextPosition;
            velocity     = nextVelocity;
            acceleration = nextAcceleration;
            
            % Print statement in uneccesary and imparts useless load
            % fprintf('I: %f\t X: %f\t Y: %f\t Z: %f\n', iteration, position(1), position(2), position(3))
        end

        if validGeometry == true
            allB(1, :) = ones();
            allB = allB(any(allB, 2), :);
            allB(1, :) = zeros();
            allPosition = allPosition(any(allPosition, 2), :);
            
            toc
            particlesPlotted = particlesPlotted + 1;
            k = particlesPlotted;
            plotParticle()
        end
    end

    function geometry = createWireGeometry()
        phi_max = asin(((torusRadius - innerRadius)/2) / (innerRadius + (torusRadius - innerRadius)/2));
        dPhi = N * dTheta;
        phi = pi/2 - phi_max;

        % Preallocate array memory
        geometry = zeros(uint16((2 * pi)/dTheta), 3);

        i = 1;
        for theta = 0:dTheta:(2 * pi)
            xyz = [0, 0, 0];
            xyz(1) = (torusRadius + innerRadius * cos(phi)) * cos(theta);
            xyz(2) = (torusRadius + innerRadius * cos(phi)) * sin(theta);
            xyz(3) = innerRadius * sin(phi);
            
            geometry(i, :) = xyz;
            
            i = i + 1;
            phi = phi + dPhi;
        end

        fprintf('Wire geometry complete \n')
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

            accelerationVector = zeros(1, 3);

            environments(o, :) = [mass, charge, ...
                                  positionVector(1), positionVector(2), positionVector(3), ...
                                  velocityVector(1), velocityVector(2), velocityVector(3), ...
                                  accelerationVector(1), accelerationVector(2), accelerationVector(3)];
        end
    end

    function plotParticle()
        % Create plot window
        figure()
        
        % Create wire geometry
        plot3(wireGeometry(:, 1), wireGeometry(:, 2), wireGeometry(:, 3),'Color','b')
        hold on
        
        % Velocity plot
        quiver3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3), allB(:, 1), allB(:, 2), allB(:, 3), 'MaxHeadSize', 2)
        
        % Plot particel path
        plot3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3))

        % Plot Particle
        plot3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3), '*')
        
        % Clean up
        grid on
        grid minor
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
    end
end