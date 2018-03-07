tic
clear
close all
B_size1= [10 5 16 8];
B_size2=[.08 .12 .90 .84];

udds_includes=1;

%Q_a= 8.61e-6;
%Q_b=-5.13e-3;
%Q_c= 0.763;
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
years=10;
K_cal_cal=0.8;
K_cal=1;
K_cyc=1;
Deg_limit=30;
Rated_voltage=295;
Eff=1.18;
%% ------------------------------------Calculate the battery calendar degradation for ten years------------------------------------
days=1:365*years;
calendarLoss(:,1)=days;
for t=1:years*365
    calendarLoss(t,2) =Q_f*t^0.5*exp(-1*Q_Ea/Q_R/Q_T)*K_cal_cal;
    %vehicle.batteryLoss['calendarLoss'][-1] +1/3600/24*0.5*coefLoss['f']*exp(-coefLoss['E']/coefLoss['R']/(temperature[i]+273.15))*((i/3600/24)**(-0.5))
end
figure(1)
plot(calendarLoss(:,1),calendarLoss(:,2))
title('Calendar degradation for battery')
xlabel('Days')
ylabel('Calendar degradation percent/%')
grid

for collect_year=1:10
    collect_days=365*collect_year;
    calendar_degradation_years(1,collect_year)=calendarLoss(collect_days,2);
    
end
degradation(1,:)=calendar_degradation_years;

%% Begin to load the essential battery current information

%addpath(genpath('..\Matlab_data'))  % limitation current is 0.2C
%load('Battery_Current_data.mat')

%load ..\Simulink_models\BatteryCurrents_dot17C.mat   % limitation current is 0.17C
load ..\Simulink_models\BatteryCurrents_dot2C.mat   % limitation current is 0.2C
%load ..\Simulink_models\BatteryCurrents_dot5C.mat   % limitation current is 0.5C
%% ------------------------------------Calculate the battery cycle degradation on a single UDDS cycle------------------------------
%{

load('Demanded power_UDDS.mat')
cycleLoss = 0;
for ii=1:length(UDDS_power_1s(:,2))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*UDDS_power_1s(ii,2)/24)*UDDS_power_1s(ii,2)/380/3.6/2;
end
cycleLoss_UDDS=cycleLoss;
%}

cycleLoss = 0;
for ii=1:length(Battery_current_solely_UDDS(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_UDDS(ii,1)/88)*Battery_current_solely_UDDS(ii,1)/1000/3.6/2;
end
cycleLoss_UDDS_Solely=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_passive_UDDS(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_UDDS(ii,1)/88)*Battery_current_passive_UDDS(ii,1)/1000/3.6/2;
end
cycleLoss_UDDS_Passive=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_Act_UDDS(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_UDDS(ii,1)/88)*Battery_current_Act_UDDS(ii,1)/1000/3.6/2;
end
cycleLoss_UDDS_Act=cycleLoss;

Average_power_UDDS =3.7318/Eff; % Average power on UDDS, unit: kw
cycleLoss = 0;
for ii=1:length(Battery_current_Act_UDDS(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_UDDS/24)*Average_power_UDDS*1000/Rated_voltage/1000/3.6/2;
end
cycleLoss_UDDS_Average=cycleLoss;

%% ------------------------------------Calculate the battery cycle degradation on a single HWFET cycle------------------------------
%{
addpath(genpath('F:\DropBox_zhangcongok\Dropbox\PhD_Dissertation\Paper2_Configuration\Matlab_code\Matlab_data'))
% Calculate the cycle degradation on HWFET
load('Demanded power_HWFET.mat')
cycleLoss = 0;
for ii=1:length(HWFET_power_1s(:,2))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*HWFET_power_1s(ii,2)/24)*HWFET_power_1s(ii,2)/380/3.6/2;
end
cycleLoss_HWFET=cycleLoss;
%}

%load('Battery_Current_data.mat')


cycleLoss = 0;
for ii=1:length(Battery_current_solely_HWFET(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_HWFET(ii,1)/88)*Battery_current_solely_HWFET(ii,1)/1000/3.6/2;
end
cycleLoss_HWFET_Solely=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_passive_HWFET(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_HWFET(ii,1)/88)*Battery_current_passive_HWFET(ii,1)/1000/3.6/2;
end
cycleLoss_HWFET_Passive=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_Act_HWFET(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_HWFET(ii,1)/88)*Battery_current_Act_HWFET(ii,1)/1000/3.6/2;
end
cycleLoss_HWFET_Act=cycleLoss;

Average_power_HWFET =6.3765/Eff; % Average power on HWFET, unit: kw
cycleLoss = 0;
for ii=1:length(Battery_current_Act_HWFET(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_HWFET/24)*Average_power_HWFET*1000/Rated_voltage/1000/3.6/2;
end
cycleLoss_HWFET_Average=cycleLoss;

%% ------------------------------------Calculate the battery cycle degradation on a single US06 cycle------------------------------
%{
addpath(genpath('F:\DropBox_zhangcongok\Dropbox\PhD_Dissertation\Paper2_Configuration\Matlab_code\Matlab_data'))
% Calculate the cycle degradation on US06
load('Demanded power_US06.mat')
cycleLoss = 0;
for ii=1:length(US06_power_1s(:,2))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*US06_power_1s(ii,2)/24)*US06_power_1s(ii,2)/380/3.6/2;
end
cycleLoss_US06=cycleLoss;
%}

% load('Battery_Current_data.mat')

cycleLoss = 0;
for ii=1:length(Battery_current_solely_US06(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_US06(ii,1)/88)*Battery_current_solely_US06(ii,1)/1000/3.6/2;
end
cycleLoss_US06_Solely=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_passive_US06(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_US06(ii,1)/88)*Battery_current_passive_US06(ii,1)/1000/3.6/2;
end
cycleLoss_US06_Passive=cycleLoss;

cycleLoss = 0;
for ii=1:length(Battery_current_Act_US06(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_US06(ii,1)/88)*Battery_current_Act_US06(ii,1)/1000/3.6/2;
end
cycleLoss_US06_Act=cycleLoss;

Average_power_US06 =13.3695/Eff; % Average power on US06, unit: kw
cycleLoss = 0;
for ii=1:length(Battery_current_Act_US06(:,1))
    cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_US06/24)*Average_power_US06*1000/Rated_voltage/1000/3.6/2;
end
cycleLoss_US06_Average=cycleLoss;

%% ------------------------------------Calculate the battery cycle degradation on a combined urban cycle------------------------------

cycleLossPmile_UDDS_Solely=cycleLoss_UDDS_Solely/(7.45);  % degradation(%) per mile
cycleLossPmile_UDDS_Passive=cycleLoss_UDDS_Passive/(7.45);  % degradation(%) per mile
cycleLossPmile_UDDS_Act=cycleLoss_UDDS_Act/(7.45);  % degradation(%) per mile
cycleLossPmile_UDDS_Average=cycleLoss_UDDS_Average/(7.45);  % degradation(%) per mile

cycleLossPmile_HWFET_Solely=cycleLoss_HWFET_Solely/(10.25);  % degradation(%) per mile
cycleLossPmile_HWFET_Passive=cycleLoss_HWFET_Passive/(10.25);  % degradation(%) per mile
cycleLossPmile_HWFET_Act=cycleLoss_HWFET_Act/(10.25);  % degradation(%) per mile
cycleLossPmile_HWFET_Average=cycleLoss_HWFET_Average/(10.25);  % degradation(%) per mile

cycleLossPmile_Solely_combine=cycleLossPmile_UDDS_Solely*0.55+cycleLossPmile_HWFET_Solely*0.45;   % degradation(%) per mile
cycleLossPmile_Passive_combine=cycleLossPmile_UDDS_Passive*0.55+cycleLossPmile_HWFET_Passive*0.45;   % degradation(%) per mile
cycleLossPmile_Act_combine=cycleLossPmile_UDDS_Act*0.55+cycleLossPmile_HWFET_Act*0.45;   % degradation(%) per mile
cycleLossPmile_Average_combine=cycleLossPmile_UDDS_Average*0.55+cycleLossPmile_HWFET_Average*0.45;   % degradation(%) per mile

cycleLossPmile_US06_Solely=cycleLoss_US06_Solely/(8.03);  % degradation(%) per mile
cycleLossPmile_US06_Passive=cycleLoss_US06_Passive/(8.03);  % degradation(%) per mile
cycleLossPmile_US06_Act=cycleLoss_US06_Act/(8.03);  % degradation(%) per mile
cycleLossPmile_US06_Average=cycleLoss_US06_Average/(8.03);  % degradation(%) per mile

% Crear a matrix to display the results
Cyclelife_degradation_speed=[cycleLossPmile_UDDS_Solely, cycleLossPmile_HWFET_Solely,cycleLossPmile_Solely_combine,cycleLossPmile_US06_Solely;
cycleLossPmile_UDDS_Passive,cycleLossPmile_HWFET_Passive,cycleLossPmile_Passive_combine,cycleLossPmile_US06_Passive;
cycleLossPmile_UDDS_Act,cycleLossPmile_HWFET_Act,cycleLossPmile_Act_combine, cycleLossPmile_US06_Act;
(cycleLossPmile_UDDS_Solely-cycleLossPmile_UDDS_Act)/cycleLossPmile_UDDS_Solely*100,(cycleLossPmile_HWFET_Solely-cycleLossPmile_HWFET_Act)/cycleLossPmile_HWFET_Solely*100,(cycleLossPmile_Solely_combine-cycleLossPmile_Act_combine)/cycleLossPmile_Solely_combine*100, (cycleLossPmile_US06_Solely-cycleLossPmile_US06_Act)/cycleLossPmile_US06_Solely*100];

%% ======================================Calculate the cumulative battery cycle degradation on US06 cycle===============================================
%-------------------------------------- US06, Battery solely, 10 years data ------------------------------------------------
cycleLoss=[];
cycleLoss(:,1)=days;
for t=1:years*365
    if t==1
        cycleLoss(t,2)=0;
    else
        %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Solely*35;
        cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Solely*35;
    end
end

for collect_year=1:10
    collect_days=365*collect_year;
    US06_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);
    
end
degradation(5,:)=US06_degradation_years;


figure(2)
plot(cycleLoss(:,1),cycleLoss(:,2),'.r')
title('Cycle degradation for battery')
xlabel('Days')
ylabel('Degradation percent/%')
grid

figure(3)
plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.r')
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
title('Total degradation for battery')
xlabel('Days')
ylabel('Total degradation percent/%')
grid

figure(4)
h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)));
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
xlabel('Years')
ylabel('Total battery degradation percentage/%')
set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
set(gca,'ylim',[0,100],'yTick',[0:10:100]); %设定右边侧x坐标范围
set(h,'linewidth',2); %坐标线粗0.5磅
set(h,'linestyle','-','color','R');

% Looking for the time when reach the 30% degradation
for i=1:years*365   
    if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
        tem_Solely=i/365;
        break;
    end
end
A_x=tem_Solely;
record=(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2));

% -----------------------------As comparison  US06, Battery+UC, 10 years data-------------------------------------------
cycleLoss=[];
cycleLoss(:,1)=days;
for t=1:years*365
    if t==1
        cycleLoss(t,2)=0;
    else
        %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Act*35;
        cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Act*35;
    end
end


for collect_year=1:10
    collect_days=365*collect_year;
    US06_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);
    
end
degradation(6,:)=US06_degradation_years;

figure(2)
hold on
plot(cycleLoss(:,1),cycleLoss(:,2),'.b')
title('Cycle degradation for battery')
xlabel('Days')
ylabel('Degradation percent/%')


figure(3)
hold on
plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.b')
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
title('Total degradation for battery')
xlabel('Days')
ylabel('Total degradation percent/%')

figure(4)
hold on
h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)));
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
xlabel('Years')
ylabel('Total battery degradation percentage/%')
set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
set(gca,'ylim',[30,100],'yTick',[30:5:100]); %设定右边侧x坐标范围
set(h,'linewidth',2); %坐标线粗2磅
set(h,'linestyle','-','color','B');

% Looking for the time when reach the 30% degradation
for i=1:years*365   
    if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
        tem_Act=i/365;
        break;
    end
end
B_x=tem_Act;
percent=(tem_Act-tem_Solely)/tem_Solely*100;
%plot(tem_Act,100-Deg_limit,'*k')
%text(tem_Act,100-Deg_limit-3,'B','horiz','center')
%plot(tem_Solely,100-Deg_limit,'*k')
%text(tem_Solely,100-Deg_limit-3,'A','horiz','center')
%plot([0,tem_Act],[100-Deg_limit,100-Deg_limit],'-.k')
fprintf('The improved percentage is %.2f ',percent)
display('% optimal VS solely on US06')

% -------------------------------As comparison  US06, Average 10 years data-------------------------------------------
cycleLoss=[];
cycleLoss(:,1)=days;
for t=1:years*365
    if t==1
        cycleLoss(t,2)=0;
    else
        %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Average*35;
        cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Average*35;
    end
end


for collect_year=1:10
    collect_days=365*collect_year;
    Infinite_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);
    
end
degradation(7,:)=Infinite_degradation_years;

figure(2)
hold on
h=plot(cycleLoss(:,1),cycleLoss(:,2),'.g');

title('Cycle degradation for battery')
xlabel('Days')
ylabel('Degradation percent/%')
legend('Battery solely','Optimal battery/SC','Infinite SC number','location','northwest')

figure(3)
hold on
plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.g')
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
title('Total degradation for battery')
xlabel('Days')
ylabel('Total degradation percent/%')
legend('Battery solely','Optimal battery/SC','Infinite SC number','location','northwest')

figure(4)
hold on
h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)));
%loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
xlabel('Years')
ylabel('Total battery degradation percentage/%')
set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
set(gca,'ylim',[45,100],'yTick',[45:5:100]); %设定右边侧x坐标范围
set(h,'linewidth',2); %坐标线粗2磅
set(h,'linestyle','-','color','g');
legend('Battery solely on US06','Optimal battery/SC on US06','Infinite SC number on US06')
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',[.1 .12 .88 .84]);%设置xy轴在图片中占的比例


% Looking for the time when reach the 30% degradation
for i=1:years*365   
    if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
        tem_Act=i/365;
        break;
    end
end
C_x=tem_Act;
percent=(tem_Act-tem_Solely)/tem_Solely*100;
fprintf('The improved percentage is %.2f',percent)
display('% Infinite VS solely on US06')

record2=(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2));

%figure(5)
%plot(cycleLoss(:,1)/365,abs((record2-record)/record*100));

figure(6)
current_rate_standard=1;
current_rate=0:0.01:1;
Ah=100; 
%degra=(Q_a.*Q_T.*Q_T + Q_b.*Q_T + Q_c).*(exp((Q_d.*Q_T+Q_e).*current_rate).*current_rate.*Ah + exp((Q_d*Q_T+Q_e).*current_rate).*(1-current_rate)/0.95/0.92*Ah);
degra=(Q_a.*Q_T.*Q_T + Q_b.*Q_T + Q_c).*(exp((Q_d.*Q_T+Q_e).*current_rate*1.5).*current_rate.*Ah + exp((Q_d*Q_T+Q_e).*current_rate).*(1-current_rate)/0.95/0.92*Ah);

%degra=(Q_a.*Q_T.*Q_T + Q_b.*Q_T + Q_c).*exp((Q_d.*Q_T+Q_e).*current_rate).*Ah;
h=plot(current_rate,degra,'b');
set(h,'linewidth',2)
%legend('Battery degradation','location','northwest')
xlabel('电池放电倍率/C')
ylabel('电池容量衰退/%')
set(gca,'xlim',[0,1],'xTick',[0:0.1:1]); %设定左边侧x坐标范围
set(gca,'ylim',[0.040,0.080],'yTick',[0.040:0.008:0.080]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',[10 5 11 6]);%设置图片大小为7cm×5cm
set(gca,'Position',[.15 .185 .83 .79]);%设置xy轴在图片中占的比例



%% ======================================Calculate the cumulative battery cycle degradation on UDDS cycle===============================================
if udds_includes==1
    Eff=1.5;
   % ------------------------------------Calculate the battery calendar degradation for ten years------------------------------------
    days=1:365*years;
    calendarLoss(:,1)=days;
    for t=1:years*365
        calendarLoss(t,2) =Q_f*t^0.5*exp(-1*Q_Ea/Q_R/Q_T)*K_cal_cal;
        %vehicle.batteryLoss['calendarLoss'][-1] +1/3600/24*0.5*coefLoss['f']*exp(-coefLoss['E']/coefLoss['R']/(temperature[i]+273.15))*((i/3600/24)**(-0.5))
    end
    figure(1)
    plot(calendarLoss(:,1),calendarLoss(:,2))
    title('Calendar degradation for battery')
    xlabel('Days')
    ylabel('Calendar degradation percent/%')
    grid

    %% Begin to load the essential battery current information

    %addpath(genpath('..\Matlab_data'))  % limitation current is 0.2C
    %load('Battery_Current_data.mat')

    %load ..\Simulink_models\BatteryCurrents_dot5C.mat   % limitation current is 0.5C

    load ..\Simulink_models\BatteryCurrents_dot17C.mat   % limitation current is 0.17C
    %% ------------------------------------Calculate the battery cycle degradation on a single UDDS cycle------------------------------
    %{
    %{

    load('Demanded power_UDDS.mat')
    cycleLoss = 0;
    for ii=1:length(UDDS_power_1s(:,2))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*UDDS_power_1s(ii,2)/24)*UDDS_power_1s(ii,2)/380/3.6/2;
    end
    cycleLoss_UDDS=cycleLoss;
    %}

    cycleLoss = 0;
    for ii=1:length(Battery_current_solely_UDDS(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_UDDS(ii,1)/88)*Battery_current_solely_UDDS(ii,1)/1000/3.6/2;
        cycleLoss_rate(ii,1) = (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_UDDS(ii,1)/88)*Battery_current_solely_UDDS(ii,1)/1000/3.6/2;
    end
    cycleLoss_UDDS_Solely=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_passive_UDDS(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_UDDS(ii,1)/88)*Battery_current_passive_UDDS(ii,1)/1000/3.6/2;
    end
    cycleLoss_UDDS_Passive=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_UDDS(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_UDDS(ii,1)/88)*Battery_current_Act_UDDS(ii,1)/1000/3.6/2;
    end
    cycleLoss_UDDS_Act=cycleLoss;

    Average_power_UDDS =3.7318/Eff; % Average power on UDDS, unit: kw
    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_UDDS(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_UDDS/24)*Average_power_UDDS*1000/Rated_voltage/1000/3.6/2;
    end
    cycleLoss_UDDS_Average=cycleLoss;

    %% ------------------------------------Calculate the battery cycle degradation on a single HWFET cycle------------------------------
    %{
    addpath(genpath('F:\DropBox_zhangcongok\Dropbox\PhD_Dissertation\Paper2_Configuration\Matlab_code\Matlab_data'))
    % Calculate the cycle degradation on HWFET
    load('Demanded power_HWFET.mat')
    cycleLoss = 0;
    for ii=1:length(HWFET_power_1s(:,2))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*HWFET_power_1s(ii,2)/24)*HWFET_power_1s(ii,2)/380/3.6/2;
    end
    cycleLoss_HWFET=cycleLoss;
    %}

    %load('Battery_Current_data.mat')


    cycleLoss = 0;
    for ii=1:length(Battery_current_solely_HWFET(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_HWFET(ii,1)/88)*Battery_current_solely_HWFET(ii,1)/1000/3.6/2;
    end
    cycleLoss_HWFET_Solely=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_passive_HWFET(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_HWFET(ii,1)/88)*Battery_current_passive_HWFET(ii,1)/1000/3.6/2;
    end
    cycleLoss_HWFET_Passive=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_HWFET(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_HWFET(ii,1)/88)*Battery_current_Act_HWFET(ii,1)/1000/3.6/2;
    end
    cycleLoss_HWFET_Act=cycleLoss;

    Average_power_HWFET =6.3765/Eff; % Average power on HWFET, unit: kw
    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_HWFET(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_HWFET/24)*Average_power_HWFET*1000/Rated_voltage/1000/3.6/2;
    end
    cycleLoss_HWFET_Average=cycleLoss;

    %% ------------------------------------Calculate the battery cycle degradation on a single US06 cycle------------------------------
    %{
    addpath(genpath('F:\DropBox_zhangcongok\Dropbox\PhD_Dissertation\Paper2_Configuration\Matlab_code\Matlab_data'))
    % Calculate the cycle degradation on US06
    load('Demanded power_US06.mat')
    cycleLoss = 0;
    for ii=1:length(US06_power_1s(:,2))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*US06_power_1s(ii,2)/24)*US06_power_1s(ii,2)/380/3.6/2;
    end
    cycleLoss_US06=cycleLoss;
    %}

    % load('Battery_Current_data.mat')

    cycleLoss = 0;
    for ii=1:length(Battery_current_solely_US06(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_solely_US06(ii,1)/88)*Battery_current_solely_US06(ii,1)/1000/3.6/2;
    end
    cycleLoss_US06_Solely=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_passive_US06(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_passive_US06(ii,1)/88)*Battery_current_passive_US06(ii,1)/1000/3.6/2;
    end
    cycleLoss_US06_Passive=cycleLoss;

    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_US06(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Battery_current_Act_US06(ii,1)/88)*Battery_current_Act_US06(ii,1)/1000/3.6/2;
    end
    cycleLoss_US06_Act=cycleLoss;

    Average_power_US06 =13.3695/Eff; % Average power on US06, unit: kw
    cycleLoss = 0;
    for ii=1:length(Battery_current_Act_US06(:,1))
        cycleLoss = cycleLoss + (Q_a*Q_T*Q_T + Q_b*Q_T + Q_c)*exp((Q_d*Q_T+Q_e)*Average_power_US06/24)*Average_power_US06*1000/Rated_voltage/1000/3.6/2;
    end
    cycleLoss_US06_Average=cycleLoss;

    %% ------------------------------------Calculate the battery cycle degradation on a combined urban cycle------------------------------

    cycleLossPmile_UDDS_Solely=cycleLoss_UDDS_Solely/(7.45);  % degradation(%) per mile
    cycleLossPmile_UDDS_Passive=cycleLoss_UDDS_Passive/(7.45);  % degradation(%) per mile
    cycleLossPmile_UDDS_Act=cycleLoss_UDDS_Act/(7.45);  % degradation(%) per mile
    cycleLossPmile_UDDS_Average=cycleLoss_UDDS_Average/(7.45);  % degradation(%) per mile

    cycleLossPmile_HWFET_Solely=cycleLoss_HWFET_Solely/(10.25);  % degradation(%) per mile
    cycleLossPmile_HWFET_Passive=cycleLoss_HWFET_Passive/(10.25);  % degradation(%) per mile
    cycleLossPmile_HWFET_Act=cycleLoss_HWFET_Act/(10.25);  % degradation(%) per mile
    cycleLossPmile_HWFET_Average=cycleLoss_HWFET_Average/(10.25);  % degradation(%) per mile

    cycleLossPmile_Solely_combine=cycleLossPmile_UDDS_Solely*0.55+cycleLossPmile_HWFET_Solely*0.45;   % degradation(%) per mile
    cycleLossPmile_Passive_combine=cycleLossPmile_UDDS_Passive*0.55+cycleLossPmile_HWFET_Passive*0.45;   % degradation(%) per mile
    cycleLossPmile_Act_combine=cycleLossPmile_UDDS_Act*0.55+cycleLossPmile_HWFET_Act*0.45;   % degradation(%) per mile
    cycleLossPmile_Average_combine=cycleLossPmile_UDDS_Average*0.55+cycleLossPmile_HWFET_Average*0.45;   % degradation(%) per mile

    cycleLossPmile_US06_Solely=cycleLoss_US06_Solely/(8.03);  % degradation(%) per mile
    cycleLossPmile_US06_Passive=cycleLoss_US06_Passive/(8.03);  % degradation(%) per mile
    cycleLossPmile_US06_Act=cycleLoss_US06_Act/(8.03);  % degradation(%) per mile
    cycleLossPmile_US06_Average=cycleLoss_US06_Average/(8.03);  % degradation(%) per mile

    % Crear a matrix to display the results
    Cyclelife_degradation_speed=[cycleLossPmile_UDDS_Solely, cycleLossPmile_HWFET_Solely,cycleLossPmile_Solely_combine,cycleLossPmile_US06_Solely;
    cycleLossPmile_UDDS_Passive,cycleLossPmile_HWFET_Passive,cycleLossPmile_Passive_combine,cycleLossPmile_US06_Passive;
    cycleLossPmile_UDDS_Act,cycleLossPmile_HWFET_Act,cycleLossPmile_Act_combine, cycleLossPmile_US06_Act;
    (cycleLossPmile_UDDS_Solely-cycleLossPmile_UDDS_Act)/cycleLossPmile_UDDS_Solely*100,(cycleLossPmile_HWFET_Solely-cycleLossPmile_HWFET_Act)/cycleLossPmile_HWFET_Solely*100,(cycleLossPmile_Solely_combine-cycleLossPmile_Act_combine)/cycleLossPmile_Solely_combine*100, (cycleLossPmile_US06_Solely-cycleLossPmile_US06_Act)/cycleLossPmile_US06_Solely*100];
%}
    %% ------------------------------------Calculate the cumulative battery cycle degradation on UDDS cycle------------------------------
     % -----------------------------------------------UDDS   Battery solely--------------------------------------------------------------------------------------
    cycleLoss=[];
    cycleLoss(:,1)=days;
    for t=1:years*365
        if t==1
            cycleLoss(t,2)=0;
        else
            cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Solely*35;
            %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Solely*35;
        end
    end
    
    
    for collect_year=1:10
        collect_days=365*collect_year;
        UDDS_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);

    end
    degradation(2,:)=UDDS_degradation_years;

    figure(2)
    plot(cycleLoss(:,1),cycleLoss(:,2),'.r')
    title('Cycle degradation for battery')
    xlabel('Days')
    ylabel('Degradation percent/%')
    grid

    figure(3)
    plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.r')
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    title('Total degradation for battery')
    xlabel('Days')
    ylabel('Total degradation percent/%')
    grid

    figure(4)
    h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)));
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    xlabel('Years')
    ylabel('Total battery degradation percentage/%')
    set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
    set(gca,'ylim',[0,100],'yTick',[0:10:100]); %设定右边侧x坐标范围
    set(h,'linewidth',2); %坐标线粗0.5磅
    set(h,'linestyle','-.','color','R');

    % Looking for the time when reach the 30% degradation
    for i=1:years*365   
        if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
            tem_Solely=i/365;
            break;
        end
    end

    record=(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2));

    % ------------------------------------As comparison  UDDS    Battery+UC-------------------------------------------
    cycleLoss=[];
    cycleLoss(:,1)=days;
    for t=1:years*365
        if t==1
            cycleLoss(t,2)=0;
        else
            cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Act*35;
            %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Act*35;
        end
    end

    for collect_year=1:10
        collect_days=365*collect_year;
        UDDS_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);

    end
    degradation(3,:)=UDDS_degradation_years;

    
    figure(2)
    hold on
    plot(cycleLoss(:,1),cycleLoss(:,2),'.b')
    title('Cycle degradation for battery')
    xlabel('Days')
    ylabel('Degradation percent/%')


    figure(3)
    hold on
    plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.b')
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    title('Total degradation for battery')
    xlabel('Days')
    ylabel('Total degradation percent/%')

    figure(4)
    hold on
    h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)),'-.');
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    xlabel('Years')
    ylabel('Total battery degradation percentage/%')
    set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
    set(gca,'ylim',[30,100],'yTick',[30:5:100]); %设定右边侧x坐标范围
    set(h,'linewidth',2); %坐标线粗2磅
    set(h,'linestyle','-.','color','B');

    % Looking for the time when reach the 20% degradation
    for i=1:years*365   
        if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
            tem_Act=i/365;
            break;
        end
    end

    percent=(tem_Act-tem_Solely)/tem_Solely*100;
    fprintf('The improved percentage is %.2f',percent)
    display('% optimal VS solely on UDDS')



    % -----------------------------------As comparison UDDS Average current--------------------------------------------
    cycleLoss=[];
    cycleLoss(:,1)=days;
    for t=1:years*365
        if t==1
            cycleLoss(t,2)=0;
        else
            cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_UDDS_Average*35;
            %cycleLoss(t,2) = cycleLoss(t-1,2) + cycleLossPmile_US06_Average*35;
        end
    end

for collect_year=1:10
    collect_days=365*collect_year;
    Infinite_degradation_years(1,collect_year)=cycleLoss(collect_days,2)+calendarLoss(collect_days,2);
    
end
degradation(4,:)=Infinite_degradation_years;
    
    figure(2)
    hold on
    h=plot(cycleLoss(:,1),cycleLoss(:,2),'.g');

    title('Cycle degradation for battery')
    xlabel('Days')
    ylabel('Degradation percent/%')
    legend('Battery solely','Optimal battery/SC','Infinite SC number','location','northwest')

    figure(3)
    hold on
    plot(cycleLoss(:,1),K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2),'.g')
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    title('Total degradation for battery')
    xlabel('Days')
    ylabel('Total degradation percent/%')
    legend('Battery solely','Optimal battery/SC','Infinite SC number','location','northwest')

    figure(4)
    hold on
    h=plot(cycleLoss(:,1)/365,100-(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2)),'-.');
    %loss =exp((coefLoss['d']*(vehicle.batteryT[int(activity.start*3600)+i]+273.15)+coefLoss['e'])*deltsoc[i]*3600)*current[i]/3600/2
    xlabel('Years')
    ylabel('Total battery degradation percentage/%')
    set(gca,'xlim',[0,10],'xTick',[0:1:10]); %设定左边侧x坐标范围
    set(gca,'ylim',[40,100],'yTick',[40:5:100]); %设定右边侧x坐标范围
    set(h,'linewidth',2); %坐标线粗2磅
    set(h,'linestyle','-.','color','g');
    legend('Battery solely on US06','Optimal battery/SC on US06','Infinite SC number on US06','Battery solely on UDDS','Optimal battery/SC on UDDS','Infinite SC number on UDDS','location','southwest')
    set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',[.1 .12 .88 .84]);%设置xy轴在图片中占的比例


    % Looking for the time when reach the 20% degradation
    for i=1:years*365   
        if abs(K_cal*calendarLoss(i,2)+K_cyc*cycleLoss(i,2)-Deg_limit)<=0.01
            tem_Act=i/365;
            break;
        end
    end

    percent=(tem_Act-tem_Solely)/tem_Solely*100;
    fprintf('The improved percentage is %.2f ',percent)
    display('% infinite VS solely on UDDS')

    record2=(K_cal*calendarLoss(:,2)+K_cyc*cycleLoss(:,2));
end


figure(4)

plot(A_x,100-Deg_limit,'*k')
text(A_x,100-Deg_limit-3,'A','horiz','center')

plot(B_x,100-Deg_limit,'*k')
text(B_x-0.1,100-Deg_limit-3,'B','horiz','center')

plot(C_x,100-Deg_limit,'*k')
text(C_x+0.2,100-Deg_limit+3,'C','horiz','center')

plot([0,C_x],[100-Deg_limit,100-Deg_limit],'-.k')


toc
