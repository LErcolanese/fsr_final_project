function h = personal_plot5(x, y, z,x1,y1,z1, x_label_latex, y_label_latex, z_label_latex,legend1,legend2)

set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'DefaultLegendInterpreter', 'latex')
set(0, 'DefaultAxesTickLabelInterpreter', 'latex')
lw = 2;

h = figure('Renderer', 'painters', 'Position', [10 10 900 350]);
removeToolbarExplorationButtons(h)

plot3(x, y, z, '-', 'Linewidth',  lw, 'Color',[0 0.4470 0.7410]);
hold on
plot3(x1, y1, z1, '--', 'Linewidth',  lw, 'Color',"#D95319");




legend(legend1, legend2);
xlabel(x_label_latex)
ylabel(y_label_latex)
zlabel(z_label_latex)
% xlim([x(1) x(end)])
set(gca, 'FontSize',18);
grid on
box on
set(gcf,'color','w');
% legend('Location','northoutside','Orientation','horizontal')
%exportgraphics(h, pdf_name);

end
