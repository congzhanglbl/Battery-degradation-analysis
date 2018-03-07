Q_a= 8.889e-6;
Q_b=-5.289e-3;
Q_c= 0.787;
Q_d= -6.667e-3;
Q_e= 2.35;
Q_f= 8720;
Q_Ea= 24500;
Q_R= 8.314;
Q_T=293.15;  % 20 centigrade

Rated_voltage_SC=2.7;
Rated_voltage_Bat=370;
Ah_battery = 65; % unit:Ah
Count_parallel_Bat= 2; %Battery is parallel 
Rated_energy_Bat=Rated_voltage_Bat*Ah_battery/1000; % Battery rated energy, unit kwh
Rated_energy_SC=0.5*2000*Rated_voltage_SC*Rated_voltage_SC*Cells/3600000; % SC rated energy, unit kwh

%% Initial the Battery and SC

Power_SC_assist_eff = Power_kw_average/Rated_energy_Bat;
Power_SC_assist = Rated_energy_Bat * Power_SC_assist_eff;

SOC_lowlimitation =  0.4; %0.25;
SOC_Chargestop =  0.75; %0.75;
for ii=1:length(Power_kw(:,2))
    if ii==1
        SOC_Bat = SOC_Bat_init;
        SOC_SC = SOC_SC_init;
        Power_Bat_kw(1,2) =0; 
        Record.Bat.power(1,1) = 0; 
        Record.SC.power(1,1) = 0; 
        Record.Bat.SOC(1,1) = SOC_Bat_init; 
        Record.SC.SOC(1,1) = SOC_SC_init;         
        cycleLoss(ii,5)=0;
        cycleLoss(ii,6)=0; %Total battery degradation(Simple control strategy) 
    elseif Power_kw(ii,2)>=0  % Driving mode
        if Power_kw(ii,2) >= Power_SC_assist  % Demanded power is higher than a constant
            if SOC_SC > 0.5   % SC has enough energy
                Power_kw_SC  = Power_kw(ii,2)-Power_SC_assist;
                Power_kw_Bat = Power_kw(ii,2)-Power_kw_SC;
            elseif SOC_SC > SOC_lowlimitation   % SC has a few energy
                Power_kw_SC  = 0.2* (Power_kw(ii,2)-Power_SC_assist);
                Power_kw_Bat = Power_kw(ii,2)-Power_kw_SC;                                
            else   % SC has no available energy
                Power_kw_SC = 0; 
                Power_kw_Bat = Power_kw(ii,2);
            end

        else                               % Demanded power is lower than a constant
            if SOC_SC >= SOC_Chargestop       % SC has enough energy
                Power_kw_SC  = 0;
                Power_kw_Bat = Power_kw(ii,2);
            elseif SOC_SC > 0.5     % SC has a few energy
                Power_kw_SC  = min(0.2* (Power_kw(ii,2)-Power_SC_assist),-0.2*Power_SC_assist);
                Power_kw_Bat = Power_kw(ii,2)-Power_kw_SC;                                
            else                    % SC has no available energy
                Power_kw_SC =  min(0.5* (Power_kw(ii,2)-Power_SC_assist),-0.5*Power_SC_assist);
                Power_kw_Bat = Power_kw(ii,2)-Power_kw_SC; 
            end
        end
        SOC_Bat= SOC_Bat - Power_kw_Bat*timestep/3600/Rated_energy_Bat;
        SOC_SC = SOC_SC - Power_kw_SC*timestep/3600/Rated_energy_SC;
        Power_Bat_kw(ii,2) = Power_kw_Bat;
        Record.Bat.power(ii,1) = Power_kw_Bat;
        Record.SC.power(ii,1) = Power_kw_SC; 
        Record.Bat.SOC(ii,1) = SOC_Bat; 
        Record.SC.SOC(ii,1) = SOC_SC;        
        Current(ii,2)=Power_Bat_kw(ii,2)*1000/Rated_voltage_Bat; % Calculate the demanded current based on the voltage and power
        cycleLoss(ii,5) = abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Current(ii,2))/Ah_battery)*Current(ii,2)/1000/3.6/Count_parallel_Bat);
        cycleLoss(ii,6) = cycleLoss(ii-1,6) + cycleLoss(ii,5); %Total battery degradation(Optimal)        
    elseif Power_kw(ii,2)< 0  % Braking mode
        if SOC_SC >= 0.95
            Power_kw_SC  = 0;
            Power_kw_Bat = Power_kw(ii,2);                            
        elseif SOC_SC > SOC_Chargestop
            Power_kw_SC  = Power_kw(ii,2);
            Power_kw_Bat = 0; 
        else
            Power_kw_SC  = Power_kw(ii,2)-0.5*Power_SC_assist;
            Power_kw_Bat = Power_kw(ii,2) - Power_kw_SC; 
        end

        SOC_Bat= SOC_Bat - Power_kw_Bat*timestep/3600/Rated_energy_Bat;
        SOC_SC = SOC_SC - Power_kw_SC*timestep/3600/Rated_energy_SC;
        Power_Bat_kw(ii,2) = Power_kw_Bat;
        Record.Bat.power(ii,1) = Power_kw_Bat; 
        Record.SC.power(ii,1) = Power_kw_SC; 
        Record.Bat.SOC(ii,1) = SOC_Bat; 
        Record.SC.SOC(ii,1) = SOC_SC; 
        
        Current(ii,2)=Power_Bat_kw(ii,2)*1000/Rated_voltage_Bat; % Calculate the demanded current based on the voltage and power
        cycleLoss(ii,5) = abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Current(ii,2))/Ah_battery)*Current(ii,2)/1000/3.6/Count_parallel_Bat);
        cycleLoss(ii,6) = cycleLoss(ii-1,6) + cycleLoss(ii,5); %Total battery degradation(Optimal)        
    end
    % cycleLoss
    % ** column 1-4 is existed in infinite SC and battery solely situations **
    % Column 1: time
    % Column 2: Total battery degradation £¨In theory£©
    % Column 3: Degradation rate(battery solely)
    % Column 4: Total battery degradation(battery solely)
    % Column 5: Degradation rate(Optimal)
    % Column 6: Total battery degradation(Optimal)
    
    %if SOC_Bat <0.1 || SOC_Bat>1.2
    %   display('PAY ATTENTION: Battery SOC is not in the noramal range' ) 
    %   return;
    %end
end



