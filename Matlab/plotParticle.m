function plotParticle(wireGeometry, allPosition, allB)
    % Create plot window
    figure()

    % Plot wire geometry
    plot3(wireGeometry(:, 1), wireGeometry(:, 2), wireGeometry(:, 3),'Color','b')
    hold on

    % Velocity plot
    quiver3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3), allB(:, 1), allB(:, 2), allB(:, 3), 'MaxHeadSize', 2)

    % Plot particle path
    plot3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3))

    % Plot particle
    plot3(allPosition(:, 1), allPosition(:, 2), allPosition(:, 3), '*')

    % Clean up
    grid on
    grid minor
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end