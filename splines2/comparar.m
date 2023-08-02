function comparar(a,N,ruido,lambda)
%Draw graphs for Runge,Lagrange and spline functions
 clc;close all;

%runge=@(x) 1./(1+12*x.^2); 
runge=@(x) 1./(1+x.^2);
xknots=(-a:2*a/N:a)' ;
yruido=runge(xknots) + ruido*randn(length(xknots),1);
[c,d]=newpol(xknots,yruido);
t=-a:0.01:a;
yexacto=runge(t);                    %Runge
lagrange=fnewton(c,xknots,t);    %Lagrange
L=splinecubico(xknots,yruido,lambda);
splinef=splcubic(L,xknots,t);    %cubic spline
%INTERPOLATION-------------------------
% figure
% subplot(1,2,1)
% plot(t,yexacto,'--','LineWidth',2),hold on%Runge +Lagrange
% plot(t,lagrange,'LineWidth',2)
% plot(xknots,yruido,'*r'),title('Lagrange interpolation')
% legend('Runge','Lagrange','Data')
% 
% subplot(1,2,2)
% plot(t,yexacto,'--','LineWidth',2),hold on
% plot(t,splinef,'LineWidth',2)
% plot(xknots,yruido,'*r')
% title('Spline interpolation')
% legend('Runge','Spline','Data')
%---------------------------------------------



%SMOOTHING--------------------------
figure
plot(t,splinef,'LineWidth',2)
hold on
plot(t,yexacto,'-.','LineWidth',2)
plot(xknots,yruido,'*r')
legend('Spline', 'Runge','Noisy data')
%------------------------------------- 



%comparar(4,8,0,0)
%comparar(2,50,.03,0.01)
% comparar(2,50,.05,0.007)
%comparar(3,70,.04,0.1)
