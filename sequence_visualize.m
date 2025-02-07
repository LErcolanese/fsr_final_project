close all

initX=out.pose(1,1);
initY=out.pose(1,2);
initTheta=out.pose(1,3);
% v = VideoWriter('material/sequence_veloce');
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
    sequence_exampleHelperAvoidObstaclesPosePlot(u,mapMatrix,mapScale,r,scanAngles,ax,targets);
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
for i=1:length(targets)
        plot(ax, targets(i,1), targets(i,2), 'rX', 'MarkerSize', 10, 'LineWidth', 2); % "X" blu con dimensioni personalizzate
   
end
for i = 1:3:size(out.pose,1)
    plot_rectangle(out.pose(i,1),out.pose(i,2),out.pose(i,3)+pi/2,.9,1.8)
end
% exportgraphics(fig, "material/sequence_veloce_path.png");
% exportgraphics(fig, "material/sequence_veloce_path.eps");
hold off
