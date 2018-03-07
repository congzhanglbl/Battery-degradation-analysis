%% Plot the relationship between I_rate and Ah_through
%{
%��ͼ��С��׼��
B_size1=[10 10 16 8];
B_size2=[.08 .12 .84 .84];
%˫ͼ��С��׼
S_D_size1=[10 10 9 5];
S_D_size2=[.14 .18 .74 .78];

%use matlab.mat ��ͼfigure ��ͼ��С��׼��������
B_single_size1=[10 10 16 8];
B_single_size2=[.1 .12 .86 .84];

%˫ͼ��С��׼��3����ͼ���ߴ������������
size1=[10 10 10 6];
size2=[.15 .16 .80 .80];

%һ����ͼ��С��׼��������
S_size1=[10 10 7 5];
S_size2=[.20 .18 .75 .78];
%}

%% Compare the degradation speed

% Relative degradation speed on different discharging rate, same Ah_through --------------------------------
figure(1)
x=0.5:0.01:5;
plot(x,(exp(1)).^x/(exp(1)))% ratio value
grid
title('Degradation ratio compared to 1C')
xlabel('Current Rate')
ylabel('Degradation speed compared to 1C')
%}

% Relative degradation speed on different discharging rate, same Ah_through --------------------------------
S_size1=[10 10 7 5];
S_size2=[.20 .18 .75 .78];
for x=1:5
    Ratio=(exp(1))^x/exp(1);
    y(x) =Ratio;
end
figure(5); 
h=bar(y);
xlabel('circuit rate');ylabel('cycle degradation speed(relative value), same Ah_through');
set(gcf,'Units','centimeters','Position',S_size1);%����ͼƬ��СΪ7cm��5cm
set(gca,'Position',S_size2);%����xy����ͼƬ��ռ�ı���


% Relative degradation speed on different discharging rate, different Ah_through----------------------------
S_size1=[10 10 7 5];
S_size2=[.20 .18 .75 .78];
C=50;
for x=1:5
    if x==1
        Ratio=1;
    else
        %Ratio=(exp(1))^x/exp(1);
        Ratio=(exp(1))^x/exp(1)/(1+(x-1)/0.98);
    end
    y(x) =Ratio;
end
figure(6); 
bar(y);
xlabel('circuit rate');ylabel('cycle degradation speed(relative value), different Ah_through');
set(gcf,'Units','centimeters','Position',S_size1);%����ͼƬ��СΪ7cm��5cm
set(gca,'Position',S_size2);%����xy����ͼƬ��ռ�ı���
%}