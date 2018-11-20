function particle = generateParticle(scale)
    particleType = randi([1,3]);
    switch particleType
        case 1 
            charge = -1.602e-19;
            mass = 9.11e-31;
            fprintf('electron \n')
        case 2
            charge = 1.602e-19;
            mass = 1.673e-27;
            fprintf('proton \n')
        case 3
            charge = 3.204e-19;
            mass = 6.692e-27;
            fprintf('alpha particle \n')
    end
    particle = zeros(1, 11);
    
    function functionVector = updateVector(algorithm)
        functionVector = zeros(1, 3);

        % Set initial particle position
        if algorithm == 'p'
            minOffset = .8 * scale;
            
            checkOffset = false;
            while any(checkOffset) == false
                for i = 1:3
                    positionAlgorithm = (2 * scale * rand) - scale;
                    functionVector(i) = positionAlgorithm;
                end
                checkOffset = abs(functionVector) > minOffset;
            end
        % Generate random velocity in direction of craft
        elseif algorithm == 'v'
            targetTheta = (2 * pi * rand) - pi;
            targetLength = (60 * rand) - 30;
            
            targetVector = zeros(1, 3);
            targetVector(1) = targetLength * cos(targetTheta); 
            targetVector(2) = targetLength * sin(targetTheta); 
            targetVector(3) = (40 * rand) - 20;

            parametricVector = targetVector - positionVector;
            unitParametricVector = parametricVector./norm(parametricVector);
            magnitude = 3e8 * rand;
            functionVector = magnitude .* unitParametricVector;
%       elseif algorithm == 'a'
%           accelerationAlgorithm = (2 * 10000 * rand) - 10000;
%           value = accelerationAlgorithm
        end
    end

    positionVector = updateVector('p');
    velocityVector = updateVector('v');
    accelerationVector = zeros(1, 3);

    particle(1, :) = [mass, charge, positionVector, velocityVector, accelerationVector];
end