img = imread('pixil-frame-0.png'); % or 'your_image.jpg', etc.
img = rgb2gray(img);  % Converte da RGB a scala di grigi



img_logical_1 = not(logical(img));

pixel0=img_logical_1;
%show map
fig = figure("Name","simpleMap");
set(fig, "Visible","on");
ax = axes(fig);

show(binaryOccupancyMap(img_logical_1),"Parent",ax);
hold on
plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
light;
plot_rectangle(initX,initY, initTheta+pi/2, 1.2, 1.8, 'r');

hold off
