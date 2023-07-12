%exconv.m
%Ejemplo de CONVOLUCION
figure
subplot(3,1,1)
x=[-2:.01:2]';
f=triangularPulse(-1,0,1,x);
plot(x,f)
g=Gfe(x,2);
subplot(3,1,2)
plot(x,g)
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

M=length(w);
h=4/M;
z=-2:h:2;
z=z(1:end-1);
subplot(3,1,3)
plot(z,w,'LineWidth',1.5,'Color','r')

