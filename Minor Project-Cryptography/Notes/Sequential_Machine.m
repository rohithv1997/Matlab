clc;
clear all;
close all;
inputs_x=input('enter the no of inputs');
output_x=input('enter the no of output');
statx=input('enter the no of states');
% no of bits for states
for tem=1:100
    if 2^tem >=statx
        states=tem;
        break
    end
end
hls=5;
%2^(inputs_x+output_x+2); % size of the hidden layer
% weight initialization----------------------
w1=rand(hls,(inputs_x+states+1));
w2=rand((output_x+states),hls+1);
neta=1;
a=1;
sx=0;
p=[];
for tex=1:(2^(inputs_x)*statx);
    training_setx(tex,:)=input('enter input and state');
    training_outx(tex,:)=input('enter output and state');
end
for x=1:7000
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
    % update of weight -------------------------
    % output layer --------------------------------
    for t=1:(output_x+states)
        w2(t,:) = w2(t,:) + neta*delta_out(t)*input_h;
    end
    % hidden layer ----------------------------------
    for t=1:hls
        w1(t,:) = w1(t,:) + neta*delta_h(t+1)*inputu;
    end
    for t=1:(output_x+states)
        if out(t)>=0.7
            out1(t)=1;
        elseif out(t)<=0.2
            out1(t)=0;
        else out1(t)=out(t);
        end
    end
    p=[p sum(out-training_out)];
    if out1==training_out
        a=a+1;
        sx=sx+1;
    end
    if a > ((2^inputs_x)*statx)
        a=a-((2^inputs_x)*statx);
    end
end
plot(p);
% testing the program
statx=zeros(1,states);
zaz='y';
for xz=1:10
    ipo = input('enter the input');
    ipox=[ipo statx];
    inputp=[1 ipox];
    sum_h=(w1*(inputp)')';
    o_h=1./(1+exp(-sum_h));
    % output layer ---------------------------
    input_h=[1 o_h];
    sum_out=(w2*(input_h)')';
    out=1./(1+exp(-sum_out));
    for t=1:(states+output_x)
        if out(t)>=0.7
            out1(t)=1;
        elseif out(t)<=0.2
            out1(t)=0;
        else out1(t)=out(t);
        end
    end
    out1
    statx=out1( (output_x + 1):(output_x+states));
end