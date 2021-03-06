tic
clear
close all
%clc

SOC_step = 0.01;  % SC SOC step
SOC_SC_min = 0.25; % 0.25;
SOC_SC_end = 0.81; % Supposing the end SOC for SC

ConsideringEff=1; 
% 1: Represent the driving efficiency and braking efficiency is considered.
%    Driving efficiency is 1.15; The braking efficiency is 0.20;
% 0: No efficiency considered
if ConsideringEff==0;
    load Demanded_power_US06.mat
elseif ConsideringEff==1
    load Demanded_power_US06_eff_1.15_0.2.mat  
end

if SOC_step ==0.05
    SOC_L_j=5;  
    SOC_H_j=20;
   % SOC_step = 0.05;
    middle = 16;  % Represent imitial SOC at the beginning, 5-20, 10 represents 50% for SC SOC
elseif SOC_step ==0.01
    if SOC_SC_min==0.25
        SOC_L_j=25;  
        SOC_H_j=100;
       % SOC_step = 0.01;
        middle = 80;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    elseif SOC_SC_min==0.26
        SOC_L_j=26;  
        SOC_H_j=100;
       % SOC_step = 0.01;
        middle = 80;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    end

elseif SOC_step ==0.005
    if SOC_SC_min==0.25
        SOC_L_j=50;  
        SOC_H_j=200;
      %  SOC_step = 0.01;
        middle = 160;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    elseif SOC_SC_min==0.26
        SOC_L_j=52;  
        SOC_H_j=200;
      %  SOC_step = 0.01;
        middle = 160;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    end
elseif SOC_step ==0.001
    if SOC_SC_min==0.25
        SOC_L_j=250;  
        SOC_H_j=1000;
      %  SOC_step = 0.01;
        middle = 800;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    elseif SOC_SC_min==0.26
        SOC_L_j=260;  
        SOC_H_j=1000;
      %  SOC_step = 0.01;
        middle = 800;   % Represent imitial SOC at the beginning, 25-100, 50 represents 50% for SC SOC
    end        
end

Power_vehicle_vector = US06_power_1s;
Cells= 76; % The number of SC cells

SOC_SC_max = 1;

SC_Cell_Rated_Energy_wh = 0.5*2000*2.7*2.7/3600; %2.025; %unit:wh
SC_Cell_Usable_Energy_wh = SC_Cell_Rated_Energy_wh*0.75; %unit:wh
SC_Cell_Max_Charging_Power_kw = 2.571; % unit: kW
SC_Cell_Max_Discharging_Power_kw = 1.875; % unit: kW

SCs_Rated_Energy_kWs = SC_Cell_Rated_Energy_wh * Cells*3.6;
SCs_Max_Charging_Power_kw = SC_Cell_Max_Charging_Power_kw * Cells;
SCs_Max_Discharging_Power_kw = SC_Cell_Max_Discharging_Power_kw * Cells;

SC_Range_Up = SCs_Max_Charging_Power_kw *3.6 / (SC_Cell_Rated_Energy_wh*Cells);
SC_Range_Down = SCs_Max_Discharging_Power_kw *3.6 / (SC_Cell_Rated_Energy_wh*Cells);

Q_a= 8.889e-6;
Q_b=-5.289e-3;
Q_c= 0.787;
Q_d= -6.667e-3;
Q_e= 2.35;
%Q_f= 14876;
Q_f= 8720;
Q_Ea= 24500;
Q_R= 8.314;
Q_T=293.15;  % 20 centigrade
Rated_voltage=370; % 270.6;
Ah_battery = 65; % unit:Ah
Count_parallel = 2;
Count_record = 0;

%startstage = 580;
endstage = 1; % Represent the final column 1, represent the total driving cycle
for i = length(Power_vehicle_vector):-1:endstage %1  % Stage number, from the backward to the front
    if i==length(Power_vehicle_vector)
        
        for j=SOC_L_j:SOC_H_j
            Record.Route_SOC(j,i)=SOC_SC_end;    % Record the SOC route, unit: 1; Range: 0-1
            Record.Degradation(j,i)=0;
            Record.Route_Power(j,i)=0;    % Record the battery power, unit: kW 
            Record_tem = Record;
        end
    else
        for j=SOC_L_j:SOC_H_j  % At 603 stage, every row
            tem_degra=100;
            tem_SOC=2;
            for count= SOC_L_j:SOC_H_j % At 604 stage, every row
                SOC_Next  = Record.Route_SOC(count,i+1);
                %if i==591 && j==100 && Record.Route_SOC(count,i+1)==0.5
                %    keyboard
                %end
                Power_Bat = Power_vehicle_vector(i,2) - (j*SOC_step - SOC_Next)*SCs_Rated_Energy_kWs;
                Deg_Bat_rate = abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Power_Bat*1000/Rated_voltage)/Ah_battery)*Power_Bat*1000/Rated_voltage/1000/3.6/Count_parallel);
                %fprintf('Next SC SOC is %.3f\n',SOC_Next);
                %fprintf('Current SC SOC is %.3f\n',j*SOC_step);
                %fprintf('count = \n',count);
                Deg_Bat = Deg_Bat_rate + Record.Degradation(count,i+1);
                if Deg_Bat>10
                    keyboard
                end
                if Deg_Bat < tem_degra
                    tem_SOC = j*SOC_step;
                    tem_degra = Deg_Bat; % Keep the smallest battery degradation                    
                    tem_Power_Bat = Power_Bat;

                    tem_SOC_vector = Record.Route_SOC(count,i+1:end);
                    tem_degradation_vector = Record.Degradation(count,i+1:end);
                    tem_Power_Bat_vector = Record.Route_Power(count,i+1:end);
                end

                Count_record = Count_record + 1;
            end
            %   if i==564 && j*SOC_step == 0.8
             %      keyboard
             %  end
            Record_tem.Route_SOC(j,i+1:end) = tem_SOC_vector;     % Record the SOC route, unit: 1; Range: 0-1
            Record_tem.Route_SOC(j,i) = tem_SOC;
            
            Record_tem.Degradation(j,i+1:end) = tem_degradation_vector; % Record the battery degradation, unit: %
            Record_tem.Degradation(j,i) = tem_degra;
            
            Record_tem.Route_Power(j,i+1:end) = tem_Power_Bat_vector;    % Record the battery power route, unit: kW 
            Record_tem.Route_Power(j,i)= tem_Power_Bat;   
        end
        Record = Record_tem;
    end
end
Count_record

%% Calculate the battery solely degradation
deg_solely=0;
energy=0;
for ii= 1: length(Power_vehicle_vector(:,2))
    degradation_rate= abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Power_vehicle_vector(ii,2)*1000/Rated_voltage)/Ah_battery).*Power_vehicle_vector(ii,2)*1000/Rated_voltage/1000/3.6/Count_parallel);
    deg_solely=deg_solely+degradation_rate;
    energy=energy + Power_vehicle_vector(ii,2);
    battery_degradation(ii,1) = deg_solely; % Column=1, represent the battery solely
end
fprintf('Battery solely degradation is %.5f \n',deg_solely);

%% Calculate the average battery degradation
average_power = energy/length(Power_vehicle_vector(:,2));
degradation_rate= abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(average_power*1000/Rated_voltage)/Ah_battery).*average_power*1000/Rated_voltage/1000/3.6/Count_parallel);
deg_Infinie = degradation_rate*length(Power_vehicle_vector(:,2));
fprintf('Infinite SC degradation is %.5f \n',deg_Infinie);
x=1: length(Power_vehicle_vector(:,2));
battery_degradation(:,2) = degradation_rate*x; % Column=2, represent the Infinite
%% Calculate the battery degradation by using DP opptimization
deg_dp=0;
energy=0;
for ii= 1: length(Power_vehicle_vector(:,2))
    degradation_rate= abs((Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*abs(Record.Route_Power(middle,ii)*1000/Rated_voltage)/Ah_battery).*Record.Route_Power(middle,ii)*1000/Rated_voltage/1000/3.6/Count_parallel);
    deg_dp=deg_dp+degradation_rate;
    energy=energy + Power_vehicle_vector(ii,2);
    battery_degradation(ii,3) = deg_dp; % Column=3, represent the DP
end
fprintf('Dynamic programming battery degradation is %.8f \n',deg_dp);
fprintf('Dynamic programming battery degradation is %.8f (From matrix)\n',Record.Degradation(middle,endstage));
%% Compare the battery power in different cases
figure(1)
hold on
plot(Record.Route_Power(middle,:),'b')
plot(Power_vehicle_vector(:,end),'r')
legend('Dynamic Programming optimization','Demanded vehicle power(battery solely)')
%% Compare the battery degradation in different cases
figure(2)
hold on
h=plot(x, battery_degradation(:,1),'r');  % battery solely
g=plot(x, battery_degradation(:,2),'g');  % Infinite
f=plot(x, battery_degradation(:,3),'b');
title('Battery degradation')
xlabel('Time/s')
ylabel('Battery degradation rate/%')
set(gca,'xlim',[0,length(Power_vehicle_vector)],'xTick',[0:100:length(Power_vehicle_vector)]); %�趨��߲�x���귶Χ
set(g,'linewidth',2); %�����ߴ�0.5��
set(g,'linestyle','-','color','g');        
set(h,'linewidth',2); %�����ߴ�0.5��
set(h,'linestyle','-','color','r');
set(f,'linewidth',2); %�����ߴ�0.5��
set(f,'linestyle','-','color','b');
legend('Battery solely','Infinite SC','Dynamic Programming optimization','location','north')   

%% Plot the SC SOC
figure(3)
hold on
hh=plot(x, Record.Route_SOC(middle,:),'b');
set(hh,'linewidth',2)
legend('SC SOC','location','northeast')

%% Looking for the largest delta SOC
delta_largest = 0;
for ii= endstage: length(Power_vehicle_vector(:,2))-1
    delta = Record.Route_SOC(middle,ii+1) - Record.Route_SOC(middle,ii);
    if delta_largest < delta
        delta_largest = delta;
        Index_ii = ii;
    end
end
fprintf('The largest delta SOC is %.2f   when the ii= %d \n',delta_largest, Index_ii);
fprintf('FOR DP optimization, the realization percentage is %.3f %% <<<< \n',100*(battery_degradation(end,1)-battery_degradation(end,3)) / (battery_degradation(end,1)-battery_degradation(end,2)));
fprintf('Essential information: SOC_step = %.3f;  SOC_SC_min = %.2f;  middle = %.1f  at SOC= %.3f; \n',SOC_step,SOC_SC_min, middle, middle*SOC_step);

toc