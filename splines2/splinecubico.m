function alfa=splinecubico(td,y,lambda)
%Obtains the weights for spline
%td x-coordinates of knots
% y: data to be interpolated
% alfa:weight vector
A = matrizcubica(td,lambda);
b= [y;0 ;0];
alfa= A\b;
