function interpretCSV(wireGeometry)
  % Uncomment if running interpretCVS independently
  % load('wireGeometry/1e4.mat')
    
    allPlots = dir('data/*.csv')
    for i = 1:size(allPlots)
        data = csvread(['data/' allPlots(i).name]);
        
        position = data(1:end, 1:3);
        B        = data(1:end, 4:6);

        plotParticle(wireGeometry, position, B)
    end
end