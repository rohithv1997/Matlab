clear all;
close all;
clc;
% imp=im2uint8(imread('After_Encryption.bmp'));
imp=im2uint8(imread('ngc6543a.jpg'));
image(imp);
imwrite(imp,'Actual_Image.bmp','bmp');
imp=imcrop(imp);
imwrite(imp,'Before_Encryption.bmp','bmp');
tmphj=input('Paused. Enter to continue');
op=im2double(imread('Before_Encryption.bmp'));
image(op);
tmphj=input('Paused. Enter to continue');
sz=size(imp);
aaa=[];
l=1;
for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            aaa(l)=imp(i,j,k);
            l=l+1;
        end
    end
end
% input -------------------------------------------------------------------
inp=horzcat(aaa,sz);

%inp=input('Enter nos/');
%inp=[11 23 37 45 68 25 236 58 59 90]
for i=1:length(inp)
    inpx(i,:)=bitget(inp(i),8:-1:1);
end
% generating a chaotic sequence -------------------------------------------
l=length(inp);
x(1)=input('x(0)? ');
mu=input('mu? ');
%x(1)=0.75
%mu=3.9
for i=2:l
    x(i)=mu*x(i-1)*(1-x(i-1));
end
x=uint8(((x-min(x))/max(x))*255);
b=[];
for i=1:l
    b(i,:)= bitget(x(i),8:-1:1);
end
temp=0;
outx=zeros(1,length(inp));
% network -----------------------------------------------------------------
for c=1:length(inp)
    for i=1:8
        for j=1:8
            if (b(c,i)==0)&(i==j)
                weight(i,j)=1;
            elseif (b(c,i)==1)&(i==j)
                weight(i,j)=-1;
            elseif i~=j
                weight(i,j)=0;
            end
        end
        if (b(c,i)==0)
            theta(i)=-1/2;
        else theta(i)=1/2;
        end
    end
    for i=1:8
        dx(c,i) = hardlim(sum(weight(i,:).*inpx(c,:))+theta(i));
    end
    for i=1:8
        outx(c)=outx(c)+uint8(dx(c,i))*(2^(8-i));
    end
end
outx
j=1;
l=1;
imprtw=[];
for i=length(outx)-2:length(outx)
    szw(j)=outx(i);
    j=j+1;
end;
szw(3)=3;
for i=1:szw(1)
    for j=1:szw(2)
        for k=1:szw(3)
            imprtw(i,j,k)=outx(l);
            if(l<length(outx))
                l=l+1;
            end
        end
    end
end
ix=double(imprtw)/255;
image(ix);
imwrite(ix,'After_Encryption.bmp','bmp');