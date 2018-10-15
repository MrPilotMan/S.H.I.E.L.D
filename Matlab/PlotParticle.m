figure()
plot3(wiregeometry(:, 1), wiregeometry(:, 2), wiregeometry(:, 3),'Color','b')
hold on
quiver3(allposition(:, 1), allposition(:, 2), allposition(:, 3), allB(:, 1), allB(:, 2), allB(:, 3), 'MaxHeadSize', 2)
plot3(allposition(:, 1), allposition(:, 2), allposition(:, 3))
plot3(allposition(:, 1), allposition(:, 2), allposition(:, 3), '*')
grid on
grid minor
xlabel('X')
ylabel('Y')
zlabel('Z')