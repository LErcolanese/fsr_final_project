close all

%% script initialization
addpath(fullfile(pwd, 'utils'));
load map3.mat
mapMatrix = map3;

k1=.9;
k2=.006;
k3=.1;

mapScale = 1;

% Max speed parameters
maxLinSpeed = 1.5;
maxAngle = deg2rad(30);
maxAngSpeed = 0.3;

% Initial pose of the robot
initX =36;
initY =34;
initTheta = 0;
v0=0;
w0=0;

% range sensor parameters
scanAngles = -pi/2:pi/128:pi/2;
maxRange = 12;
lidarNoiseVariance = 0.1^2;
lidarNoiseSeeds = randi(intmax,size(scanAngles));

%simulation parameters
sampleTime=0.05;
targets = [58,49;
            42,7;
            32,55;
            10,5];
wheelBase=1.4;

%show map
fig = figure("Name","simpleMap");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(mapMatrix),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot_rectangle(initX,initY, initTheta+pi/2, 1, 1.8, 'r');

hold off

%simulate
set_param("sequence_dwa_obstacle_avoidance","StopTime","100");
out = sim("sequence_dwa_obstacle_avoidance.slx");

%show commands
figure 
plot(out.tout,out.commands(:,1))
hold on
plot(out.tout,out.commands(:,2))
legend('v','w')
hold off


% Plot dei risultati
fig = figure("Name","simpleMap");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(mapMatrix), "Parent", ax);
hold on
plotTransforms([initX, initY, 0], eul2quat([initTheta, 0, 0]), "MeshFilePath", "groundvehicle.stl", "View", "2D");
light;
plot(out.pose(:,1), out.pose(:,2))
for l=1:length(targets)
    plot(ax, targets(l,1), targets(l,2), 'rX', 'MarkerSize', 10, 'LineWidth', 2); % "X" blu con dimensioni personalizzate

end

hold off

%show video
for i = 1:5:size(out.range,3)
    u = out.pose(i,:);
    r = out.range(:,:,i);
    sequence_exampleHelperAvoidObstaclesPosePlot(u,mapMatrix,mapScale,r,scanAngles,ax,targets);
end
