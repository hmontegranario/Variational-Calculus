clear
syms x
f2(x) = piecewise((-5 < x) & (x < 5),exp(-25./(25-x.^2)),0)
[x,y] =meshgrid(-8:0.3:8,-8:0.3:8);

z=bumb(x,y,f2);
figure
surf(x,y,z)