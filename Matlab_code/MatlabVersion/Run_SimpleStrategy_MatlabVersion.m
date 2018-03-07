%% Using Simple control strategy
%  The core part of the sreategy is to compare the PE function
%  In order to eliminate the influence of the initial energy in SC, several standard driving cycles are combined

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
DisplayFigure=1; 
% 0 No figure plot; 1 plot figure.

Store_count = 0;
Cells_begin= 76;
Cells_end= 76;
Cells_step=10;
for Cells= Cells_begin:Cells_step:Cells_end % The number of SC cells
    Store_count = Store_count + 1;
    for cycle =1:1
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
            %Power_kw_tem(:,2) = [Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2);Power_kw(:,2)];
            Power_kw_tem(:,2) = [Power_kw(:,2)];
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
        fprintf('By using the simple control strategy, the battery degradation is %.5f \n',cycleLoss(end,6)*1.2);
        
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
            g= plot(cycleLoss(:,1),cycleLoss(:,2));
            hold on 
            h= plot(cycleLoss(:,1),cycleLoss(:,4));
            f= plot(cycleLoss(:,1),cycleLoss(:,6)*1.2);
            %title('Battery degradation')
            %xlabel('Time/s')
            %ylabel('Battery degradation rate/%')
            xlabel('时间/s')
            ylabel('电池容量衰退/%')            
            
            set(g,'linewidth',2); %坐标线粗0.5磅
            set(g,'linestyle','-','color','g');        
            set(h,'linewidth',2); %坐标线粗0.5磅
            set(h,'linestyle','-','color','r');
            set(f,'linewidth',2); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('电容无限大','单一电池','复合电源','location','northwest') 
            set(gcf,'Units','centimeters','Position',[10 5 11 6]);%设置图片大小为7cm×5cm
            set(gca,'Position',[.12 .19 .85 .73]);%设置xy轴在图片中占的比例
            if cycle==1
                set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:200:length(Power_kw)]); %设定左边侧x坐标范围
            elseif cycle==2
                set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:500:length(Power_kw)]); %设定左边侧x坐标范围
            elseif cycle==3
                set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:500:length(Power_kw)]); %设定左边侧x坐标范围
            end

            figure(cycle+10)
            hold on
            h= plot(cycleLoss(:,1),Power_kw(:,2));
            f= plot(cycleLoss(:,1),Record.Bat.power(:,1));
            title('Battery Power')
            xlabel('Time/s')
            ylabel('Battery power/kW')
            set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
            set(h,'linewidth',1); %坐标线粗0.5磅
            set(h,'linestyle','-','color','r');
            set(f,'linewidth',1); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('Demanded vehicle power(battery solely)','1st strategy based power','location','northeast') 
            
            figure(cycle+20)
            hold on
            f= plot(cycleLoss(:,1),Record.SC.SOC(:,1));
            title('SOC Curve for SC')
            xlabel('Time/s')
            ylabel('SOC')
            set(gca,'xlim',[0,length(Power_kw)],'xTick',[0:100:length(Power_kw)]); %设定左边侧x坐标范围
            set(f,'linewidth',2); %坐标线粗0.5磅
            set(f,'linestyle','-','color','b');
            legend('SC SOC','location','north')             

            figure(cycle+30)
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
            legend('Battery SOC','SC SOC','location','southeast')
        end
    end
end


%{
figure(2)
plot(Store(:,2),Store(:,4))
title('Realization percentage/%')

figure(3)
plot(Store(:,2),Store(:,5))
title('Realization percentage for every Cell (Performance-Cost)/(%/cell)')

figure(4)
plot(Store(:,2),Store(:,8))
title('Delta SOC of SC(End - Begin)')

figure(1)
g=plot(Store(:,2),Store(:,3),'-.m')
set(g,'linewidth',2);
hold on
title('Battery degradation VS SC Cells')

load '..\Vefifying\DynamicProgram_tendency0.005_0_200.mat'
h_5_1=plot(Store(:,2),Store(:,3));
set(h_5_1,'linewidth',2);
set(h_5_1,'color','r');
hold on

load '..\Vefifying\DynamicProgram_tendency0.01_0_200.mat'
h_5_2=plot(Store(:,2),Store(:,3));
set(h_5_2,'linewidth',2);
set(h_5_2,'color','g');

load '..\Vefifying\DynamicProgram_tendency0.05_0_200.mat'
h_5_3=plot(Store(:,2),Store(:,3));
set(h_5_3,'linewidth',2);
set(h_5_3,'color','b');
xlabel('Number of SC cells');
ylabel('Battery degradation/%')
legend('DP\_0.005','DP\_0.01','DP\_0.05','location','east')

load 'Optimization_Iteration_1_1_200.mat'
h=plot(Store(:,2),Store(:,3),'-.');
set(h,'linewidth',2);

legend('Simple Strategy','DP\_0.005','DP\_0.01','DP\_0.05','Improved Strategy','location','east')

figure(5)
load '..\Vefifying\DynamicProgram_tendency0.005_0_200.mat'
h_5_1=plot(Store(:,2),Store(:,3));
set(h_5_1,'linewidth',2);
set(h_5_1,'color','r');
hold on

load '..\Vefifying\DynamicProgram_tendency0.01_0_200.mat'
h_5_2=plot(Store(:,2),Store(:,3));
set(h_5_2,'linewidth',2);
set(h_5_2,'color','g');

load '..\Vefifying\DynamicProgram_tendency0.05_0_200.mat'
h_5_3=plot(Store(:,2),Store(:,3));
set(h_5_3,'linewidth',2);
set(h_5_3,'color','b');
xlabel('Number of SC cells');
ylabel('Battery degradation/%')
legend('DP\_0.005','DP\_0.01','DP\_0.05','location','east')

%}
toc

