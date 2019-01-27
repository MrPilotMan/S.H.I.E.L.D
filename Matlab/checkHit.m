% Based on Heron's formula

function hit = checkHit(particlePosition1, particlePosition2)
    hit = 0;
    a = norm(particlePosition1 - particlePosition2);
    
    % The sphere centerd at [0 0 0] is considred the "main" craft. A hit in this sphere is considred a "direct" hit
    % Other spheres extend slightly out of the craft and are considred "periphrial" hits
    sphereCenters = [0  0  0; ...
                     5  5  5; ...
                    -5  5  5; ...
                     5 -5  5; ...
                    -5 -5  5; ...
                     5  5 -5; ...
                    -5  5 -5; ...
                     5 -5 -5; ...
                    -5 -5 -5;];
    
    while hit == 0
        for i = 1:length(sphereCenters)
            b = norm(particlePosition2 - sphereCenters(i, :));
            c = norm(particlePosition1 - sphereCenters(i, :));  
            
            closestApproach = heron(a, b, c);

            if closestApproach > 10
                hit = 0;
            elseif closestApproach < 10 && i ~= 1
                hit = 1;
            elseif closesApproach < 10 && i == 1
                hit = 2;
            end
        end
    end
    
    function altitude = heron(a, b, c)
        s = (a + b + c) / 2;
        altitude = (2/a) * sqrt(s * (s - a) * (s - b) * (s - c));
    end
end
