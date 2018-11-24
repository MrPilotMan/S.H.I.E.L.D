function [allPosition, allB, hit] = simulateParticle(wireGeometry, delta, scale)

    I      = 10;              % A
    mu     = 4 * pi * 10^-7; % [Tm/A]
    fourPi = 4 * pi;

    particleInViewField = true;
    while particleInViewField == true

        env = generateParticle(scale);
        % m = env(1) 
        % q = env(2)
        q_over_m  = env(2)/env(1);

        % Initial Conditions
        % Uneccesary, but may be beneficial for code readability
        position        = [env(3), env(4), env(5)];
        velocity        = [env(6), env(7), env(8)];
        acceleration    = [env(9), env(10), env(11)];

        % Preallocate all-Matricies memory
        % Allocations are only estimates, marticies will be resized as needed
        % May be able to calculate matrix size using position. Might be a waste of compute resources.
        allB            = zeros(10e3, 3);
        allPosition     = zeros(10e3, 3);
        allVelocity     = zeros(10e3, 3);
        allAcceleration = zeros(10e3, 3);

        allPosition(1, :)     = position;
        allVelocity(1, :)     = velocity;
        allAcceleration(1, :) = acceleration;

        for iteration = 1:(100^-delta)
            B = zeros(1,3);

            %Calculating B Field
            for n = 2:size(wireGeometry, 1)
                L   = [wireGeometry(n, 1) - wireGeometry(n - 1, 1), ...
                       wireGeometry(n, 2) - wireGeometry(n - 1, 2), ...
                       wireGeometry(n, 3) - wireGeometry(n - 1, 3)];

                distanceVector = [position(1) - wireGeometry(n,1), ...
                                  position(2) - wireGeometry(n,2), ...
                                  position(3) - wireGeometry(n,3)];

                mb4p = (mu / fourPi);
                idtl = I .* L;
                ndex = norm(distanceVector).^3;

                db = zeros(1,3);
                db(1) = mb4p * (idtl(2)*distanceVector(3) - idtl(3)*distanceVector(2)) / ndex;
                db(2) = mb4p * (idtl(3)*distanceVector(1) - idtl(1)*distanceVector(3)) / ndex;
                db(3) = mb4p * (idtl(1)*distanceVector(2) - idtl(2)*distanceVector(1)) / ndex;

                B = B + db;
            end

            acceleration(1) = q_over_m *  (velocity(2)*B(3) - B(2)*velocity(3));
            acceleration(2) = q_over_m * -(velocity(1)*B(3) - B(1)*velocity(3));
            acceleration(3) = q_over_m *  (velocity(1)*B(2) - B(1)*velocity(2));
            velocity = velocity + 10^delta * acceleration;
            position = position + (10^delta/2) * velocity;

            allMatrixIndex = iteration + 1;

            allB(allMatrixIndex, :)            = B;
            allPosition(allMatrixIndex, :)     = position;
            allVelocity(allMatrixIndex, :)     = velocity;
            allAcceleration(allMatrixIndex, :) = acceleration;

            % Check if particle is still in view field
            hit = checkHit(allPosition(allMatrixIndex, :), allPosition(allMatrixIndex-1, :));
            if any(abs(position) > scale) || hit == 1
               particleInViewField = false;
               break;
            end

            % Print statement is unnecessary and imparts useless load
            % fprintf('I: %f\t X: %f\t Y: %f\t Z: %f\n', iteration, position(1), position(2), position(3))
        end

        if particleInViewField == false
            % Removes any unused rows
            % Needed so collapse function will not remove first row
            allB(1, :) = ones();
            allB = allB(any(allB, 2), :);
            allB(1, :) = zeros();
            allPosition = allPosition(any(allPosition, 2), :);

            % Comment out if using CSV
            plotParticle(wireGeometry, allPosition, allB)

            fprintf('Simulation complete \n\n')
        end
    end
end