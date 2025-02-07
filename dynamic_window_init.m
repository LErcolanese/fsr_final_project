close all

%% script initialization
addpath(fullfile(pwd, 'utils'));

%load map
load map1.mat
load map2.mat

%switch between map1 and map2
mapMatrix = map2;

if size(mapMatrix) == size(map1)
    k1= 0.80;
    k2=0.011;
    k3=0.20;
    % Initial pose of the robot
    initX =22;
    initY =3;
    initTheta = pi;
elseif size(mapMatrix) == size(map2)
    k1= 0.80;
    k2=0.006;
    k3=0.02;
    % Initial pose of the robot
    initX =6;
    initY =21;
    initTheta = 0;
end

mapScale = 1;

% Max speed parameters
maxLinSpeed = 1.5;
maxAngle = deg2rad(30);
maxAngSpeed = 0.3;

% Initial commands of the robot
v0=0;
w0=0;

% range sensor parameters
scanAngles = -pi/2:pi/128:pi/2;
maxRange = 12;
lidarNoiseVariance = 0.1^2;
lidarNoiseSeeds = randi(intmax,size(scanAngles));

%simulation parameters
sampleTime=0.05;
target = [5;5];
wheelBase=1.4;

%show map
fig = figure("Name","map1");
set(fig, "Visible","on");
ax = axes(fig);
% 
show(binaryOccupancyMap(mapMatrix),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot_rectangle(initX,initY, initTheta+pi/2, 1, 1.8, 'r');

hold off

%simulate
set_param("dwa_obstacle_avoidance","StopTime","30");
out = sim("dwa_obstacle_avoidance.slx");

%visualize
%show map
fig = figure("Name","map1");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(mapMatrix),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot (out.pose(:,1),out.pose(:,2))
plot (target(1),target(2),'bX')

hold off

%show control inputs
figure 
plot(out.tout,out.commands(:,1))
hold on
plot(out.tout,out.commands(:,2))
legend('v','w')
hold off

%show video
for i = 1:5:size(out.range,3)
    u = out.pose(i,:);
    r = out.range(:,:,i);
    exampleHelperAvoidObstaclesPosePlot(u,mapMatrix,mapScale,r,scanAngles,ax,target);
end
