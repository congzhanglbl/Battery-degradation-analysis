%% Run Simulink
close all
clear
tic
%单图大小标准，
B_size1=[10 5 16 8];
B_size2=[.08 .12 .90 .84];
limit=0.2;
Eff=1.2;
for Driving_cycle_selection=1:3
    load('..\Matlab_data\Demanded power_UDDS.mat')
    load('..\Matlab_data\Demanded power_HWFET.mat')
    load('..\Matlab_data\Demanded power_US06.mat')
    if Driving_cycle_selection==1
        time=length(UDDS_power_1s);
        power_1s=UDDS_power_1s;
    elseif Driving_cycle_selection==2
        time=length(HWFET_power_1s);
        power_1s=HWFET_power_1s;
    elseif Driving_cycle_selection==3
        time=length(US06_power_1s);
        power_1s=US06_power_1s;
    end

    Current_1C = 88; % unit:A, 1C for Battery discharging 

    Current_dot8C = 0.8*Current_1C; % unit:A, 0.8C for Battery discharging 
    Current_dot5C = 0.5*Current_1C; % unit:A, 0.5C for Battery discharging 
    Current_dot3C = 0.3*Current_1C; % unit:A, 0.3C for Battery discharging 
    Current_dot2C = 0.2*Current_1C; % unit:A, 0.2C for Battery discharging 
    Current_dot17C = 0.17*Current_1C; % unit:A, 0.2C for Battery discharging 
    Current_dot1C = 0.1*Current_1C; % unit:A, 0.1C for Battery discharging/charging 
    
    if limit==0.1
        Current_limitation = Current_dot1C;
    elseif limit==0.17
        Current_limitation = Current_dot17C;
    elseif limit==0.2
        Current_limitation = Current_dot2C;
    elseif limit==0.3
        Current_limitation = Current_dot3C;
    elseif limit==0.5
        Current_limitation = Current_dot5C;
    elseif limit==0.8
        Current_limitation = Current_dot8C;
    end
    SC_numbers=113;
    Cap_cell=2000;
    Vol_cell=2.7;

    V_C_100 = 356; % Capacitor voltage when capacitor is 100%
    V_C_95 = 347;  % Capacitor voltage when capacitor is 95%
    V_C_75 = 308.3;% Capacitor voltage when capacitor is 75%
    V_C_50 = 252;  % Capacitor voltage when capacitor is 50%
    V_C_25 = 178;  % Capacitor voltage when capacitor is 25%, the lower limitation for capacitor

    V_C_100 = 305; % Capacitor voltage when capacitor is 100%
    V_C_95 = 297;  % Capacitor voltage when capacitor is 95%
    V_C_75 = 264;% Capacitor voltage when capacitor is 75%
    V_C_50 = 215.6;  % Capacitor voltage when capacitor is 50%
    V_C_25 = 152.5;  % Capacitor voltage when capacitor is 25%, the lower limitation for capacitor

    [tout_Act] = sim('HESS_SC_Active.slx',time);
    if Driving_cycle_selection==1
        Battery_current_Act_UDDS=Battery_current_Act;
        Capa_SOC_Act_UDDS = Capa_SOC_Act;
    elseif Driving_cycle_selection==2
        Battery_current_Act_HWFET=Battery_current_Act;
        Capa_SOC_Act_HWFET = Capa_SOC_Act;
    elseif Driving_cycle_selection==3
        Battery_current_Act_US06=Battery_current_Act;
        Capa_SOC_Act_US06 = Capa_SOC_Act;
    end
        
    [tout_Solely] = sim('HESS_Battery_solely.slx',time);
    if Driving_cycle_selection==1
        Battery_current_solely_UDDS=Battery_current_solely;
    elseif Driving_cycle_selection==2
        Battery_current_solely_HWFET=Battery_current_solely;
    elseif Driving_cycle_selection==3
        Battery_current_solely_US06=Battery_current_solely;
    end
    
    [tout_Passive] = sim('HESS_Passive_structure.slx',time);
    if Driving_cycle_selection==1
        Battery_current_passive_UDDS=Battery_current_passive;
    elseif Driving_cycle_selection==2
        Battery_current_passive_HWFET=Battery_current_passive;
    elseif Driving_cycle_selection==3
        Battery_current_passive_US06=Battery_current_passive;
    end
    
end

% Store results
% save ALL_results.mat
if limit==0.1
    save BatteryCurrents_dot1C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
elseif limit==0.17
    save BatteryCurrents_dot17C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
elseif limit==0.2
    save BatteryCurrents_dot2C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
elseif limit==0.3
    save BatteryCurrents_dot3C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
elseif limit==0.5
    save BatteryCurrents_dot5C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
elseif limit==0.8
    save BatteryCurrents_dot8C_2.mat Battery_current_solely_UDDS Battery_current_solely_HWFET Battery_current_solely_US06 Battery_current_passive_UDDS Battery_current_passive_HWFET Battery_current_passive_US06 Battery_current_Act_UDDS Battery_current_Act_HWFET Battery_current_Act_US06 Capa_SOC_Act_UDDS Capa_SOC_Act_HWFET Capa_SOC_Act_US06
end
figure(1)
y=plot(1:length(UDDS_power_1s)+1,Battery_current_solely_UDDS,'r');
set(y,'linewidth',1.3)
hold on
y=plot(1:length(UDDS_power_1s)+1,Battery_current_Act_UDDS,'b');
set(y,'linewidth',1.8)
%plot(1:length(UDDS_power_1s)+1,Battery_current_passive_UDDS,'g')
Average_power =3.7318/Eff; % Average power on US06, unit: kw
Average_current=Average_power*1000/270;
y=plot([0, length(UDDS_power_1s)+1],[Average_current,Average_current],'g');
set(y,'linewidth',1.8)
legend('Battery solely on UDDS','Optimal battery/SC on UDDS','Infinite SC on UDDS')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(UDDS_power_1s)+1],'xTick',[0:100:length(UDDS_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-35,120],'yTick',[-40:20:120]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例


figure(2)
y=plot(1:length(HWFET_power_1s)+1,Battery_current_solely_HWFET,'r');
set(y,'linewidth',1.3)
hold on
y=plot(1:length(HWFET_power_1s)+1,Battery_current_Act_HWFET,'b');
set(y,'linewidth',1.8)
%plot(1:length(HWFET_power_1s)+1,Battery_current_passive_HWFET,'k')
Average_power =6.3765/Eff; % Average power on US06, unit: kw
Average_current=Average_power*1000/270;
y=plot([0, length(UDDS_power_1s)+1],[Average_current,Average_current],'g');
set(y,'linewidth',1.8)
legend('Battery solely on HWFET','Optimal battery/SC on HWFET','Infinite SC on HWFET')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(HWFET_power_1s)+1],'xTick',[0:100:length(HWFET_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-45,100],'yTick',[-50:10:100]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

figure(3)
y=plot(1:length(US06_power_1s)+1,Battery_current_solely_US06,'r');
set(y,'linewidth',1.3)
hold on
y=plot(1:length(US06_power_1s)+1,Battery_current_Act_US06,'b');
set(y,'linewidth',1.8)
%plot(1:length(US06_power_1s)+1,Battery_current_passive_US06,'k')
Average_power =13.3695/Eff; % Average power on US06, unit: kw
Average_current=Average_power*1000/270;
y=plot([0, length(UDDS_power_1s)+1],[Average_current,Average_current],'g');
set(y,'linewidth',1.8)
legend('Battery solely on US06','Optimal battery/SC on US06','Infinite SC on US06')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(US06_power_1s)+1],'xTick',[0:100:length(US06_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-80,270],'yTick',[-80:40:270]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

figure(4)
plot(Capa_SOC_Act_UDDS)
hold on
plot(Capa_SOC_Act_HWFET,'r')
plot(Capa_SOC_Act_US06,'k')
legend('Act_UDDS','Act_HWFET','Act_US06','location','southeast')
xlabel('Time/s')
ylabel('SC SOC/(A)')
set(gca,'xlim',[0,length(UDDS_power_1s)+1],'xTick',[0:100:length(UDDS_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[0,1],'yTick',[0:0.1:1]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

toc