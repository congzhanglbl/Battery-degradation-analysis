%% Using Simple control strategy
%  The core part of the sreategy is to compare the PE function
%  In order to eliminate the influence of the initial energy in SC, several standard driving cycles are combined
%{
tic
clear
close all
B_size1= [10 5 16 8];
B_size2=[.08 .12 .90 .84];
drive_eff=1.15;
brake_eff=0.2;
timestep=1; % unit: seconds
%{
SOC_SC_K1 = 0;
SOC_SC_lower_LowLimit=0;
SOC_SC_lower_UpLimit=0;
Power_SC_assist_eff_LowLimit= 0;
Power_SC_assist_eff_UpLimit= 0;
SOC_SC_K1_LowLimit =0;
SOC_SC_K1_UpLimit =0;
SOC_SC_K0_LowLimit =0;
SOC_SC_K0_UpLimit =0;

SOC_SC_K0_LowLimit = 0.95;
SOC_SC_K0_UpLimit = 0.95;    
SOC_SC_K1_LowLimit = 0.75;
SOC_SC_K1_UpLimit = 0.75;         
SOC_SC_lower_LowLimit=0.35;
SOC_SC_lower_UpLimit=0.35;
Power_SC_assist_eff_LowLimit= 0.5;
Power_SC_assist_eff_UpLimit= 0.5;    
%}
SOC_Bat_init = 0.95;  % Define the initial battery SOC
SOC_SC_init = 0.76;   % Define the initial SC SOC
DisplayFigure=0; 
% 0 No figure plot; 1 plot figure.
Store_count = 0;

Cells_begin= 1;
Cells_end= 200;
Cells_step=1;

for Cells= Cells_begin:Cells_step:Cells_end % The number of SC cells
    Store_count = Store_count + 1;
    for cycle = 3:3
        % cycle=1;
        % 1 UDDS; 2 HWFET; 3 US06; 4 (US06*2+HWFET*2+UDDS*2); 5 US06+HWFET+UDDS;
        optimal=1;
        % 0, no optimal, used for debugging, just an example: cycleLoss(:,3)*0.8
        % 1, used for optimal design
            Iteration=3; 
            % 0, Run the fixed value and get the result

            % 1, Run the searching strategy and find the best SOC_SC_lower and Power_SC_assist_eff

            % 2, Run the searching strategy and find the best many configuration, such
            % as SOC_SC_lower and Power_SC_assist_eff and SOC_SC_K1_LowLimit

            % 3, Run the searching strategy and find the best many configuration, such
            % as SOC_SC_K1, SOC_SC_K1_LowLimit, SOC_SC_lower and Power_SC_assist_eff
        % SC_charging_eff = 1.2; % In drive mode, when demanded is samll, and SC SOC is low(0.25-0.75), battery discahrging at 
        %% Load the demanded power, then create the long driving cycles
        clear Power_kw
        if cycle==1
            load('Demanded power_UDDS.mat')
            Power_kw=UDDS_power_1s;
            Power_kw_tem(:,2) = [Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2)];
            Power_kw_tem(:,1) = (1:length(Power_kw_tem(:,2)))';  
            Power_kw = Power_kw_tem;
            clear Power_kw_tem    
        elseif cycle==2
            load('Demanded power_HWFET.mat')
            Power_kw=HWFET_power_1s;
            Power_kw_tem(:,2) = [Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2)];
            Power_kw_tem(:,1) = (1:length(Power_kw_tem(:,2)))';  
            Power_kw = Power_kw_tem;
            clear Power_kw_tem
        elseif cycle==3
            load('Demanded power_US06.mat')
            Power_kw=US06_power_1s;
            %Power_kw_tem(:,2) = [Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2)];
            Power_kw_tem(:,2) = Power_kw(:,2);
            Power_kw_tem(:,1) = (1:length(Power_kw_tem(:,2)))';  
            Power_kw = Power_kw_tem;
            clear Power_kw_tem   
        elseif cycle==4
            load('Demanded power_MultiCycle_repeat.mat')
            Power_kw=Multi_Cycles_repeat;    
        elseif cycle==5
            load('Demanded power_MultiCycle.mat')
            Power_kw=Multi_Cycles;
        end

        %% Add the influence of drive efficiency and braking efficiency
        for ii=1:length(Power_kw)
            if Power_kw(ii,2)>0
                Power_kw(ii,2)=Power_kw(ii,2)*drive_eff;
            else
                Power_kw(ii,2)=Power_kw(ii,2)*brake_eff;
            end
        end

        %% Run the battery degradation file (Battery solely and infinite SC)
        display('****Load and run the battery degradation calculation algorithm on battery solely and infinite SC****')
        %fprintf('****Load and run the battery degradation calculation algorithm on battery solely and infinite SC****\n')
        BatteryDegradationCalculation_Infinite_Solely % Represents the infinite SC and battery solely situations
        display('Finished the battery degradation calculation on battery solely and infinite SC')

        %% Add the simple control strategy
        display('Begin the simple control strategy(Paper 2 Configuration)')
        Simple_control_body

        fprintf('Battery solely degradation is %.5f \n',cycleLoss(end,4));
        fprintf('Infinite SC degradation is %.5f \n',cycleLoss(end,2));
        fprintf('By using the simple control strategy, the battery degradation is %.5f \n',cycleLoss(end,6));
        
    Store(Store_count,1)= Store_count;  
    Store(Store_count,2)= Cells;
    Store(Store_count,3)= cycleLoss(end,6);  % Simple strategy battery degradation
    Store(Store_count,4)= (cycleLoss(end,4)-cycleLoss(end,6))/(cycleLoss(end,4)-cycleLoss(end,2))*100;  %The realization percentage
    Store(Store_count,5)= Store(Store_count,4)/Cells;  % Realization percentage per Cell
    Store(Store_count,6)= cycleLoss(end,4);
    Store(Store_count,7)= cycleLoss(end,2);
    Store(Store_count,8)= Record.SC.SOC(end,1)-Record.SC.SOC(1,1);  % Delta SOC for SC
    
    
    fprintf('Finished %d of %d \n',Store_count,1+floor((Cells_end-Cells_begin)/Cells_step))        
        if DisplayFigure ==1
            figure(cycle)
            hold on      
            g= plot(cycleLoss(:,1),cycleLoss(:,2));
            h= plot(cycleLoss(:,1),cycleLoss(:,4));
            f= plot(cycleLoss(:,1),cycleLoss(:,6));
            title('Battery degradation')
            xlabel('Time/s')
            ylabel('Battery degradation rate/%')
            set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
            set(g,'linewidth',2); %坐标线粗0.5磅
            set(g,'linestyle','-','color','g');        
            set(h,'linewidth',2); %坐标线粗0.5磅
            set(h,'linestyle','-','color','r');
            set(f,'linewidth',2); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('Infinite SC','Battery solely','Simpole strategy','location','northeast') 

            figure(cycle+10)
            hold on
            h= plot(cycleLoss(:,1),Power_kw(:,2));
            f= plot(cycleLoss(:,1),Record.Bat.power(:,1));
            title('Battery Power')
            xlabel('Time/s')
            ylabel('Battery power/kW')
            set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
            set(h,'linewidth',2); %坐标线粗0.5磅
            set(h,'linestyle','-','color','r');
            set(f,'linewidth',2); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('Battery solely','Optimal','location','northeast') 

            figure(cycle+20)
            hold on
            h= plot(cycleLoss(:,1),Record.Bat.SOC(:,1));
            f= plot(cycleLoss(:,1),Record.SC.SOC(:,1));
            title('SOC Curve for Battery and SC')
            xlabel('Time/s')
            ylabel('SOC')
            set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
            set(h,'linewidth',2); %坐标线粗0.5磅
            set(h,'linestyle','-','color','r');
            set(f,'linewidth',2); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('Battery SOC','SC SOC','location','northeast')  
        end
    end
end

%}
close all
SC_number=76;
load Store_result.mat
figure(2)
plot(Store(:,2),Store(:,4))
title('Realization percentage/%')

figure(1)
g=plot(Store(:,2),Store(:,3),'-.m')
set(g,'linewidth',2);
hold on
title('Battery degradation VS SC Cells')

figure(101)
[ax,h1,h2]=plotyy(Store(:,2),Store(:,3),Store(:,2),Store(:,4));
hold on
%title('Battery degradation VS SC Cells')
%title(['Energy consumption deviation on ', CycleName])  
%xlabel('Number of SC cells')
xlabel('超级电容单体数/个')
set(ax(1),'XColor','k','YColor','b');
set(ax(2),'XColor','k','YColor','r');
set(h1,'linewidth',2);
set(h1,'linestyle','-','color','b');
set(h2,'linewidth',2);    
set(h2,'linestyle','-','color','r');
%set(get(ax(1),'Ylabel'),'string','Battery cycle degradation /%');
set(get(ax(1),'Ylabel'),'string','电池容量衰退/%');
%set(get(ax(2),'Ylabel'),'string','Realization percentage/%');
set(get(ax(2),'Ylabel'),'string','实现率/%');
set(ax(1),'xlim',[0,200],'xTick',[0:20:200]); %设定左边侧x坐标范围    
set(ax(1),'ylim',[0.001,0.002],'yTick',[0.001:0.0002:0.002]); %设定左边侧x坐标范围 
set(ax(2),'xlim',[0,200],'xTick',[0:20:200]); %设定左边侧x坐标范围    
set(ax(2),'ylim',[0,100],'yTick',[0:10:100]); %设定左边侧x坐标范围    

legend('Battery degradation','Realization percentage','location','southeast')   
set(gcf,'Units','centimeters','Position',[10  5    14     8]);%设置图片大小为7cm×5cm
set(gca,'Position',[0.10    0.15000    0.800    0.79]);%设置xy轴在图片中占的比例

plot(SC_number,Store(SC_number,3),'*k')
text(SC_number*1.26,Store(SC_number,3)*0.94,'D(76, 0.0015)','horiz','center')
plot([SC_number,SC_number],[0,Store(SC_number,3)],'-.b')
plot([0,SC_number],[Store(SC_number,3),Store(SC_number,3)],'-.b')
%text(SC_number*0.95,Store(SC_number,3)*0.97,'D(76, 0.0015)','horiz','center')

plot(SC_number,Store(SC_number,3)*1.11,'*k')
text(SC_number*1.1,Store(SC_number,3)*1.11*1.05,'R(76, 68.8)','horiz','center')
plot([SC_number,SC_number],[Store(SC_number,3),Store(SC_number,3)*1.11],'-.r')
plot([SC_number,200],[Store(SC_number,3)*1.11,Store(SC_number,3)*1.11],'-.r')
%text(SC_number,Store(SC_number,3)*1.11,'R(76, 68.8)','horiz','center')


toc