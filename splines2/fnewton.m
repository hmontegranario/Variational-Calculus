
function w = fnewton(c,xdata,x) 
%call as w = fnewton(c,xdata,x)

%Evaluate Newton's Lagrange form 
% x: evalution 
% c diagonal of divided differences matrix
%xdata : knots
N= length(xdata);
M=length(x);
w=zeros(M,1);
for j=1:M
w(j) =c'*cumprod([1;x(j).*ones(N-1,1)-xdata(1:N-1)]);
end
