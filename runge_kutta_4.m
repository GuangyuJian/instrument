function [t,x,y,xe,ye]= runge_kutta_4(fx,fy,tspan,x0,y0,xe0,ye0,h)
    % f: 定义的常微分方程函数句柄
    % tspan: 时间区间 [t0, tf]
    % y0: 初始条件
    % h: 步长
    
    t0 = tspan(1);
    tf = tspan(2);
    t = t0:h:tf;
    n = length(t);

    x = zeros(1, n);
    y = zeros(1, n);
    xe = zeros(1, n);
    ye = zeros(1, n);
    
    y(1) = y0;
    x(1)=x0;
    xe(1)=xe0;
    ye(1)=ye0;

    
    for i = 1:n - 1
        xtemp=x(i);
        ytemp=y(i);
        k1xa=h * fx(xtemp,ytemp);
        k1ya=h * fy(xtemp,ytemp);
        k1xv=h*xe(i);
        k1yv=h*ye(i);

        xtemp=x(i)+ k1xv/2;
        ytemp=y(i)+ k1yv/2;
        k2xa=h * fx(xtemp,ytemp );
        k2ya=h * fy(xtemp,ytemp );
        k2xv=h*(xe(i)+k1xa/2);
        k2yv=h*(ye(i)+k1ya/2);

        xtemp=x(i)+ k2xv/2;
        ytemp=y(i)+ k2yv/2;
        k3xa=h * fx(xtemp,ytemp );
        k3ya=h * fy(xtemp,ytemp );
        k3xv=h*(xe(i)+k2xa/2);
        k3yv=h*(ye(i)+k2ya/2);

        xtemp=x(i)+ k3xv;
        ytemp=y(i)+ k3yv;
        k4xa=h * fx(xtemp,ytemp );
        k4ya=h * fy(xtemp,ytemp );
        k4xv=h*(xe(i)+k3xa);
        k4yv=h*(ye(i)+k3ya);
        

        xe( i + 1) =xe(i) + (k1xa + 2*k2xa + 2*k3xa + k4xa) / 6;
        ye( i + 1) =ye(i) + (k1ya + 2*k2ya + 2*k3ya + k4ya) / 6;
        x( i + 1) =x(i) + (k1xv + 2*k2xv + 2*k3xv + k4xv) / 6;
        y( i + 1) =y(i) + (k1yv + 2*k2yv + 2*k3yv + k4yv) / 6;
        

%         xe(i+1)
%         ye(i+1)=ye(i)+h*f2(x(i),y(i));
%         x(i+1)=x(i)+h*xe(i);
%         y(i+1)=y(i)+h*ye(i);
% 
%         k1 = h * fx(t(i), y(:, i));
%         k2 = h * fx(t(i) + h/2, y(:, i) + k1/2);
%         k3 = h * fx(t(i) + h/2, y(:, i) + k2/2);
%         k4 = h * fx(t(i) + h, y(:, i) + k3);
%         y(:, i + 1) = y(:, i) + (k1 + 2*k2 + 2*k3 + k4) / 6;
    
    end
end