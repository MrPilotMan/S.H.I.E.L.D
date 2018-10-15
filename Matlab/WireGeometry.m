wiregeometry = [];
phimax = asin(((torusradius - innerradius)/2) / (innerradius + (torusradius - innerradius)/2));
dphi = N * dtheta;
phi = pi/2 - phimax;

for theta = 0:dtheta:(2 * pi)
    x = (torusradius + innerradius * cos(phi)) * cos(theta);
    y = (torusradius + innerradius * cos(phi)) * sin(theta);
    z = innerradius * sin(phi);

    wiregeometry = [wiregeometry; x, y, z];
    phi = phi + dphi;
end

fprintf('Wire Geometry Complete\n')
%**************Making Toroidal Wire Geometry**************

%**************Reading In External Geometry**************
%wiregeometry=xlsread('FILENAME.xlsx')
%File in 3 Column Format. Column 1: X Coord. Column 2: Y Coord. Column 3: Z Coord.
%**************Reading In External Geometry**************