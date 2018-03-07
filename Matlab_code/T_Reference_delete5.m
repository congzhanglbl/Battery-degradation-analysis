close all
clear
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];
S_D_size3=[10 10 12 6];
S_D_size4=[.11 .15 .88 .75];
S_D_size5=[10 10 12 5];
S_D_size6=[.10 .18 .88 .78];
load ..\Matlab_data\Simulink_results.mat

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
legend('Battery solely on UDDS','Optimal battery/SC on UDDS','Infinite SC on UDDS')
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

solely_1=Battery_current_solely_UDDS;
solely_2=Battery_current_solely_US06;
solely=[solely_1;solely_2];
start_current=1;
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
    result(i,1)=count/length(solely);
    if i==final_current
        result_tem(i+1,1)=1-result(i,1);
        result_tem(i,1)=result(i,1)-result(i-1,1);
    elseif i>start_current
        result_tem(i,1)=result(i,1)-result(i-1,1);
    elseif i==start_current
        result_tem(i,1)=result(i,1);
    end
end
result_hist(:,1)=result_tem(start_current:final_current+1);
%result(i,8)=count/length(solely);

figure(20)
h_bar=bar(result_hist,0.8);
legend('Power distribution on UDDS and HWFET')

title('Current distribution')
xlabel('Current range')
ylabel('Percentage')
set(gca,'xticklabel',{'0-0.1C','0.1-0.2C','0.2-0.3C','0.3-0.4C','0.4-0.5C','0.5-0.6C','>0.6C'})
set(gca,'ylim',[0,0.6],'yTick',[0:0.1:1]); %设定右边侧x坐标范围
set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例
for i = start_current:1:final_current+1
    text(i-0.5,result_hist(i)+0.2,num2str(result_hist(i)));
end