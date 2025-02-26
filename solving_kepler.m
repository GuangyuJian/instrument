clear 
clc;
h=1;
inc_deg=0;
a_km=6378.135+500;
% a=a/1000
ranode_deg=0;
e=0.0021;
perigee_deg=0;
f=0;
t0=0;

% E 偏近点角
% M=平近点角
GM=398600.4405; %km3s^-2
n=sqrt(GM/(a_km)^3);

t=0:h:86400*30;
M=n*(t);
% M=
%%
for k=1:length(t)

E0=M(k);
M0=M(k);
k
flag=1;
    f=0;
while flag
    f=f+1;
    E1=E0-(E0-e*sin(E0)-M0)/(1-e*sin(E0));
    f
    dE=E1-E0;
    if abs(dE)<10^-13||f>10000
        E(k)=E1;
%         dE
%         break
        flag=0;
    else

        E0=E1;
    end
      
end
end

sc=a_km*1000;%m
x=cos(E)-e;
y=sqrt(1-e^2)*sin(E);
z=0*zeros(1,length(x));
r=[x;y;z]*sc;


sc=a_km*n./(1-e*cos(E))*1000;%m/s
xe=-sin(E);
ye=sqrt(1-e^2)*cos(E);
ze=0*zeros(1,length(x));
ve=[xe;ye;ze].*sc;
clear sc xe ye ze x y z;

satreal=satellite(t,r,ve);
%%
% 要写入的数值
data = 123;

% 打开文件以二进制写入模式
fileID = fopen('analytial.bin', 'wb');

if fileID ~= -1
    % 写入数据
else
    disp('无法打开文件。');
end

%%
for k=1:length(E)
    fwrite(fileID, E(k), 'double');
    % 关闭文件
end

    fclose(fileID);
    disp('数据已成功写入二进制文件。');

%%
clear fileID ;
%% one-wayA
clear x y
GM=398600.4405*10^9;
fx=@(x,y)-GM*(x^2+y^2)^(-3/2)*x;
fy=@(x,y)-GM*(x^2+y^2)^(-3/2)*y;


ts=t(1);
tend=t(end);
tspan=[ts tend];

x0=satreal.getx(ts);
y0=satreal.gety(ts);
xe0=satreal.getxe(ts);
ye0=satreal.getye(ts);

[~,x,y,xe,ye]=  runge_kutta_4(fx,fy,tspan,x0,y0,xe0,ye0,h);
r=[x; y; zeros(1,length(x))];
ve=[xe; ye; zeros(1,length(x))];
sat(1)=satellite(t,r,ve);


% one-wayB
clc

GM=398600.4405*10^9;
fx=@(x,y)-GM*(x^2+y^2)^(-3/2)*x;
fy=@(x,y)-GM*(x^2+y^2)^(-3/2)*y;
ts=t(end);
tend=t(1);
tspan=[ts tend];

x0=satreal.getx(ts);
y0=satreal.gety(ts);
xe0=satreal.getxe(ts);
ye0=satreal.getye(ts);

[~,x,y,xe,ye]=  runge_kutta_4(fx,fy,tspan,x0,y0,xe0,ye0,-h);
r=[x; y; zeros(1,length(x))];
ve=[xe; ye; zeros(1,length(x))];
sat(2)=satellite(t,fliplr(r),fliplr(ve));



% bi-way

clear x y
GM=398600.4405*10^9;
fx=@(x,y)-GM*(x^2+y^2)^(-3/2)*x;
fy=@(x,y)-GM*(x^2+y^2)^(-3/2)*y;


idx=length(t)-1;
idx=idx/2;
ts=t(idx);
x0=satreal.getx(ts);
y0=satreal.gety(ts);
xe0=satreal.getxe(ts);
ye0=satreal.getye(ts);

tend=t(end);
tspan=[ts tend];
[t1,x,y,xe,ye]=  runge_kutta_4(fx,fy,tspan,x0,y0,xe0,ye0,h);
r1=[x; y; zeros(1,length(x))];
ve1=[xe; ye; zeros(1,length(x))];

tend=t(1);
tspan=[ts tend];
[t2,x,y,xe,ye]=  runge_kutta_4(fx,fy,tspan,x0,y0,xe0,ye0,-h);
r2=[x; y; zeros(1,length(x))];
ve2=[xe; ye; zeros(1,length(x))];
clear x  y xe ye fx fy 

r=[fliplr(r2(:,2:end)) r1];
ve=[fliplr(ve2(:,2:end)) ve1];
sat(3)=satellite(t,r,ve);

%
%%
satdif=sat([1 3])-satreal;
rmsinfo=satdif.rms;

%%
satall=[satreal sat];


% str={'(a) X坐标','(b) Y坐标','(c) X方向速度','(d) Y方向速度'};
titlename=ger_titlename();

fig(900,800)
tiledlayout(4,1,"TileSpacing","compact")

f=0;
for k=1:2
    next;
    f=f+1;
    for r=1:2


    h(r)=satdif(r).plotpos(k);
    
    h(r).LineWidth=0.1;
    set(gca,'FontSize',10);
    ylim([-5 5]*10^-3);
    xlabel('Epoch [s]')
    
    hold on;

    grid on;
    box on;
    end
    title(titlename{f});
    h(1).Color='black';
    h(2).Color='blue';
end

for k=1:2
    next;
    f=f+1;
    for r=1:2


    h(r)=satdif(r).plotvel(k);
    
    h(r).LineWidth=0.1;
    set(gca,'FontSize',10);
    ylim([-5 5]*10^-6);
    xlabel('Epoch [s]')
    
    hold on;
    grid on;
    box on;
    end
    h(1).Color='black';
    h(2).Color='blue';
        title(titlename{f});
end
legend('正向','双向','Location','northwest')

printf_png600('error_sqe')


%%
rmsinfo=satdif.rms
next;
ger_bar1(rmsinfo(:,1:2)*1000)
next;
ger_bar1(rmsinfo(:,4:5)*1000000)
%%
rrms=rmsinfo(:,[1:2])*1000;
vrms=rmsinfo(:,[4:5])*1000000;

[rrms vrms]

