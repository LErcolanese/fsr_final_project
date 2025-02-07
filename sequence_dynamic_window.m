function out = sequence_dynamic_window(pose, target, pose_dot, range, k1, k2, k3)
    %% --- PRELIMINARY DECLARATIONS ---

    % comando corrente
    v_curr = pose_dot(1);
    w_curr = pose_dot(2);

    %stato x y e heading del veicolo
    x = pose(1);
    y = pose(2);
    theta = pose(3);

    %posizione x y del target
    x_target = target(1);
    y_target = target(2);


    % Costanti
    v_max = 1.5;
    phi_max = deg2rad(30);
    l = 1.4;
    av = 9;
    aw = 2;
    T = 0.05;
    Ttimes=T;
    distance_threshold = .7;


    distance_to_target=sqrt((x_target-x)^2+(y_target-y)^2);

    d_max=12;

    % sampling degli input
    v_samples = linspace(max(0, v_curr - av * T), min(v_max, v_curr + av * T), 10);
    w_samples = linspace(max(-v_max * tan(phi_max) / l, w_curr - aw * T), ...
                         min(v_max * tan(phi_max) / l, w_curr + aw * T), 10);

    % inizializzazione
    best_cost =-inf; best_target_heading =0; best_velocity =0; best_clearance =0;
    best_v = 0;
    best_w = 0;
    
    % Loop su v e w
    for i=1:length(v_samples)
        v=v_samples(i);
        for j=1:length(w_samples)
            w=w_samples(j);
            % Calcolo della distanza dagli ostacoli
            [distance_to_obstacle, angle_to_obstacle] = dist(v, -w, range, d_max);

            % Controllo del vincolo sui parametri
            if v>floor(sqrt(2*distance_to_obstacle*av)) || ...
                w>floor(sqrt(2*distance_to_obstacle*aw)) || ...
                (v==0 && w>0)
                continue; % Salta questa coppia v, w
            end

            [x_p1,y_p1,theta_p1]=model_evolution(pose,v,w,Ttimes);

            % Calcolo heading
            angle_to_target = atan2(y_target - y_p1, x_target - x_p1);
            theta_prime = mod(angle_to_target - theta_p1 + pi, 2 * pi) - pi;

            target_heading = (1 - abs(theta_prime) / pi);

            % Penalizza velocità se vicino al target
            if (distance_to_target) > distance_threshold 
                velocity = abs(v)/v_max;
            else
                velocity = 1 - abs(v) / v_max;
            end

            %clearance term
            clear=min(distance_to_obstacle);
            clearance=clear/d_max;

            % Funzione obiettivo
            cost = k1 * target_heading + k2 * velocity + k3 * clearance ;

            % Aggiorna soluzione migliore
            if cost > best_cost
                best_cost = cost;
                best_target_heading=target_heading;
                best_velocity=velocity;
                best_clearance=clearance;
                best_v = v;
                best_w = w;
            end
        end
    end

    % Ritorna la coppia migliore
    out = [best_v, best_w, ...
        best_target_heading, best_velocity, best_clearance]; %for debug
end

function [dist, a]=dist(v,w,range,d_max)
    

    
    % calcolo della funzione dist
    % dist=d_coll/d_max, d_coll = min (d_front, d_back, d_right, d_left)
    % dist dipende da v,w e dal punto in cui si trova l'ostacolo
    % dist è la minima tra le distanze dagli ostacoli 
    angle=linspace(-pi/2, pi/2, length(range));
    d=d_max; %valore 
    a=0;
    
    Y_FRONT= .2;
    Y_BACK=-1.6;
    X_LEFT=-.5;
    X_RIGHT=.5;
    
    if (v==0)
       d=0;
    %se w=0, sto andando dritto con velocità v
    elseif (w==0)
        for i = 1: length(range) %prendo un ostacolo
            x_obs=-range(i)*sin(angle(i));
    
            if  range(i)<d_max && (x_obs>=X_LEFT && x_obs<=X_RIGHT)
    
                %definisco obstacle point:
                y_obs=range(i)*cos(angle(i));
    
                d_obs=y_obs-Y_FRONT;
                a_obs=0;
    
                if d_obs<d
                    d=d_obs;
                    a=a_obs;
                end
            end
        
        end
    
    else
        
        r=(v/w); %raggio del cerchio che sto percorrendo
        C=[v/(w);0];
        
        
        for i = 1: length(range) %prendo un ostacolo
    
            if  range(i)<d_max
    
                d_vec=d_max.*ones(3,1);
    
                %definisco obstacle point:
                x_obs=-range(i)*sin(angle(i));
                y_obs=range(i)*cos(angle(i));
                O=[x_obs;y_obs];
                O_C=O-C;
    
                r_obs_sqr=(x_obs-r)^2+y_obs^2;
        
                %definisco dfront
                if (r_obs_sqr-Y_FRONT^2)>=0
                    x_c_plus=abs(r)+sqrt(r_obs_sqr-Y_FRONT^2);
                    x_c_minus=abs(r)-sqrt(r_obs_sqr-Y_FRONT^2);
                    y_c=Y_FRONT;
    
                    d_vec_prime=d_max.*ones(2,1);
                    alfa_vec_prime=zeros(2,1);
    
                    if (x_c_plus>=X_LEFT && x_c_plus<=X_RIGHT)
                        P=[x_c_plus;y_c];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (x_c_minus>=X_LEFT && x_c_minus<=X_RIGHT)
                        P=[x_c_minus;y_c];
                        P_C=P-C;
    
                        alfa_minus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_minus=alfa_minus*r;
                        d_vec_prime(2)=abs(d_minus);
                    end

                    d_vec(1)=min(d_vec_prime);
                end
                
        
                %definisco dleft
                if (r_obs_sqr-(X_LEFT - r)^2)>=0
                    y_c_plus=+sqrt(r_obs_sqr-(X_LEFT - r)^2);
                    y_c_minus=-sqrt(r_obs_sqr-(X_LEFT - r)^2);
                    x_c=X_LEFT;
    
                    
                    d_vec_prime=d_max.*ones(2,1);
    
                    if (y_c_plus>=Y_BACK && y_c_plus<=Y_FRONT)
                        P=[x_c;y_c_plus];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (y_c_minus>=Y_BACK && y_c_minus<=Y_FRONT)
                        P=[x_c;y_c_minus];
                        P_C=P-C;
    
                        alfa_minus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_minus=alfa_minus*r;
                        d_vec_prime(2)=abs(d_minus);
                    end
                   
                    d_left=min(d_vec_prime);
                    d_vec(2)=d_left;
                end
                
        
                %definisco dright
                if (r_obs_sqr-(X_RIGHT - r)^2)>=0
                    y_c_plus=+sqrt(r_obs_sqr-(X_RIGHT - r)^2);
                    y_c_minus=-sqrt(r_obs_sqr-(X_RIGHT - r)^2);
                    x_c=X_RIGHT;
    
                    
                    d_vec_prime=d_max.*ones(2,1);
    
                    if (y_c_plus>=Y_BACK && y_c_plus<=Y_FRONT)
                        P=[x_c;y_c_plus];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (y_c_minus>=Y_BACK && y_c_minus<=Y_FRONT)
                        P=[x_c;y_c_minus];
                        P_C=P-C;
    
                        alfa_minus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_minus=alfa_minus*r;
                        d_vec_prime(2)=abs(d_minus);
                    end
                    
                    d_right=min(d_vec_prime);
                    d_vec(3)=d_right;
                end
                
                d_obs=min(d_vec);

                if d_obs<d
                    d=d_obs; 
                    a=d/r;
                end
            end
        
        end
    end
    dist=d;

end


function [x_p1, y_p1, theta_p1] = model_evolution(pose, v, w, dt)
    % Input:
    % pose - un vettore [x, y, theta] che rappresenta la posa attuale
    % v - velocità lineare
    % w - velocità angolare
    % dt - intervallo di tempo

    % Estrai i valori della posa attuale
    x = pose(1);
    y = pose(2);
    theta = pose(3);

    % Calcolo dei nuovi valori
    if w ~= 0
        % Caso con velocità angolare non nulla
        Fx = -v / w * (sin(theta) - sin(theta + w * dt));
        Fy = v / w * (cos(theta) - cos(theta + w * dt));
    else
        % Caso con velocità angolare nulla
        Fx = v * cos(theta) * dt;
        Fy = v * sin(theta) * dt;
    end

    % Nuove coordinate
    x_p1 = x + Fx;
    y_p1 = y + Fy;
    theta_p1 = theta + w * dt;

    % Normalizzazione di theta tra -pi e pi
    theta_p1 = mod(theta_p1 + pi, 2 * pi) - pi;
end
