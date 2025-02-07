close all

initX=out.pose(1,1);
initY=out.pose(1,2);
initTheta=out.pose(1,3);
% v = VideoWriter('material/pixel0_target2');
% open(v)
%visualize
%show map
fig = figure("Name","simpleMap");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(mapMatrix),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot (out.pose(:,2),out.pose(:,1))
hold off


for i = 1:5:size(out.range,3)
    u = out.pose(i,:);
    
    r = out.range(:,:,i);
    exampleHelperAvoidObstaclesPosePlot(u,mapMatrix,mapScale,r,scanAngles,ax,target);
    % writeVideo(v,getframe(fig))
end
% close(v)


personal_plot2(out.tout,out.commands(:,1),out.commands(:,2),"time [s]","","v [m/s]","\(\omega\) [rad/s]", ...
    "material/commands.png","material/commands.eps")

%show map
fig = figure("Name","simpleMap");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(mapMatrix),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot (out.pose(:,1),out.pose(:,2),'-', 'Linewidth',  1.3, 'Color',[0 0.4470 0.7410])
plot (target(1),target(2),'rX','Linewidth', 2)
for i = 1:5:size(out.pose,1)
    plot_rectangle(out.pose(i,1),out.pose(i,2),out.pose(i,3)+pi/2,.9,1.8)
end
% exportgraphics(fig, "material/pixel0_target2_path.png");
% exportgraphics(fig, "material/pixel0_target2_path.eps");
hold off
