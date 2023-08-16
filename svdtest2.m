function sigma=svdtest2(k)
close all
%I = imread('pout.tif');
%I = imread('rose.tif');
I=imread('lena.bmp');
subplot(1,2,1)
 imshow(I),title('original image')

 I = im2double(I);
 [U,S,V] = svd(I);
 sigma = diag(S);
 p=length(sigma)
 I1=0;
 for i=1:k
I1 = I1 + sigma(i)*U(:,i)*V(:,i)';
end
 sigma(1:k);
 subplot(1,2,2)
 imshow(I1),title('First 25 singular values')