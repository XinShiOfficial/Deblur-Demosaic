function result = minvf(img,h,delta)
%modified inverse filter
%delta ��һ����ֵ
IMG = fftn(img);%ת������ҶƵ��
sizeI = size(img);
H = psf2otf(h,sizeI);
Hp = 1./H;
%H�еĽ�����0��ֵ�ڳ�1֮���Ϊ�������ɽ���ļ����С
%��˽���Щλ�ô��Ľ��ֱ����0
Hp(abs(H)<=delta) = 0;
result = IMG.*Hp;
result = real(ifftn(result));
