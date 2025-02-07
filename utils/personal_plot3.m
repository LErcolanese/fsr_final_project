function h = personal_plot3(x, y, z, x_label_latex, y_label_latex, z_label_latex)

set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'DefaultLegendInterpreter', 'latex')
set(0, 'DefaultAxesTickLabelInterpreter', 'latex')
lw = 2;

h = figure('Renderer', 'painters', 'Position', [10 10 900 350]);
removeToolbarExplorationButtons(h)

plot3(x, y, z, '-', 'Linewidth',  lw, 'Color',[0 0.4470 0.7410]);




% legend(y1_legend_latex, y2_legend_latex, y3_legend_latex);
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
