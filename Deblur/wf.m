function result = wf(img,h,k)
%wiener filter
IMG = fftn(img);%pinyu
sizeI = size(img);
H = psf2otf(h,sizeI);
%kΪ��ʱ��inverse һ��
Hp = conj(H)./(abs(H).^2 + k);
result = IMG.*Hp;
result = real(ifftn(result));