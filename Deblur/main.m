clear
clc
fori = fopen('foreman.qcif','r');
fid = fopen('Gaussian_blurred_foreman.cif','r');
row = 352;
col = 288;
frames = 90;

%创建视频对象
fps = 25;
videoName = 'deblur_gauss.avi';
aviobj = VideoWriter(videoName);
aviobj.FrameRate = fps;
if(exist(videoName,'file')~=0)  
    delete (videoName);
end
open(aviobj);

%gauss blur kernel
h_g = [0.0000 0.0000 0.0001 0.0003 0.0004 0.0003 0.0001 0.0000 0.0000;
    0.0000 0.0002 0.0012 0.0034 0.0049 0.0034 0.0012 0.0002 0.0000;
    0.0001 0.0012 0.0069 0.0195 0.0276 0.0195 0.0069 0.0012 0.0001;
    0.0003 0.0034 0.0195 0.0552 0.0781 0.0552 0.0195 0.0034 0.0003;
    0.0004 0.0049 0.0276 0.0781 0.1105 0.0781 0.0276 0.0049 0.0004;
    0.0003 0.0034 0.0195 0.0552 0.0781 0.0552 0.0195 0.0034 0.0003;
    0.0001 0.0012 0.0069 0.0195 0.0276 0.0195 0.0069 0.0012 0.0001;
    0.0000 0.0002 0.0012 0.0034 0.0049 0.0034 0.0012 0.0002 0.0000;
    0.0000 0.0000 0.0001 0.0003 0.0004 0.0003 0.0001 0.0000 0.0000;];
%motion blur kernel
h_m = [0 0 0 0 0 0 0 0.0145 0;
    0 0 0 0 0 0 0.0262 0.0896 0.0145;
    0 0 0 0 0 0.0262 0.0896 0.0262 0;
    0 0 0 0 0.0262 0.0896 0.0262 0 0;
    0 0 0 0.0262 0.0896 0.0262 0 0 0;
    0 0 0.0262 0.0896 0.0262 0 0 0 0;
    0 0.0262 0.0896 0.0262 0 0 0 0 0;
    0.0145 0.0896 0.0262 0 0 0 0 0 0;
    0 0.0145 0 0 0 0 0 0 0;];

%原始图像定位到100帧
i = 1;
while i<100
Y = (fread(fori,[row/2,col/2]))';
U = (fread(fori,[row/4,col/4]))';
V = (fread(fori,[row/4,col/4]))';
i = i+1;
end

ISNR1 = 0.0;
ISNR2 = 0.0;
ISNR3 = 0.0;
%读取模糊图像并处理
for i = 1:frames
    %原始帧
Y = (fread(fori,[row/2,col/2]))';
U = (fread(fori,[row/4,col/4]))';
V = (fread(fori,[row/4,col/4]))';
ori = yuv420torgb(Y,U,V);
ori = double(ori);
ori = imresize(ori,[col,row]);
%模糊帧
Y1 = (fread(fid,[row,col]))';
U1 = (fread(fid,[row/2,col/2]))';
V1 = (fread(fid,[row/2,col/2]))';
a = yuv420torgb(Y1,U1,V1);
a = double(a);%one double rgb frame 

subplot(2,2,1);
imshow(a/255);
title('读入图像');

r1 = invf(a,h_g);% inverse
subplot(2,2,2);
imshow(uint8(r1));
title('inverse');
ISNR1 = ISNR1+(psnr(a,ori) - psnr(r1,ori));

r2 = minvf(a,h_g,0.1);%modified inverse
subplot(2,2,3);
imshow(uint8(r2));
title('modified inverse,0.1')
ISNR2 = ISNR2+(psnr(a,ori) - psnr(r2,ori));

r3 = wf(a,h_g,0.1);%wiener
subplot(2,2,4);
imshow(uint8(r3));
title('wiener,0.1');
ISNR3 = ISNR3+(psnr(a,ori) - psnr(r3,ori));

suptitle('Gauss blur');% 或者是Gauss

frame = getframe(gcf);
writeVideo(aviobj,frame);

end  
%关闭文件
close(aviobj);
fclose(fid);
fclose(fori);

%显示isnr
disp('gauss blur ISNR');
disp(['inverse:',num2str(ISNR1/frames),'dB']);
disp(['modified inverse:',num2str(ISNR2/frames),'dB']);
disp(['wiener:',num2str(ISNR3/frames),'dB']);
