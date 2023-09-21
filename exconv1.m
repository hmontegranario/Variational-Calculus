%exconv1.m
%Ejemplo de CONVOLUCION
close all
x=[-2:.01:2]';
f=triangularPulse(-1,0,1,x);
g=Gfe(x,2);
m =length(f)
n=length(g);
w=zeros(m+n-1,1);

for k=1:m+n-1
    S=0;
    for j = max(1,k+1-n):1:min(k,m)
        S = S + f(j)*g(k-j+1);
    end
    w(k) = S;
end

figure, subplot(1,3,1)
plot(x,f,'LineWidth',2.0),title('f(x)')

subplot(1,3,2)
plot(x,g,'LineWidth',2.0),title('G(x)')

M=length(w);
h=4/M;
z=-2:h:2;
z=z(1:end-1);
subplot(1,3,3)
plot(z,w,'LineWidth',2.0,'Color','r'),title('f*G(x)')

