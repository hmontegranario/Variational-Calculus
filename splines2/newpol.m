

%Call as [c,d]=newpol(x,y)
%x,y: row data vectors
%d:divided differences matrix
%c:diagonal of d  for f[xo..xN] in Newton form
function [c,d]=newpol(x,y)
N =length(x);
d=zeros(N,N);
d(:,1)= y';

for j=2:N
    for k=j:N
        d(k,j)=(d(k,j-1)-d(k-1,j-1))/(x(k)-x(k-j+1));
    end
end
c=diag(d);
