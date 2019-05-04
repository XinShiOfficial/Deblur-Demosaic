function result = demosaic_edge(img)
threshold = 130;
%三个通道的初始化重建
[h,w] = size(img);
img2 = zeros(h+4,w+4);%扩大两圈，三次考虑5*5的范围
img2(3:h+2,3:w+2) = img;
img2(1,:)=img2(3,:);img2(2,:)=img2(4,:);img2(h+4,:) = img2(h+2,:);img2(h+3,:) = img2(h+1,:);
img2(:,1) = img2(:,3);img2(:,2) = img2(:,4);img2(:,w+4) = img2(:,w+2);img2(:,w+3) = img2(:,w+1);
r = zeros(h+4,w+4);
g = zeros(h+4,w+4);
b_channel = zeros(h+4,w+4);

for i = 1:h+4
    for j = 1:w+4
        if(mod(i,2)==1 && mod(j,2) ==0)%r channel
            r(i,j) = img2(i,j);
        elseif(mod(i,2)==0 && mod(j,2) ==1)%b channel
            b_channel(i,j) = img2(i,j);
        else
            g(i,j) = img2(i,j);
        end
    end
end

%红色通道插值,
%对角线
for i  = 2:h+3
    for j = 2:w+3
        if(mod(i,2) == 0 && mod(j,2) == 1)
            a = img2(i-1,j-1);
            b = img2(i-1,j+1);
            c = img2(i+1,j-1);
            d = img2(i+1,j+1);
            %tmp = abs(a-c) - abs(b-d);
            if(abs(a-b)>threshold || abs(a-c)>threshold ||abs(a-d)>threshold)
                ma = max([a b c d]);
                mi = min([a b c d]);
                me = mean([a b c d]);
                if(abs(ma-me)>abs(mi-me))
                    r(i,j) = mi;
                else
                    r(i,j) = ma;
                end
            else
                r(i,j) = (a+b+c+d)/4;
            end       
        end
    end
end
%另一半
for i  = 2:h+3
    for j = 2:w+3
        if((mod(i,2) == 0 && mod(j,2) == 0)||(mod(i,2) == 1 && mod(j,2) == 1))
            a = img2(i-1,j);
            b = img2(i,j+1);
            c = img2(i+1,j);
            d = img2(i,j-1);
            
            if(abs(a-b)>threshold || abs(a-c)>threshold ||abs(a-d)>threshold)
                ma = max([a b c d]);
                mi = min([a b c d]);
                me = mean([a b c d]);
                if(abs(ma-me)>abs(mi-me))
                    r(i,j) = mi;
                else
                    r(i,j) = ma;
                end
            else
                r(i,j) = (a+b+c+d)/4;
            end
        end
    end
end

%蓝色通道插值,
%对角线
for i  = 2:h+3
    for j = 2:w+3
        if(mod(i,2) == 1 && mod(j,2) == 0)
            a = img2(i-1,j-1);
            b = img2(i-1,j+1);
            c = img2(i+1,j-1);
            d = img2(i+1,j+1);
           
            if(abs(a-b)>threshold || abs(a-c)>threshold ||abs(a-d)>threshold)
                ma = max([a b c d]);
                mi = min([a b c d]);
                me = mean([a b c d]);
                if(abs(ma-me)>abs(mi-me))
                    b_channel(i,j) = mi;
                else
                    b_channel(i,j) = ma;
                end
            else
                b_channel(i,j) = (a+b+c+d)/4;
            end
        end
    end
end
%另一半
for i  = 2:h+3
    for j = 2:w+3
        if((mod(i,2) == 0 && mod(j,2) == 0)||(mod(i,2) == 1 && mod(j,2) == 1))
            a = img2(i-1,j);
            b = img2(i,j+1);
            c = img2(i+1,j);
            d = img2(i,j-1);
            
            if(abs(a-b)>threshold || abs(a-c)>threshold ||abs(a-d)>threshold)
                ma = max([a b c d]);
                mi = min([a b c d]);
                me = mean([a b c d]);
                if(abs(ma-me)>abs(mi-me))
                    b_channel(i,j) = mi;
                else
                    b_channel(i,j) = ma;
                end
            else
                b_channel(i,j) = (a+b+c+d)/4;
            end
        end
    end
end

%绿色插值
for i  = 2:h+3
    for j = 2:w+3
        if((mod(i,2) == 0 && mod(j,2) == 1)||(mod(i,2) == 1 && mod(j,2) == 0))
            a = img2(i-1,j);
            b = img2(i,j+1);
            c = img2(i+1,j);
            d = img2(i,j-1);
            
            if(abs(a-b)>threshold || abs(a-c)>threshold ||abs(a-d)>threshold)
                ma = max([a b c d]);
                mi = min([a b c d]);
                me = mean([a b c d]);
                if(abs(ma-me)>abs(mi-me))
                    g(i,j) = mi;
                else
                    g(i,j) = ma;
                end
            else
                g(i,j) = (a+b+c+d)/4;
            end
        end
    end
end
%截取结果
result = cat(3,r(3:h+2,3:w+2),g(3:h+2,3:w+2),b_channel(3:h+2,3:w+2))/256;