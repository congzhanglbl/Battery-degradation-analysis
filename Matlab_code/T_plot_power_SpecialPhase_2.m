clear
close all
switch_value=2; % 1, Start   2: Acceleration
add_halt=1; % Halt for 1 minute

%单图大小标准，
B_size1=[10 10 16 8];
B_size2=[.08 .12 .84 .84];
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];


if switch_value==1
    load '..\Matlab_data\Demanded_power_Start.mat'
    load '..\Matlab_data\Phase_Start_mps.mat'
    if add_halt==1
        load '..\Matlab_data\Starting_up.mat'        
    end
    
    power_kw=Start_power_1s;
    Speed=Phase_Speed;
    figure(1);
    %[ax,h1,h2]=plotyy(Speed(1:length(Speed),1),Speed(:,2),power_kw(1:length(power_kw),1),power_kw(:,2));
    [ax,h1,h2]=plotyy(Speed(1:length(Speed),1),Speed(:,2)*1.61,power_kw(1:length(power_kw),1),power_kw(:,2));
    set(h1,'linestyle','-','color','b');
    set(h1,'linewidth',2);
    set(h2,'linestyle','--','color','r');
    set(h2,'linewidth',2);
    set(ax(1),'XColor','k','YColor','b');
    set(ax(2),'XColor','k','YColor','r');
    xlabel('时间/s');

    set(get(ax(1),'Ylabel'),'string','速度/(km/h)');
    set(get(ax(2),'Ylabel'),'string','需求功率/kW');
    set(ax(1),'xlim',[0,103],'xTick',[0:15:103]); %设定左边侧x坐标范围
    set(ax(2),'xlim',[0,103],'xTick',[0:15:103]); %设定右边侧x坐标范围

    set(ax(1),'ylim',[0,50],'yTick',[0:10:50]); %设定左边x坐标范围
    set(ax(2),'ylim',[0,14],'yTick',[0:3:14]); %设定右边侧y坐标范围

    legend('速度','需求功率','Location','Northwest');
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.11    0.1900    0.7700    0.79];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例      
 %{   
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
    %}
    figure(2)
    load '..\Matlab_data\CPE_Start.mat'
    h=plot(1:length(Cum_CPE),Cum_CPE);
    %legend('CPE when starting up')
    xlabel('Power/kW')
    ylabel('CPE/wh')
    set(h,'linewidth',2,'color','b');
    set(gca,'xlim',[0,20],'xTick',[0:2:20]); %设定左边侧x坐标范围
    set(gca,'ylim',[0,50],'yTick',[0:10:50]); %设定右边侧x坐标范围
                        xlabel('功率/kW')
                        ylabel('CPE函数值/wh')
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.11    0.18500    0.8600    0.79];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
    
elseif switch_value==2
    load '..\Matlab_data\Demanded_power_Acc.mat'
    load '..\Matlab_data\Phase_Acc_mps.mat'
    power_kw=Acc_power_1s;
    Speed=Phase_Speed;
    figure(1);
    %[ax,h1,h2]=plotyy(Speed(1:length(Speed),1),Speed(:,2),power_kw(1:length(power_kw),1),power_kw(:,2));
    [ax,h1,h2]=plotyy(Speed(1:length(Speed),1),Speed(:,2)*1.61,power_kw(1:length(power_kw),1),power_kw(:,2));
    set(h1,'linestyle','-','color','b');
    set(h1,'linewidth',2);
    set(h2,'linestyle','--','color','r');
    set(h2,'linewidth',2);
    set(ax(1),'XColor','k','YColor','b');
    set(ax(2),'XColor','k','YColor','r');

    xlabel('时间/s');

    set(get(ax(1),'Ylabel'),'string','速度/(km/h)');
    set(get(ax(2),'Ylabel'),'string','需求功率/kW');
    set(ax(1),'xlim',[0,32],'xTick',[0:5:45]); %设定左边侧x坐标范围
    set(ax(2),'xlim',[0,32],'xTick',[0:5:45]); %设定右边侧x坐标范围

    set(ax(1),'ylim',[0,85],'yTick',[0:10:85]); %设定左边x坐标范围
    set(ax(2),'ylim',[0,60],'yTick',[0:10:60]); %设定右边侧y坐标范围

   
    legend('速度','需求功率','Location','Northwest');
    set(gcf,'Units','centimeters','Position',S_D_size1);%设置图片大小为7cm×5cm
    set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.11    0.1900    0.7700    0.79];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
    figure(2)
    load '..\Matlab_data\CPE_Acc.mat'
    h=plot(1:length(Cum_CPE),Cum_CPE);
    xlabel('功率/kw')
    ylabel('CPE函数值/wh')
    
    %legend('CPE when acceleration')
    set(h,'linewidth',2,'color','b');
    set(gca,'xlim',[0,50],'xTick',[0:10:50]); %设定左边侧x坐标范围
    set(gca,'ylim',[0,140],'yTick',[0:20:140]); %设定右边侧x坐标范围
                        xlabel('功率/kW')
                        ylabel('CPE函数值/wh')
                        S_D_size5 =[ 10    10    10    6];
                        set(gcf,'Units','centimeters','Position',S_D_size5);%设置图片大小为7cm×5cm
                        S_D_size6 =[ 0.13    0.18500    0.8400    0.79];
                        set(gca,'Position',S_D_size6);%设置xy轴在图片中占的比例  
end