function z=bumb(x,y,f)


[m,n]=size(x);
z=zeros(m,n);
for i=1:m
    for j=1:n
        r= sqrt(x(i,j).^2+y(i,j).^2);
z(i,j) =f(r);
    end
end
end