function result = invf(img,h)
sizeI = size(img);
%ת������ҶƵ��
IMG = fftn(img);
H = psf2otf(h,sizeI);
%Ƶ����
result = IMG./H;
%return to original zone
result = real(ifftn(result));
end
