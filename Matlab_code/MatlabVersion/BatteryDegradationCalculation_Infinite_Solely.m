Q_a= 8.889e-6;
Q_b=-5.289e-3;
Q_c= 0.787;
Q_d= -6.667e-3;
Q_e= 2.35;
Q_f= 8720;
Q_Ea= 24500;
Q_R= 8.314;
Q_T=293.15;  % 20 centigrade
Rated_voltage=370;
K_cal_cal=1.0;
Ah_battery = 65; % unit:Ah
Count_parallel= 2; %Battery is parallel 

% Calculate the average power
Energy = 0;
for ii=1:length(Power_kw(:,2))
    Energy = Energy + Power_kw(ii,2);
end
Power_kw_average = Energy/length(Power_kw(:,2));
Current_average=Power_kw_average*1000/Rated_voltage; % Calculate the average demanded current based on the voltage and power
cycleLoss_rate_average = abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Current_average)/Ah_battery)*Current_average/1000/3.6/Count_parallel);

% Calculate the instantaneous battery cycle degradation
for ii=1:length(Power_kw(:,2))
    Current(ii,1)=Power_kw(ii,1);
    Current(ii,2)=Power_kw(ii,2)*1000/Rated_voltage; % Calculate the demanded current based on the voltage and power
    cycleLoss(ii,1) = Power_kw(ii,1); 
    % cycleLoss
    % Column 1: time
    % Column 2: Total battery degradation £¨In theory£©
    % Column 3: Degradation rate(battery solely)
    % Column 4: Total battery degradation(battery solely)
    cycleLoss(ii,3) = abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Current(ii,2))/Ah_battery)*Current(ii,2)/1000/3.6/Count_parallel);

    if ii==1
        cycleLoss(ii,2)=0; %Total battery degradation(In theory) 
        cycleLoss(ii,4)=0; %Total battery degradation(battery solely) 
    else
        cycleLoss(ii,2) = cycleLoss(ii-1,2) + cycleLoss_rate_average;%Total battery degradation(In theory)         
        cycleLoss(ii,4) = cycleLoss(ii-1,4) + cycleLoss(ii,3); %Total battery degradation(battery solely) 
    end

end