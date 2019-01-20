clc;
clear all;
close all;
inputs_x=input('enter the no of inputs');
training_setxm=[];
training_outxm=[];
for c1=0:1
    for inx1=0:2^(inputs_x)-1
        for inx2=0:2^(inputs_x)-1
            temp=inx1+inx2+c1;
            training_outxm=[training_outxm ; bitget(temp,inputs_x+1:-1:1)];
            training_setxm=[training_setxm ; bitget(inx1,inputs_x:-1:1) bitget(inx2,inputs_x:-1:1) c1];
        end
    end
end
training_setx=[];
training_outx=[];
hls=[4 3 1];% size of the hidden layer
% weight initialization----------------------
for v1=1:inputs_x+1
    if v1 == inputs_x+1
        w1=rand(hls(v1),2*(v1-1)+2);
    else
        w1=rand(hls(v1),2*v1+2);
    end
    w2=rand(1,hls(v1)+1);
    neta=0.5;
    a=1;
    sx=0;
    p=[];
    if v1 == inputs_x+1
        training_setx=training_setxm;
    else
        training_setx=[training_setxm(:,inputs_x-v1+1:inputs_x) training_setxm(:,2*inputs_x-v1+1:2*inputs_x+1)];
    end
    training_outx=[training_outxm(:,(inputs_x+1)-v1+1)];
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
        w2 = w2 + neta*delta_out*input_h;
        % hidden layer ----------------------------------
        for t=1:hls(v1)
            w1(t,:) = w1(t,:) + neta*delta_h(t+1)*inputu;
        end
        for t=1:1
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
    figure;
    plot(p.*p);
end