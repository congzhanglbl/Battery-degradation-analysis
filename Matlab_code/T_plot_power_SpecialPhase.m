clear
close all
switch_value=1; % 1, Start   2: Acceleration

%单图大小标准，
B_size1=[10 10 16 8];
B_size2=[.08 .12 .84 .84];
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];
%-----------Convert the timestep from 0.1 second to 1 second---------------
%{
load '..\Matlab_data\Phase_Start.mat'
load '..\Matlab_data\Phase_Acc.mat'

j=0;
for i=1:10:length(V_Phase_mps)-1
    j=j+1;
    sum=0;
    for ii=0:9
        sum=sum+V_Phase_mps(i+ii,2);
    end
    Phase_Speed(j,1)=j;
    Phase_Speed(j,2) = sum/10;
    
end 
clear i ii j sum V_Phase_mps Phase_Speed
%}

% -----Calculate power demand on special phases: Start and Acc-------------
%{

if switch_value==1
    load '..\Matlab_data\Phase_Start_mps.mat'
elseif switch_value==2
    load '..\Matlab_data\Phase_Acc_mps.mat'
end
Speed=Phase_Speed(:,2)*0.44704;
mass_lb= 3302 ; % unit: lb
mass=mass_lb*0.453592;
Target_A=31.91; % Coast down curve: f(v)= A + B*v+ C*v*v   from Argonne lab
Target_B=0.11159;
Target_C=0.017757;
total_row=length(Speed);
num_cycles=1;
g=9.8;
 for ii=1:total_row  %Calculate for coefficient for w(i)
    if  ii==total_row
        w_coefficien{num_cycles}(ii,1)=0;
        w_coefficien{num_cycles}(ii,2)=0;
        w_coefficien{num_cycles}(ii,3)=0;
        w_coefficien{num_cycles}(ii,4)=0;
        w_coefficien{num_cycles}(ii,5)=0;
        w_coefficien{num_cycles}(ii,6)=Speed(ii,1);
        w_coefficien{num_cycles}(ii,7)=0;
    else
        v=Speed(ii,1);
        acc=Speed(ii+1,1)-Speed(ii,1);
        w_coefficien{num_cycles}(ii,1)=v*v;
        w_coefficien{num_cycles}(ii,2)=acc*acc;
        w_coefficien{num_cycles}(ii,3)=v*v*acc;
        w_coefficien{num_cycles}(ii,4)=v*acc*acc;
        w_coefficien{num_cycles}(ii,5)=v*acc;
        w_coefficien{num_cycles}(ii,6)=v;
        w_coefficien{num_cycles}(ii,7)=acc;
    end
 end

pow_kw=(mass.*w_coefficien{num_cycles}(:,5)+((Target_A+Target_B.*w_coefficien{num_cycles}(:,6).*2.236936+Target_C.*w_coefficien{num_cycles}(:,1).*2.236936*2.236936).*4.448222).*w_coefficien{num_cycles}(:,6))/1000;

if switch_value==1
    Start_power_1s(:,2)=pow_kw;
    Start_power_1s(:,1)=Phase_Speed(:,1);
    save Demanded_power_Start.mat Start_power_1s
elseif switch_value==2
    Acc_power_1s(:,2)=pow_kw;
    Acc_power_1s(:,1)=Phase_Speed(:,1);
    save Demanded_power_Acc.mat Acc_power_1s
end
%}

% -----Plot Speed and CPE function on special phases: Start and Acc--------

if switch_value==1
    load '..\Matlab_data\Demanded_power_Start.mat'
    load '..\Matlab_data\Phase_Start_mps.mat'
    power_kw=Start_power_1s;
    Speed=Phase_Speed;
    figure(1)
    h=plot(Speed(:,1),Speed(:,2));
    axis([0, 50, 0,43])
    xlabel('Time/s')
    ylabel('Speed/(mph)')
    set(h,'linewidth',2);
    set(gca,'xlim',[1,43],'xTick',[0:5:50]); %设定左边侧x坐标范围
    set(gca,'ylim',[-5,35],'yTick',[-5:5:35]); %设定右边侧x坐标范围
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    
    figure(2)
    load '..\Matlab_data\CPE_Start.mat'
    h=plot(1:length(Cum_CPE),Cum_CPE);
    legend('CPE when starting up')
    xlabel('Power/kw')
    ylabel('CPE/wh')
    set(h,'linewidth',2);
    set(gca,'xlim',[0,20],'xTick',[0:2:20]); %设定左边侧x坐标范围
    set(gca,'ylim',[0,50],'yTick',[0:10:50]); %设定右边侧x坐标范围
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    
elseif switch_value==2
    load '..\Matlab_data\Demanded_power_Acc.mat'
    load '..\Matlab_data\Phase_Acc_mps.mat'
    power_kw=Acc_power_1s;
    Speed=Phase_Speed;
    figure(1)
    h=plot(Speed(:,1),Speed(:,2));
    axis([0, 32, 0,60])
    xlabel('Time/s')
    ylabel('Speed/(mph)')
    set(h,'linewidth',2);
    set(gca,'xlim',[1,32],'xTick',[0:5:32]); %设定左边侧x坐标范围
    set(gca,'ylim',[-5,60],'yTick',[-5:10:60]); %设定右边侧x坐标范围
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    
    figure(2)
    load '..\Matlab_data\CPE_Acc.mat'
    h=plot(1:length(Cum_CPE),Cum_CPE);
    legend('CPE when acceleration')
    xlabel('Power/kw')
    ylabel('CPE/wh')
    set(h,'linewidth',2);
    set(gca,'xlim',[0,50],'xTick',[0:10:50]); %设定左边侧x坐标范围
    set(gca,'ylim',[0,140],'yTick',[0:20:140]); %设定右边侧x坐标范围
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
end


%}