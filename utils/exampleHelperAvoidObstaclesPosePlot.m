function exampleHelperAvoidObstaclesPosePlot(u, mapMatrix, mapScale, range, scanAngles, ax, target)
    % Esegui la pulizia dell'asse
    cla(ax);
    
    % Mostra la mappa
    show(binaryOccupancyMap(mapMatrix, mapScale), "Parent", ax);
    hold(ax, "on");
    
    % Mostra la posizione del veicolo
    plotTransforms([u(1), u(2), 0], eul2quat([u(3), 0, 0]), "MeshFilePath", "groundvehicle.stl", "View", "2D", "Parent", ax);
    
    % Aggiungi un rettangolo sopra la posizione della macchina
    % Dimensioni del rettangolo: 1 x 1.8 metri
    rectangleWidth = .9;
    rectangleHeight = 1.8;
    % Centra il rettangolo attorno alla posizione del veicolo
    centerX = u(1);
    centerY = u(2);
    theta = u(3)+pi/2; % Orientamento della macchina
    
    % Calcola i vertici del rettangolo ruotato
    corners = [...
        -rectangleWidth/2, -rectangleHeight/2; % Angolo in basso a sinistra
         rectangleWidth/2, -rectangleHeight/2; % Angolo in basso a destra
         rectangleWidth/2,  rectangleHeight/2; % Angolo in alto a destra
        -rectangleWidth/2,  rectangleHeight/2  % Angolo in alto a sinistra
    ]';
    % Ruota i vertici in base all'orientamento
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)]; % Matrice di rotazione
    rotatedCorners = R * corners;
    % Trasla i vertici nella posizione centrale del veicolo
    rotatedCorners(1, :) = rotatedCorners(1, :) + centerX;
    rotatedCorners(2, :) = rotatedCorners(2, :) + centerY;
    % Disegna il rettangolo
    fill(ax, rotatedCorners(1, :), rotatedCorners(2, :), 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 1.5);

    % Aggiungi i dati dello scanner lidar
    scan = lidarScan(range, scanAngles);
    scan = transformScan(scan, u);
    plot(ax, scan.Cartesian(:, 1), scan.Cartesian(:, 2), 'rX'); % Plotta i punti lidar come 'X' rosse
    
    % Plotta il target come una "X" blu
    if nargin > 6 && ~isempty(target)
        
        plot(ax, target(1), target(2), 'bX', 'MarkerSize', 10, 'LineWidth', 2); % "X" blu con dimensioni personalizzate
    end
    
    % Fine del disegno
    hold(ax, "off");
    drawnow;
end
