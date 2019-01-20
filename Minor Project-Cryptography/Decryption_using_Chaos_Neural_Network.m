clear all;
close all;
clc;
inp=input('Data?\n');
% input -------------------------------------------------------------------
%inp=[145 130 187 161 233 114 60 58 88 137]
for i=1:length(inp)
    inpx(i,:)=bitget(inp(i),8:-1:1);
end
% generating a chaotic sequence -------------------------------------------
l=length(inp);
x(1)=input('x(0)?  ');
%x(1)=0.75
mu=input('mu?  ');
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
imprt=[];
for i=length(outx)-2:length(outx)
    sz(j)=outx(i);
    j=j+1;
end;
for i=1:sz(1)
    for j=1:sz(2)
        for k=1:sz(3)
            imprt(i,j,k)=outx(l);
            if(l<length(outx))
                l=l+1;
            end
        end
    end
end
ix=double(imprt)/255;
image(ix);
imwrite(ix,'After_Decryption.bmp','bmp');