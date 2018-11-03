function environment = generateRadiationEnvironment()
    environment = zeros(1, 11);

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
            end

            vector(i) = value;
        end
    end

    charge = randi([-3, 3]);
    mass   = rand * 3.952562528e-25;

    positionVector = updateVector('p');
    velocityVector = updateVector('v');

    while (abs(tan(acos(dot(velocityVector, -positionVector) / (norm(velocityVector) * norm(positionVector)))))) > abs((30 / norm(positionVector)))
        velocityVector = updateVector('v');

        while norm(velocityVector) >= 300000000
            velocityVector = updateVector('v');
        end
    end

    accelerationVector = zeros(1, 3);

    environment(1, :) = [mass, charge, ...
                          positionVector(1), positionVector(2), positionVector(3), ...
                          velocityVector(1), velocityVector(2), velocityVector(3), ...
                          accelerationVector(1), accelerationVector(2), accelerationVector(3)];
end