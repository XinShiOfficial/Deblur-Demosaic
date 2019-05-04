function result = demosaic_bilinear(img)
%bilinear

%三个通道的初始化重建
[h,w] = size(img);
img2 = zeros(h+2,w+2);%扩大一圈
img2(2:h+1,2:w+1) = img;
img2(1,:)=img2(3,:);img2(h+2,:) = img2(h,:);
img2(:,1) = img2(:,3);img2(:,w+2) = img2(:,w);
r = zeros(h+2,w+2);
g = zeros(h+2,w+2);
b = zeros(h+2,w+2);
for i = 1:h+2
    for j = 1:w+2
        if(mod(i,2)==0 && mod(j,2) ==1)%r channel
            r(i,j) = img2(i,j);
        elseif(mod(i,2)==1 && mod(j,2) ==0)%b channel
            b(i,j) = img2(i,j);
        else
            g(i,j) = img2(i,j);
        end
    end
end

%插值
for i = 2:h+1
    for j = 2:w+1
        if(mod(i,2) == 0&&mod(j,2)==0)%g leftis red
            r(i,j) = (img2(i,j-1)+img2(i,j+1))/2;
            b(i,j) = (img2(i-1,j)+img2(i+1,j))/2;
        elseif(mod(i,2) == 1&&mod(j,2)==1)%green, left is blue
            b(i,j) = (img2(i,j-1)+img2(i,j+1))/2;
            r(i,j) = (img2(i-1,j)+img2(i+1,j))/2;
        elseif(mod(i,2) == 0&&mod(j,2)==1)%red
            b(i,j) = (img2(i-1,j-1)+img2(i-1,j+1)+img2(i+1,j-1)+img2(i+1,j+1))/4;
            g(i,j) = (img2(i,j-1)+img2(i,j+1)+img2(i-1,j)+img2(i+1,j))/4;
        else%blue
            r(i,j) = (img2(i-1,j-1)+img2(i-1,j+1)+img2(i+1,j-1)+img2(i+1,j+1))/4;
            g(i,j) = (img2(i,j-1)+img2(i,j+1)+img2(i-1,j)+img2(i+1,j))/4; 
        end
    end
end
%截取结果
result = cat(3,r(2:h+1,2:w+1),g(2:h+1,2:w+1),b(2:h+1,2:w+1))/256;
