function environments = radiationEnvironmentGenerator(particles)
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