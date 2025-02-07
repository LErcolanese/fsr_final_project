function h = personal_plot4(x1,x2,x3, y1, y2, y3, x_label_latex, y_label_latex, y1_legend_latex, y2_legend_latex, y3_legend_latex, pdf_name)

set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'DefaultLegendInterpreter', 'latex')
set(0, 'DefaultAxesTickLabelInterpreter', 'latex')
lw = 2;

h = figure('Renderer', 'painters', 'Position', [10 10 900 350]);
removeToolbarExplorationButtons(h)

plot(x1, y1, '-', 'Linewidth',  lw, 'Color',[0 0.4470 0.7410]);
hold on
plot(x2, y2, '--', 'Linewidth', lw, 'Color', "#D95319" );
hold on
plot(x3, y3, '-', 'Linewidth', lw, 'Color',[0.9290 0.6940 0.1250]  );



legend(y1_legend_latex, y2_legend_latex, y3_legend_latex);
xlabel(x_label_latex)
ylabel(y_label_latex)
set(gca, 'FontSize',18);
grid on
box on
set(gcf,'color','w');
legend('Location','northoutside','Orientation','horizontal')
%exportgraphics(h, pdf_name);

end
