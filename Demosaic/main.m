clear
clc
fid = fopen('mosaiced_foreman.raw');
row = 352;
col = 288;
frames = 90;
%������Ƶ����
fps = 25;
videoName = 'demosaic.avi';
aviobj = VideoWriter(videoName);
aviobj.FrameRate = fps;

if(exist(videoName,'file')~=0)  
    delete (videoName);
end
open(aviobj);
%���ַ�������
for i = 1:frames
    set(gcf,'position',[0,0,1400,800]);
    Y1 = (fread(fid,[row,col]))';
    subplot(2,2,1);
    imshow(Y1,[]);
    title('��ȡͼ��');
    r1 = demosaic_bilinear(Y1);
    r2 = demosaic_bicubic(Y1);
    r3 = demosaic_edge(Y1);
    
    subplot(2,2,2);
    imshow(r1,[]);
    title('bilinear')
    
    subplot(2,2,3);
    imshow(r2,[]);
    title('bicubic');
    
    subplot(2,2,4);
    imshow(r3,[]);
    title('edge');
    
    suptitle('demosaic');
    frame = getframe(gcf);
    writeVideo(aviobj,frame);
end
close(aviobj);
fclose(fid);