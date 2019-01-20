clc;
clear all;
close all;
inputs_x=input('enter the no of inputs');
training_setx=[];
training_outx=[];
for c1=0:1
    for inx1=0:2^(inputs_x)-1
        for inx2=0:2^(inputs_x)-1
            temp=inx1+inx2+c1;
            training_outx=[training_outx ; bitget(temp,inputs_x+1:-1:1)];
            training_setx=[training_setx ; bitget(inx1,inputs_x:-1:1) bitget(inx2,inputs_x:-1:1) c1];
        end
    end
end
hls=12;% size of the hidden layer
% weight initialization----------------------
w1=rand(hls,2*inputs_x+2);
w2=rand(inputs_x+1,hls+1);
neta=0.5;
a=1;
sx=0;
p=[];
for x=1:15000
    training_set=training_setx(a,:);
    training_out=training_outx(a,:);
    % output hidden layer---------------------
    inputu=[1 training_set];
    sum_h=(w1*(inputu)')';
    o_h=1./(1+exp(-sum_h));
    % output layer ---------------------------
    input_h=[1 o_h];
    sum_out=(w2*(input_h)')';
    out=1./(1+exp(-sum_out));
    % delta ------------------------------------
    delta_out=(out.*(1-out)).*(training_out - out);
    delta_h=(delta_out*w2).*input_h.*(1-input_h);
    % update of weight --------------------------
    % output layer --------------------------------
    for t=1:(inputs_x+1)
        w2(t,:) = w2(t,:) + neta*delta_out(t)*input_h;
    end
    % hidden layer ----------------------------------
    for t=1:hls
        w1(t,:) = w1(t,:) + neta*delta_h(t+1)*inputu;
    end
    for t=1:inputs_x+1
        if out(t)>=0.7
            out1(t)=1;
        elseif out(t)<=0.2
            out1(t)=0;
        else out1(t)=out(t);
        end
    end
    p=[p mean((out-training_out).^2)];
    if out1==training_out
        a=a+1;
        sx=sx+1;
    end
    if a > ((2^(inputs_x))^2)*2
        a=a-((2^(inputs_x))^2)*2;
    end
end
plot(p.*p);