% Script MATLAB per simulare e salvare un plot per diverse combinazioni di k1, k2 e k3
set_param("sequence_dwa_obstacle_avoidance","StopTime","100");
%load map
load simpleMap.mat
mapMatrix = img_logical_1;

mapScale = 1;

% Max speed parameters
maxLinSpeed = 1.5;
maxAngle = deg2rad(30);
maxAngSpeed =.3;

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
            12,5];
wheelBase=1.4;

% Definizione dei parametri
k_values = 0.05:0.05:1; % Valori di k1, k2, k3

% Creazione delle directory per salvare le figure
output_folder = 'simulation_plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Loop su tutti i valori di k1, k2 e k3
for k1 = 1:1:10
    for k2 = 1:1:10
        k3=.1;
            % Stampa dello stato attuale
            fprintf('Simulazione per k1=%.2f, k2=%.4f, k3=%.2f\n', k1, k2, k3);
            
            % Simulazione: Qui puoi inserire il tuo modello/simulazione
            % Per esempio, considera una semplice funzione:
            out = sim("sequence_dwa_obstacle_avoidance.slx");

            % Plot dei risultati
            fig = figure("Name","simpleMap");
            set(fig, "Visible","off");
            ax = axes(fig);
            
            show(binaryOccupancyMap(mapMatrix),"Parent",ax);
            hold on
            plotTransforms([initX,initY,0],eul2quat([initTheta,0,0]),"MeshFilePath","groundvehicle.stl","View","2D");
            light;
            plot (out.pose(:,1),out.pose(:,2))
             for l=1:length(targets)
            plot(ax, targets(l,1), targets(l,2), 'rX', 'MarkerSize', 10, 'LineWidth', 2); % "X" blu con dimensioni personalizzate
   
             end
            
            hold off

            % Salvataggio della figura
            file_name = sprintf('k1_%.2f_k2_%.4f_k3_%.2f.png', k1, k2, k3);
            file_path = fullfile(output_folder, file_name);
            saveas(gcf, file_path);

            % Chiudi la figura per evitare sovraccarico
            close(gcf);
        
    end
end

fprintf('Simulazioni e salvataggi completati.\n');