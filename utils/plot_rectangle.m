function plot_rectangle(x, y, theta, width, height, color)
    % plot_rectangle Plotta un rettangolo centrato in (x, y) con orientamento theta.
    %
    % Input:
    %   x, y - Coordinate del centro del rettangolo
    %   theta - Orientamento del rettangolo (in radianti, senso antiorario)
    %   width - Larghezza del rettangolo
    %   height - Altezza del rettangolo
    %   color - Colore del rettangolo (opzionale, default: 'b')
    %
    % Uso:
    %   plot_rectangle(0, 0, pi/4, 4, 2, 'r') % Rettangolo rosso

    if nargin < 6
        color = 'black'; % Default: colore blu
    end

    % Definisci i vertici del rettangolo rispetto al centro (senza rotazione)
    vertices = [
        -width/2, -height/2;  % Vertice in basso a sinistra
         width/2, -height/2;  % Vertice in basso a destra
         width/2,  height/2;  % Vertice in alto a destra
        -width/2,  height/2   % Vertice in alto a sinistra
    ]';

    % Matrice di rotazione per l'orientamento theta
    R = [cos(theta), -sin(theta); 
         sin(theta),  cos(theta)];

    % Applica la rotazione ai vertici
    rotated_vertices = R * vertices;

    % Trasla i vertici per centrarli in (x, y)
    x_coords = rotated_vertices(1, :) + x;
    y_coords = rotated_vertices(2, :) + y;

    % Chiudi il rettangolo (aggiungi il primo vertice alla fine)
    x_coords = [x_coords, x_coords(1)];
    y_coords = [y_coords, y_coords(1)];

    % Plotta il rettangolo
    plot(x_coords, y_coords, color, 'LineWidth', .1);
    hold on;
    axis equal;
end
