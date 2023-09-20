
figure
i=1;
for N=[2,7,15]
    x=-10:0.01:10;
    y=sumaf(x,N);
    subplot(1,3,i)
    plot(x,y,'LineWidth',2)
    title(['N=',num2str(N)])
    i=i+1;    
end
    
function  w=sumaf(x,N)
  S=0;
  for k =1:N
      S = S+(-1)^(k+1)/k*sin(k*x);
  end
  w= 2*S;
end