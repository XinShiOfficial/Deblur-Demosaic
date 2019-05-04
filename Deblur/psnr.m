function y = psnr(f1,f2)
%calculate psnr between f1 and f2,both double

k = 8;%bit depth
fmax = 2.^k - 1;
a = fmax.^2;
t_MSE = (f1 - f2).^2;
r = mean(mean(t_MSE(:,:,1)));
g = mean(mean(t_MSE(:,:,2)));
b = mean(mean(t_MSE(:,:,3)));
MSE = (r + g + b)/3;
y = 10*log10(a/MSE);