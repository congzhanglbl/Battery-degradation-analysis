clear
close all
clc

eff_drive=1.0;
eff_brake=0.20;

mode=2; % This file just consider the driving cycles, so mode=2
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
S_D_size2=[.14 .18 .82 .78];

%use matlab.mat 作图figure 单图大小标准，单坐标
B_single_size1=[10 5 16 8];
B_single_size2=[.1 .12 .86 .84];

%双图大小标准，3对组图，尺寸调整，单坐标
size1=[10 5 10 6];
size2=[.15 .16 .80 .80];

%一行三图大小标准，单坐标
S_size1=[10 5 7 5];
S_size2=[.20 .18 .75 .78];

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
count=0;
for i=1:length(Power_kw)
    if Power_kw(i,2)>0
        count=count+1;
        sum=sum+Power_kw(i,2)*eff_drive;  % time step is 1 second.
    else
        sum=sum+Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw)
%Average_power=sum/count
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
        sum=sum+Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw)
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
        sum=sum+Power_kw(i,2)*eff_brake;  % time step is 1 second.
    end
end
Average_power=sum/length(Power_kw)
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
legend('Power','Average power')

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
    if i<4
        figure(14);
    else
        figure(15)
    end
    h=plot(1:length(Cum_CPE),Cum_CPE);
    
    if i==1
        set(h,'linestyle','-.','color','k','linewidth',2);
        Cum_CPE_Start=Cum_CPE;
        save ..\Matlab_data\CPE_Start.mat Cum_CPE
    elseif i==2
        set(h,'linestyle','-','color','g','linewidth',2);
        Cum_CPE_Acc=Cum_CPE;
        save ..\Matlab_data\CPE_Acc.mat Cum_CPE
    elseif i==3
        set(h,'linestyle','-','color','b','linewidth',2);
        Cum_CPE_UDDS=Cum_CPE;
        %legend('CPE on UDDS')
                        set(gca,'xlim',[0,35],'xTick',[0:5:35]); %设定左边侧x坐标范围
                        set(gca,'ylim',[0,90],'yTick',[0:20:90]); %设定右边侧x坐标范围     
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.105    0.18500    0.8700    0.80];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例                        
        save ..\Matlab_data\CPE_UDDS.mat Cum_CPE
    elseif i==4
        set(h,'linestyle','-','color','b','linewidth',1.5);
        Cum_CPE_HWFET=Cum_CPE;
        %legend('CPE on HWFET')
        set(gca,'xlim',[0,25],'xTick',[0:5:25]); %设定左边侧x坐标范围
        set(gca,'ylim',[0,270],'yTick',[0:50:270]); %设定右边侧x坐标范围
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.14    0.200    0.8200    0.75];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例        
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
    C1=24;
    %plot([C1,C1],[0,pe_acc_PE(C1)])

    xlabel('Power/kw')
    ylabel('CPE/wh')
    xlabel('功率/kW')
    ylabel('CPE函数值/wh')




    
    %set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    %set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    clear tem Cum_CPE
    hold on
end
