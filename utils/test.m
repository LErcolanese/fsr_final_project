range_test = [21, sqrt(2), 21, 21, 21]; % Distanze degli ostacoli
angle_test = linspace(-pi/2, pi/2, length(range_test)); % Angoli corrispondenti
v_test = 1; % Velocità lineare
w_test = 1; % Velocità angolare

[dist_test, a_test] = dist(v_test, w_test, range_test, 20);
fprintf('Distance: %.2f, Angle: %.2f\n', dist_test, a_test);

%% --- Utility function ---
function [dist, a]=dist(v,w,range,d_max)
    

    
    % calcolo della funzione dist
    % dist=d_coll/d_max, d_coll = min (d_front, d_back, d_right, d_left)
    % dist dipende da v,w e dal punto in cui si trova l'ostacolo
    % dist è la minima tra le distanze dagli ostacoli 
    angle=linspace(-pi/2, pi/2, length(range));
    d=d_max; %valore 
    a=0;
    
    Y_FRONT= 0;
    Y_BACK=-1.6;
    X_LEFT=-.6;
    X_RIGHT=.6;
    
    if (v==0)
       d=d_max;
    %se w=0, sto andando dritto con velocità v
    elseif (w==0)
        for i = 1: length(range) %prendo un ostacolo
            x_obs=-range(i)*sin(angle(i));
    
            if range(i)<d_max && (x_obs>X_LEFT && x_obs<X_RIGHT)
    
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
    
            if range(i)<d_max
    
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
    
                    if (x_c_plus>X_LEFT && x_c_plus<X_RIGHT)
                        P=[x_c_plus;y_c];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (x_c_minus>X_LEFT && x_c_minus<X_RIGHT)
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
    
                    if (y_c_plus>Y_BACK && y_c_plus<Y_FRONT)
                        P=[x_c;y_c_plus];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (y_c_minus>Y_BACK && y_c_minus<Y_FRONT)
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
    
                    if (y_c_plus>Y_BACK && y_c_plus<Y_FRONT)
                        P=[x_c;y_c_plus];
                        P_C=P-C;
    
                        alfa_plus=acos(dot(P_C,O_C)/(norm(O_C)*norm(P_C)));
                        d_plus=alfa_plus*r;
                        d_vec_prime(1)=abs(d_plus);
                    end
                    if (y_c_minus>Y_BACK && y_c_minus<Y_FRONT)
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