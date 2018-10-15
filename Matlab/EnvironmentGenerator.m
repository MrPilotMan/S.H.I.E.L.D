function environments = Radiation_Environment_Generator(particles)
        for o = 1:particles
            charge = randi([-3, 3]);
            mass = rand * 3.952562528e-25;
            
            px1 = (2 * 100 * rand) - 100;
            py1 = (2 * 100 * rand) - 100;
            pz1 = (2 * 100 * rand) - 100;
            p = [px1, py1, pz1];
            
            vx1 = (2 * 3e8 * rand) - 3e8;
            vy1 = (2 * 3e8 * rand) - 3e8;
            vz1 = (2 * 3e8 * rand) - 3e8;
            
            while (abs(tan(acos(dot([vx1, vy1, vz1], [-px1, -py1, -pz1]) / (norm([vx1, vy1, vz1]) * norm([px1, py1, pz1])))))) > abs((30 / norm([px1, py1, pz1])))
                vx1 = (2 * 3e8 * rand) - 3e8;
                vy1 = (2 * 3e8 * rand) - 3e8;
                vz1 = (2 * 3e8 * rand) - 3e8;
                while sqrt((vx1^2) + (vy1^2) + (vz1^2)) >= 300000000
                    vx1 = (2 * 3e8 * rand) - 3e8;
                    vy1 = (2 * 3e8 * rand) - 3e8;
                    vz1 = (2 * 3e8 * rand) - 3e8;
        end
    end
    
    v = [vx1, vy1, vz1];
    
%     if px > 0 && vx > 0
%         vx = vx * (-1);
%     end

%     if px < 0 && vx < 0
%         vx = vx * (-1);
%     end

%     if py > 0 && vy > 0
%         vy = vy * (-1);
%     end

%     if py < 0 && vy < 0
%         vy = vy * (-1);
%     end

%     if pz > 0 && vz > 0
%         vz = vz * (-1);
%     end

%     if pz < 0 && vz < 0
%         vz = vz * (-1);
%     end
    
%     ax = (2 * 10000 * rand) - 10000;
%     ay = (2 * 10000 * rand) - 10000;
%     az = (2 * 10000 * rand) - 10000;

        ax1 = 0;
        ay1 = 0;
        az1 = 0;
    a = [ax1, ay1, az1]; 
    
    line = [mass, charge, px1, py1, pz1, vx1, vy1, vz1, ax1, ay1, az1];
    environment(o, :) = line;
        end
        environments = environment;
    end