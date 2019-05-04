function result = minvf(img,h,delta)
%modified inverse filter
%delta 是一个阈值
IMG = fftn(img);%转到傅里叶频谱
sizeI = size(img);
H = psf2otf(h,sizeI);
Hp = 1./H;
%H中的近似于0的值在除1之后变为无穷大，造成结果的极大或极小
%因此将这些位置处的结果直接置0
Hp(abs(H)<=delta) = 0;
result = IMG.*Hp;
result = real(ifftn(result));
