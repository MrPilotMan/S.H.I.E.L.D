function wireGeometry = generateWireGeometry(innerRadius, torusRadius)
	dTheta  = .001 / pi;      % radians
    N       = 100;            % number of turns
    phi_max = asin(((torusRadius - innerRadius)/2) / (innerRadius + (torusRadius - innerRadius)/2));
    dPhi    = N * dTheta;
    phi     = pi/2 - phi_max;

    % Preallocate array memory
    wireGeometry = zeros(uint16((2 * pi)/dTheta), 3);

    i = 1;
    for theta = 0:dTheta:(2 * pi)
        xyz = zeros(1,3);
        xyz(1) = (torusRadius + innerRadius * cos(phi)) * cos(theta);
        xyz(2) = (torusRadius + innerRadius * cos(phi)) * sin(theta);
        xyz(3) = innerRadius * sin(phi);

        wireGeometry(i, :) = xyz;

        i = i + 1;
        phi = phi + dPhi;
    end
    fprintf('Wire geometry complete')
end