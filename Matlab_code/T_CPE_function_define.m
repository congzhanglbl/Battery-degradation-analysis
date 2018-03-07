clear
close all
x1=0:0.01:pi;
x2=pi:0.01:2*pi+1;
figure(10)
y1=10*sin(2.5*x1-0.5*pi);
h=plot(x1,10*sin(2.5*x1-0.5*pi));
set(h,'linewidth',2)
set(h,'color','b')
hold on
y2=-10*sin(x2);
h=plot(x2,-10*sin(x2));
set(h,'linewidth',2)
set(h,'color','b')
axis([0 7 0 11])
h=plot([0 6.5],[4 4]);
set(h,'linewidth',2)
set(h,'linestyle','-.')
set(h,'color','r')
y=[y1,y2];
y_line=[0:6.5/729:6.5];

%title('CPE function definition')
xlabel('Time/h')
ylabel('Power/kW')
xlabel('时间/h')
ylabel('需求功率/kW')

t1=0.7925:0.01:1.7203;
t2=1.7203:-0.01:0.7925;
t1=0.79:0.01:1.72;
t2=1.72:-0.01:0.79;
t=[t1;t2];
y=10*sin(2.5*t-0.5*pi);
fill(t,y,'r')

t1=3.55:0.01:5.87;
t2=5.87:-0.01:3.55;
t=[t1;t2];
y=-10*sin(t);
fill(t,y,'r')

h=plot([0.79 0.79], [0, 4],'-.k');
set(h,'linewidth',1.5)
h=plot([1.72 1.72], [0, 4],'-.k');
set(h,'linewidth',1.5)
h=plot([3.55 3.55], [0, 4],'-.k');
set(h,'linewidth',1.5)
h=plot([5.87 5.87], [0, 4],'-.k');
set(h,'linewidth',1.5)

text(0.7,-0.75,'t1','horiz','center')
text(1.6,-0.75,'t2','horiz','center')
text(3.5,-0.75,'t3','horiz','center')
text(5.8,-0.75,'t4','horiz','center')

set(gcf,'Units','centimeters','Position',[10 10 10 6]);%设置图片大小为7cm×5cm
set(gca,'Position',[.11 .18 .88 .80]);%设置xy轴在图片中占的比例
