clear
close all
B_size1=[10 10 16 8];
B_size2=[.08 .12 .84 .84];
%双图大小标准
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];

cd('..')
addpath(fullfile(pwd,'Matlab_data'));
% load ..\Matlab_data\Demanded.mat % ???????????
% addpath(genpath('F:\DropBox_zhangcongok\Dropbox\PhD_Dissertation\Paper2_Configuration\Matlab_code\Matlab_data'))

drive_eff=1.15;
brak_eff=0.2;

for cycle=1:3
    Power_kw=0;
    clear Power

    if cycle==1
        CycleName = 'UDDS';
        load('Demanded power_UDDS.mat')
        Power_kw=UDDS_power_1s;
        % Power_kw_tem(:,2) = [Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2)];
        % Power_kw_tem(:,1) = (1:length(Power_kw_tem(:,2)))';  
        % Power_kw = Power_kw_tem;
        % clear Power_kw_tem    
    elseif cycle==2
        CycleName = 'HWFET';        
        load('Demanded power_HWFET.mat')
        Power_kw=HWFET_power_1s;
    elseif cycle==3
        CycleName = 'US06';        
        load('Demanded power_US06.mat')
        Power_kw=US06_power_1s;
    end
    % Power_kw
    % column 1: time; column 2: power; 
    % column 3: cumulative power; column 3: cumulative power for average; 
    
    energy=0;
    for ii= 1:length(Power_kw)   
        if ii==1
            Power_kw(ii,3)=Power_kw(ii,2)*drive_eff;
        else
            if Power_kw(ii,2)>0
                Power_kw(ii,3)=Power_kw(ii-1,3)+Power_kw(ii,2)*drive_eff;
            else
                Power_kw(ii,3)=Power_kw(ii-1,3)+Power_kw(ii,2)*brak_eff;
            end
        end
    end
    average_power=Power_kw(end,3)/length(Power_kw);
    average(cycle,1) = average_power;
    Power_kw(:,4)=average_power*Power_kw(:,1);
    if cycle==1
        average_power_UDDS = Power_kw(end,3)/length(Power_kw);
    elseif cycle==2
        average_power_HEFET = Power_kw(end,3)/length(Power_kw);
    elseif cycle==3
        average_power_US06 = Power_kw(end,3)/length(Power_kw);
    end


    figure(cycle) % Power curve
    %title(['Power curve on ', CycleName])   
    h=plot(Power_kw(:,1),Power_kw(:,2));
    hold on
    g=plot([Power_kw(1,1),Power_kw(end,1)],[average_power,average_power]);
    xlabel('Time/s')
    ylabel('Power /kW')
    legend('Demanded power','Infinite case','location','northwest')
    set(cycle,'Position',[50,50,600,400]) 
    set(gca,'xlim',[0,610],'xTick',[0:100:600]); 
    set(gca,'ylim',[-80,80],'yTick',[-80:20:80]);
    set(h,'linewidth',1.5);
    set(h,'linestyle','-','color','b');    
    set(g,'linewidth',2);
    set(g,'linestyle','-','color','g');
    
    figure(cycle+10)
    title(['Acumulative energy consumption on ', CycleName])  
    xlabel('Time/s')
    ylabel('Energy /wh')
    hold
    plot(Power_kw(:,1),Power_kw(:,3)/3.6,'b');
    plot(Power_kw(:,1),Power_kw(:,4)/3.6,'r');
    legend('Demanded energy consumption','Infinite case','location','southeast')   
    set(cycle+10,'Position',[680,20,600,400]) 
    
    figure(cycle+20)
    hold
    title(['Energy consumption deviation on ', CycleName])  
    xlabel('Time/s')
    ylabel('Energy /wh')
    plot(Power_kw(:,1),(Power_kw(:,3)-Power_kw(:,4))/3.6,'b');
    legend('Energy deviation','location','southeast')   
   % set(gca,'Position',S_D_size2);%设置xy轴在图片中占的比例
    set(cycle+20,'Position',[130,50,600,400]) 
    Record.Deviation(cycle,:) = [max((Power_kw(:,3)-Power_kw(:,4))/3.6),min((Power_kw(:,3)-Power_kw(:,4))/3.6),max((Power_kw(:,3)-Power_kw(:,4))/3.6)-min((Power_kw(:,3)-Power_kw(:,4))/3.6)];
    Record.Power(cycle,:) = [max(Power_kw(:,2)),min(Power_kw(:,2))];
    
    figure(cycle+30)
    h=plot(Power_kw(:,1),Power_kw(:,3)/3.6,'-b');
    set(h,'linewidth',2)
    set(gca,'ylim',[-100,3000],'yTick',[-100:50:300]); %设定左边侧x坐标范围   
    hold on
    [ax,h1,h2] = plotyy(Power_kw(:,1),Power_kw(:,4)/3.6,Power_kw(:,1),(Power_kw(:,3)-Power_kw(:,4))/3.6);
    fprintf('The necessart SC configure is %.4f wh when cycle = %f',max((Power_kw(:,3)-Power_kw(:,4))/3.6)-min((Power_kw(:,3)-Power_kw(:,4))/3.6),cycle)
    
    
    %title(['Energy consumption deviation on ', CycleName])  
    %xlabel('Time/s')
    xlabel('时间/s')
    set(ax(1),'XColor','k','YColor','b');
    set(ax(2),'XColor','k','YColor','r');
    set(h1,'linewidth',2);
    set(h1,'linestyle','--','color','b');
    set(h2,'linewidth',2);    
    set(h2,'linestyle','-','color','r');
    %set(get(ax(1),'Ylabel'),'string','Cumulative energy /Wh');
    %set(get(ax(2),'Ylabel'),'string','Energy deviation /Wh');
    set(get(ax(1),'Ylabel'),'string','累计放电能量 /Wh');
    set(get(ax(2),'Ylabel'),'string','电容放电能量 /Wh');   
    if cycle==1
        set(ax(1),'ylim',[0,1500],'yTick',[0:300:1500]); %设定左边侧y坐标范围  
        set(ax(2),'ylim',[-100,200],'yTick',[-100:50:200]); %设定左边侧x坐标范围 
        legend('单一电池','电容无限大','电容放电能量','location','southeast')   
    elseif cycle==2
        set(ax(1),'ylim',[0,1500],'yTick',[0:300:1500]); %设定左边侧y坐标范围  
        set(ax(2),'ylim',[-100,100],'yTick',[-100:50:100]); %设定左边侧x坐标范围 
        legend('单一电池','电容无限大','电容放电能量','location','southeast')   
    elseif cycle==3
        set(ax(1),'ylim',[0,2000],'yTick',[0:400:2000]); %设定左边侧y坐标范围  
        set(ax(1),'xlim',[0,610],'xTick',[0:100:610]); %设定左边侧y坐标范围  
        set(ax(2),'ylim',[-100,300],'yTick',[-100:50:300]); %设定左边侧x坐标范围      
        set(ax(2),'xlim',[0,610],'xTick',[0:100:610]); %设定左边侧y坐标范围  
        legend('单一电池','电容无限大','电容放电能量','location','northwest')   
    end
    %legend('Battery solely','Infinite SC','DeltaEnergy','location','northwest')   
    %set(gcf,'Units','centimeters','Position',[10    10    14     8]);%设置图片大小为7cm×5cm
    %set(gca,'Position',[0.1100    0.15000    0.7800    0.8300]);%设置xy轴在图片中占的比例
    set(gcf,'Units','centimeters','Position',[10 5 11 6]);%设置图片大小为7cm×5cm
    set(gca,'Position',[.15 .18 .69 .80]);%设置xy轴在图片中占的比例    
   
end