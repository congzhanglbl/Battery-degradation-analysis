close all
clear
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];
S_D_size3=[10 10 12 6];
S_D_size4=[.11 .15 .88 .75];
S_D_size5=[10 10 12 6];
S_D_size6=[.10 .20 .88 .75];
load ..\Matlab_data\Simulink_results.mat
B_size2=[.09 .15 .88 .83];
%================= Plot UDDS information, power distribution===================================
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
legend('Battery only on UDDS','CPE configured on UDDS','Infinite SC on UDDS')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(UDDS_power_1s)+1],'xTick',[0:100:length(UDDS_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-35,120],'yTick',[-35:20:120]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

Current_1C = 88; % unit:A, 1C for Battery discharging
Current_dot8C = 0.8*Current_1C; % unit:A, 0.8C for Battery discharging 
Current_dot5C = 0.5*Current_1C; % unit:A, 0.5C for Battery discharging 
Current_dot3C = 0.3*Current_1C; % unit:A, 0.3C for Battery discharging 
Current_dot2C = 0.2*Current_1C; % unit:A, 0.2C for Battery discharging 
Current_dot17C = 0.17*Current_1C; % unit:A, 0.2C for Battery discharging 
Current_dot1C = 0.1*Current_1C; % unit:A, 0.1C for Battery discharging/charging 

solely=Battery_current_solely_UDDS;
optimal=Battery_current_Act_UDDS;
start_current=2;

final_current=6;
result_tem=[0];
result=[0];

for i=start_current:1:final_current
    count=0;
    for ii=1:length(solely)
        if abs(solely(ii,1))<i*0.1*Current_1C
            count=count+1;
        end
    end
    result(i-1,1)=count/length(solely);
    if i==final_current
        result_tem(i+1,1)=1-result(i-1,1);
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i>start_current
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i==start_current
        result_tem(i,1)=result(i-1,1);
    end
end
result_hist(:,1)=result_tem(start_current:final_current+1);
%result(i,8)=count/length(solely);

result_tem=[0];
result=[0];
for i=start_current:1:final_current
    count=0;
    for ii=1:length(optimal)
        if abs(optimal(ii,1))<i*0.1*Current_1C
            count=count+1;
        end
    end
    result(i-1,1)=count/length(optimal);
    if i==final_current
        result_tem(i+1,1)=1-result(i-1,1);
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i>start_current
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i==start_current
        result_tem(i,1)=result(i-1,1);
    end
end
result_hist(:,2)=result_tem(start_current:final_current+1);

figure(11)
h_bar=bar(result_hist,1);
%legend('Battery only on UDDS','CPE configured on UDDS')
legend('单一电池','复合电源')
%title('Current distribution')
%xlabel('Current range')
%ylabel('Percentage')
xlabel('电流范围/C')
ylabel('所占比例')
set(gca,'xticklabel',{'0-0.2C','0.2-0.3C','0.3-0.4C','0.4-0.5C','0.5-0.6C','>0.6C'})
set(gca,'ylim',[0,1],'yTick',[0:0.1:1]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例

%================= Plot HWFET information, power distribution===================================

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
legend('Battery only on HWFET','CPE configured on HWFET','Infinite SC on HWFET')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(HWFET_power_1s)+1],'xTick',[0:50:length(HWFET_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-45,100],'yTick',[-50:10:100]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

%================= Plot US06 information, power distribution===================================

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
legend('Battery only on US06','CPE configured on US06','Infinite SC on US06')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(US06_power_1s)+1],'xTick',[0:50:length(US06_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[-80,270],'yTick',[-80:40:270]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',B_size1);%设置图片大小为7cm×5cm
set(gca,'Position',B_size2);%设置xy轴在图片中占的比例

solely=Battery_current_solely_US06;
optimal=Battery_current_Act_US06;

start_current=5;
final_current=10;
result_tem=[0];
result=[0];
clear result_hist

for i=start_current:1:final_current
    count=0;
    for ii=1:length(solely)
        if abs(solely(ii,1))<i*0.1*Current_1C
            count=count+1;
        end
    end
    result(i-1,1)=count/length(solely);
    if i==final_current
        result_tem(i+1,1)=1-result(i-1,1);
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i>start_current
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i==start_current
        result_tem(i,1)=result(i-1,1);
    end
end
result_hist(:,1)=result_tem(start_current:final_current+1);
%result(i,8)=count/length(solely);

result_tem=[0];
result=[0];
for i=start_current:1:final_current
    count=0;
    for ii=1:length(optimal)
        if abs(optimal(ii,1))<i*0.1*Current_1C
            count=count+1;
        end
    end
    result(i-1,1)=count/length(optimal);
    if i==final_current
        result_tem(i+1,1)=1-result(i-1,1);
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i>start_current
        result_tem(i,1)=result(i-1,1)-result(i-2,1);
    elseif i==start_current
        result_tem(i,1)=result(i-1,1);
    end
end
result_hist(:,2)=result_tem(start_current:final_current+1);

figure(13)
h_bar=bar(result_hist,1);
%legend('Battery only on US06','CPE configured on US06')
legend('单一电池','复合电源')
%title('Current distribution')
%xlabel('Current range')
%ylabel('Percentage')
xlabel('电流范围/C')
ylabel('所占比例')
set(gca,'xticklabel',{'0-0.5C','0.5-0.6C','0.6-0.7C','0.7-0.8C','0.8-0.9C','0.9-1.0C','>1C'})
set(gca,'ylim',[0,0.8],'yTick',[0:0.1:1]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例

figure(4)
plot(Capa_SOC_Act_UDDS)
hold on
plot(Capa_SOC_Act_HWFET,'r')
plot(Capa_SOC_Act_US06,'k')
legend('Act_UDDS','Act_HWFET','Act_US06','location','southeast')
xlabel('Time/s')
ylabel('Current/(A)')
set(gca,'xlim',[0,length(UDDS_power_1s)+1],'xTick',[0:100:length(UDDS_power_1s)+1]); %设定左边侧x坐标范围
set(gca,'ylim',[0,1],'yTick',[0:0.1:1]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',S_D_size3);%设置图片大小为7cm×5cm
set(gca,'Position',S_D_size4);%设置xy轴在图片中占的比例

toc