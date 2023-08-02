function A =  matrizcubica(td,lambda)
%td: x-coordinates of the knots
M =length(td);

unos=ones(M,1);
A1 = td*unos';
B =(abs(A1-A1')).^3;

P =[unos td];
A= [ B+lambda*eye(M) P;P' [0 0;0 0]];
