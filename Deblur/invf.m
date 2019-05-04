function result = invf(img,h)
sizeI = size(img);
%转到傅里叶频谱
IMG = fftn(img);
H = psf2otf(h,sizeI);
%频域点乘
result = IMG./H;
%return to original zone
result = real(ifftn(result));
end
