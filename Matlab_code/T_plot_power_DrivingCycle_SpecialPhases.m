clear
close all
clc

mode=3;
if mode==1         % Just for special phase
    begin=1;
    final=2;
    x_offset=0.5;
    y_offset=4;
elseif mode==2     % Just for driving cycles
    begin=3;
    final=4;
    x_offset=0.25;
    y_offset=3;
else               % All driving cycles, all special phases
    begin=1;
    final=4;
    x_offset=0.25;
    y_offset=3;
end

% --------------------Initialize Figure size----------------------------
%use matlab.mat 双坐标
%单图大小标准，
B_size1=[10 5 16 8];
B_size2=[.08 .12 .84 .84];
%双图大小标准
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];

%use matlab.mat 作图figure 单图大小标准，单坐标
B_single_size1=[10 5 16 8];
B_single_size2=[.1 .12 .86 .84];

%双图大小标准，3对组图，尺寸调整，单坐标
size1=[10 5 10 6];
size2=[.15 .16 .80 .80];

%一行三图大小标准，单坐标
S_size1=[10 5 7 5];
S_size2=[.20 .18 .75 .78];

eff_drive=1;
eff_brake=0.5;
load '..\Matlab_data\Demanded power_UDDS.mat'
Power_kw=UDDS_power_1s;

load '..\Matlab_data\Demanded power_US06.mat'
Power_kw=US06_power_1s;

load '..\Matlab_data\Demanded power_WOTs.mat'
Power_kw=WOTs_power_1s;

load '..\Matlab_data\Demanded power_HWFET.mat'
Power_kw=HWFET_power_1s;

load '..\Matlab_data\Demanded_power_Start.mat'
Power_kw=Start_power_1s;

load '..\Matlab_data\Demanded_power_Acc.mat'
Power_kw=Acc_power_1s;


% --------------------plot reference power level for UDDS--------------------
load '..\Matlab_data\Demanded power_UDDS.mat'
Power_kw=UDDS_power_1s;
figure(11)
plot(Power_kw(:,1),Power_kw(:,2))
hold on
sum=0;
for i=1:length(Power_kw)
    if Power_kw(i,2)>0
        sum=sum+Power_kw(i,2)*eff_drive;  % time step is 1 second.
    else
        sum=sum-Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw);
Average_power_UDDS=Average_power;
y=plot([0, length(Power_kw)],[Average_power,Average_power],'r');
set(y,'linewidth',3)
%patch([0, length(Power_kw)],[Average_power,Average_power],'r','edgecolor','none','facealpha',0.01);%不透明度0.15
%area([0, length(Power_kw)],[Average_power,Average_power],'FaceColor', [1 0.5 0]);

axis([0, length(Power_kw), min(Power_kw(:,2)),max(Power_kw(:,2))])
xlabel('Time/s')
ylabel('Power/(kw)')
set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
set(gca,'ylim',[-26,32],'yTick',[-25:5:35]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

% Table  power distribution percentage on UDDS
Power_1C=24;
row=0;
column=1;
for power_limit=0.3:0.1:1    
    row=row+1;
    count=0;
    for i=1:length(Power_kw)
        if Power_kw(i,2)>power_limit*Power_1C;
            count=count+1;
        end
    end
    percentage(row,column)=count/length(Power_kw);
end


% --------------------plot reference power level for HWFET---------------
load '..\Matlab_data\Demanded power_HWFET.mat'
Power_kw=HWFET_power_1s;
figure(12)
plot(Power_kw(:,1),Power_kw(:,2))
hold on
sum=0;
for i=1:length(Power_kw)
    if Power_kw(i,2)>0
        sum=sum+Power_kw(i,2)*eff_drive;  % time step is 1 second.
    else
        sum=sum-Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw);
Average_power_HWFET=Average_power;
y=plot([0, length(Power_kw)],[Average_power,Average_power],'r');
set(y,'linewidth',3)

axis([0, length(Power_kw), min(Power_kw(:,2)),max(Power_kw(:,2))])
xlabel('Time/s')
ylabel('Power/(kw)')
set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:50:length(Power_kw)]); %设定左边侧x坐标范围
set(gca,'ylim',[-35,25],'yTick',[-35:5:25]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

row=0;
column=2;
for power_limit=0.3:0.1:1    
    row=row+1;
    count=0;
    for i=1:length(Power_kw)
        if Power_kw(i,2)>power_limit*Power_1C;
            count=count+1;
        end
    end
    percentage(row,column)=count/length(Power_kw);
end


% --------------------plot reference power level for US06---------------
load '..\Matlab_data\Demanded power_US06.mat'
Power_kw=US06_power_1s;
figure(13)
plot(Power_kw(:,1),Power_kw(:,2))
hold on
sum=0;
for i=1:length(Power_kw)
    if Power_kw(i,2)>0
        sum=sum+Power_kw(i,2)*eff_drive;  % time step is 1 second.
        
    else
        sum=sum-Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw);
Average_power_US06=Average_power;
y=plot([0, length(Power_kw)],[Average_power,Average_power],'r');
set(y,'linewidth',3)
%patch([0, length(Power_kw)],[Average_power,Average_power],'r','edgecolor','none','facealpha',0.01);%不透明度0.15
%area([0, length(Power_kw)],[Average_power,Average_power],'FaceColor', [1 0.5 0]);

axis([0, length(Power_kw), min(Power_kw(:,2)),max(Power_kw(:,2))])
xlabel('Time/s')
ylabel('Power/(kw)')
set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:50:length(Power_kw)]); %设定左边侧x坐标范围
set(gca,'ylim',[-60,60],'yTick',[-60:10:60]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

figure(106)
Energy= Power_kw;  
% Column 1, time;  Column 2, power;  Column 3, power*1.15 or 0.2; 
% Column 4, Accumulate energy(column 3)   
% Column 5, Accumulate energy(Infinite)   
for i=1:length(Power_kw)
    if Power_kw(i,2)>0
        Energy(i,3) = Power_kw(i,2)*1.15;
    else
        Energy(i,3) = Power_kw(i,2)*0.2;  % time step is 1 second.
    end
end

for i=1:length(Power_kw)
    if i==1
        Energy(i,4) =0;
    else
        Energy(i,4) = Energy(i-1,4) + Energy(i,3);  % time step is 1 second.
    end
end
Energy_average = Energy(end,4)/i;
Energy(:,5) = Energy_average.* Energy(:,1);
h_106_1 = plot(Energy(:,1),Energy(:,4),'b');
hold on
h_106_2 = plot(Energy(:,1),Energy(:,5),'g');
set(h_106_1,'linewidth',2);
set(h_106_2,'linewidth',2);
xlabel('Time/s')
ylabel('Accumulated energy(battery dolely VS infinite SC)/(kWs)')
set(gca,'ylim',[0,7000],'yTick',[0:1000:7000]); %设定右边侧x坐标范围
legend('Battery dolely','Infinite SC','location','southeast');

figure(107)
h_107 = plot(Energy(:,1),Energy(:,4)-Energy(:,5),'r');
set(h_107,'linewidth',2);
xlabel('Time/s')
ylabel('DeltaEnergy/(kWs)')


figure(108)
[ax,h1,h2]=plotyy(Energy(:,1),Energy(:,4)/3.6,Energy(:,1),(Energy(:,4)-Energy(:,5))/3.6);
hold on
set(h1,'linewidth',2);
set(h1,'color','b');
set(h2,'linewidth',2);
set(h2,'linestyle','-');
set(h2,'color','r');
h_106_2 = plot(Energy(:,1),Energy(:,5)/3.6,'b');
set(h_106_2,'linestyle','-.');
set(h_106_2,'linewidth',2);
legend('Battery solely','Infinite SC','DeltaEnergy','location','southeast')

set(get(ax(1),'Ylabel'),'string','Energy/Wh');
set(get(ax(2),'Ylabel'),'string','Delta Energy/Wh');
set(ax(1),'xlim',[0,700],'xTick',[0:100:700]); %设定左边侧x坐标范围
%set(ax(2),'xlim',[0,700],'xTick',[0:100:700]); %设定左边侧x坐标范围

set(ax(1),'ylim',[0,2000],'yTick',[0:400:2000]); %设定左边x坐标范围
set(ax(2),'ylim',[-100,300],'yTick',[-100:50:300]); %设定右边侧x坐标范围

set(gcf,'Units','centimeters','Position',[10 5 14 8]);%设置图片大小为7cm×5cm
set(gca,'Position',[.11 .12 .78 .85]);%设置xy轴在图片中占的比例

row=0;
column=3;
for power_limit=0.3:0.1:1
    row=row+1;
    count=0;
    for i=1:length(Power_kw)
        if Power_kw(i,2)>power_limit*Power_1C;
            count=count+1;
        end
    end
    percentage(row,column)=count/length(Power_kw);
end


%{
% --------------------plot speed-time, power during acceleration period--------------------------
%title('SAE acceleration requirement')

Speed_upper=20*1.61/3.6; % maximum speed value, unit m/s
y_acc=0:0.1:Speed_upper;
x_acc=linspace(0,6,length(y_acc));
y_end=ones(1,10)*Speed_upper;
x_end=linspace(6.1,7.1,10);
Speed=[y_acc,y_end]'; % Speed_upper vector, unit m/s
t=[x_acc,x_end]'; 

figure(1)
plot(t,Speed)

xlabel('Time/s')
ylabel('Speed/(m/s)')
set(gca,'xlim',[0,8],'xTick',[0:1:8]); %设定左边侧x坐标范围
set(gca,'ylim',[0,10],'yTick',[0:2:10]); %设定右边侧x坐标范围
hold
h=plot([6,6],[0,8.9]);
set(h,'linewidth',2); %坐标线粗0.5磅
set(h,'linestyle','-.','color','R');
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例
clear Speed y_acc x_acc y_end x_end h
%}

%{
% ---------------plot power-energy using PE function (Not Continuous PE)------------------
%title('PE function, not continuous function')
tem=Power_kw(:,2);

for P_px=0:ceil(max(Power_kw(:,2)))
    a=tem(:,1)-P_px;
    sum=0;
    for tt=1:length(tem(:,1))
        if a(tt,1)<0
            a(tt,1)=0;
        end
        sum=sum+a(tt,1);
    end
   % E_ex(P_px+1)=sum(P_pe_1);   
   Cum_PE(P_px+1)=sum/3.6;   % PE Function  wh
   clear a
end
figure(2);
h=plot(1:length(Cum_PE),Cum_PE);
hold on
C1=24;
plot([C1,C1],[0,Cum_PE(C1)])
xlabel('Power/kw')
ylabel('Energy/wh')
clear tem P_px P_pe_1 tt pe_acc_PE h C1
%}
% ----------------------------Table power distribution on UDDS-------------
figure(3)
b=Power_kw(:,2);
hist(b,15);

set(gca,'xlim',[-50,50],'xTick',[-50:5:50]); %设定左边侧x坐标范围
set(gca,'ylim',[0,200],'yTick',[0:20:200]); %设定右边侧x坐标范围
title('Power distribution')
xlabel('Power/kw')
ylabel('Fraction of power')

% ---------------plot power-energy using PE function (Continuous PE)------------------
%title('PE function, continuous function')
for i=begin:final
    Power_kw=[0];
    if i==1
        Power_kw=Start_power_1s(:,2);
    elseif i==2
        Power_kw=Acc_power_1s(:,2);
    elseif i==3
        Power_kw=UDDS_power_1s(:,2);
    elseif i==4
        Power_kw=HWFET_power_1s(:,2);        
    elseif i==5
        Power_kw=US06_power_1s(:,2);
    elseif i==6
        Power_kw=WOTs_power_1s(:,2);
    end
    tem=Power_kw;
    for P_px=0:1:60 %ceil(max(tem))
        store=[0];
        count=1;
        a=tem(:,1)-P_px;
        a(end,1)=0;
        for tt=1:length(tem(:,1))
            if a(tt,1)<0
                a(tt,1)=0;
            end
        end
       % if P_px==0        
       %     pe_acc_PE(1)=sum(a)/3.6;
       % else
            sum=0;
            for tt=1:length(a(:,1))
                if a(tt,1)==0
                    if sum>0
                        store(count)=sum;
                        sum=0;
                        count=count+1;
                    end
                else
                    sum=sum+a(tt,1)/3.6;
                end
            end
            Cum_CPE(P_px+1)=max(store);   % Continuous PE函数 wh
            store=[0];
        %end
       
    end
    if i<=4
        figure(4);
    else
        figure(4)
    end
    h=plot(1:length(Cum_CPE),Cum_CPE);
    
    if i==1
        set(h,'linestyle','-.','color','k','linewidth',1.5);
        Cum_CPE_Start=Cum_CPE;
        save ..\Matlab_data\CPE_Start.mat Cum_CPE
    elseif i==2
        set(h,'linestyle','-','color','g','linewidth',1.5);
        Cum_CPE_Acc=Cum_CPE;
        save ..\Matlab_data\CPE_Acc.mat Cum_CPE
    elseif i==3
        set(h,'linestyle','-.','color','b','linewidth',1.5);
        Cum_CPE_UDDS=Cum_CPE;
        save ..\Matlab_data\CPE_UDDS.mat Cum_CPE
    elseif i==4
        set(h,'linestyle','-','color','b','linewidth',1.5);
        Cum_CPE_HWFET=Cum_CPE;
        save ..\Matlab_data\CPE_HWFET.mat Cum_CPE
    elseif i==5
        set(h,'linestyle','-','color','g','linewidth',1.5);
        Cum_CPE_US06=Cum_CPE;
        save ..\Matlab_data\CPE_US06.mat Cum_CPE
    elseif i==6
        set(h,'linestyle','-.','color','g','linewidth',1.5);
        Cum_CPE_WOTS=Cum_CPE;
        save ..\Matlab_data\CPE_WOTS.mat Cum_CPE
    end
    clear tem Cum_CPE
    hold on
end
%hold
C1=24;
%plot([C1,C1],[0,pe_acc_PE(C1)])
xlabel('Power/kw')
ylabel('Energy/wh')
set(gca,'xlim',[0,40],'xTick',[0:5:40]); %设定左边侧x坐标范围
set(gca,'ylim',[0,300],'yTick',[0:30:300]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例
clear Speed y_acc x_acc y_end x_end h
clear tem P_px tt h C1 count sum

if begin==1 & final==2 % Just for special phase
    Cum_CPE_max = Cum_CPE_Acc;
    mode=1;
elseif begin==3 & final==4 % Just for driving cycles
    Cum_CPE_max = max(Cum_CPE_UDDS,Cum_CPE_HWFET);
    mode=2;
else
    Cum_CPE_max = max(max(Cum_CPE_UDDS,Cum_CPE_HWFET),Cum_CPE_Acc);
    mode=3;
end

for i=1:5
    y1(i,1)=Cum_CPE_max(1,i);
end
x1=1:5;
x1=x1'+x_offset;

for i=6:length(Cum_CPE_max)
    y2(i-5,1)=Cum_CPE_max(1,i)+y_offset;
end
x2=6:length(Cum_CPE_max);
x2=x2';
x=[x1;x2];
y=[y1;y2];
h=plot(x,y,'-.r');
set(h,'linewidth',2.15);
if mode==1
    legend('起步阶段的CPE','加速阶段的CPE','两阶段较大的CPE')
    set(gca,'ylim',[0,135],'yTick',[0:20:135]); %设定右边侧x坐标范围
                        set(gca,'xlim',[0,40],'xTick',[0:5:40]); %设定左边侧x坐标范围
                        set(gca,'ylim',[0,135],'yTick',[0:20:135]); %设定右边侧x坐标范围     
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.125    0.18500    0.8500    0.78];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
                        xlabel('功率/kW')
                        ylabel('CPE函数值/wh')    
elseif mode==2
    %legend('CPE curve on UDDS','CPE curve on HWFET','Max CPE curve')
    legend('UDDS工况的CPE','HWFET工况的CPE','两工况较大的CPE')
    set(gca,'xlim',[0,30],'xTick',[0:3:30]); %设定左边侧x坐标范围
                        set(gca,'xlim',[0,30],'xTick',[0:5:30]); %设定左边侧x坐标范围
                        set(gca,'ylim',[0,300],'yTick',[0:50:300]); %设定右边侧x坐标范围     
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.125    0.18500    0.8500    0.78];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
                        xlabel('功率/kW')
                        ylabel('CPE函数值/wh')
    
    
else    
    
    %legend('CPE curve when starting','CPE curve when acceleration','CPE curve on UDDS','CPE curve on HWFET','Max CPE curve')
    legend('起步阶段的CPE','加速阶段的CPE','UDDS工况的CPE','HWFET工况的CPE','综合后的CPE')
                        set(gca,'ylim',[0,300],'yTick',[0:50:300]); %设定右边侧x坐标范围 
                        S_D_size5 =[ 10    10    12    7];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.11    0.1600    0.8700    0.82];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
                        xlabel('功率/kW')
                        ylabel('CPE函数值/wh')    
    
    
    x=1:length(Cum_CPE_max);

    for i=2.4:2.4:24
        h=plot(i,interp1(x,Cum_CPE_max,i),'*');
        fprintf('The rate is %.1fC, the relevant CE value is %.1f\n',i/24,interp1(x,Cum_CPE_max,i))
        set(h,'color','r')
        h=plot([i,i],[0,interp1(x,Cum_CPE_max,i)],'r');
        set(h,'linewidth',1)
        set(h,'linestyle','-.')
    end
end

save ..\Matlab_data\Average_power.mat Average_power_UDDS Average_power_HWFET Average_power_US06
