function val= splcubic(alfa,td,x)
%Evaluate spline in x
%alfa: column with the weights of the spline
%td column of knots
%x evaluation vector

M=length(x);
N=length(td);
ax = x'*ones(1,N);
at=ones(M,1)*td';
A = abs(ax-at).^3;

val = A*alfa(1:N)+alfa(N+1)*ones(M,1)+alfa(N+2)*x';
