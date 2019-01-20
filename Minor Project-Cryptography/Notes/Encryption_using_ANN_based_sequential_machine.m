clc;
clear all;
close all;
inputs_x=3; %------------------------no. of bits of data
output_x=3;
statx=2; %-------------------no. of states
% ------------------------ no of bits for states
for tem=1:100
    if 2^tem >=statx
        states=tem;
        break
    end
end
hls=6; % size of the hidden layer
% -------------------------- weight initialization
w1=rand(hls,(inputs_x+states+1));
w2=rand((output_x+states),hls+1);
neta=1;
a=1;
sx=0;
p=[];
training_setx=[];
training_setx=[0 0 0 0; 0 0 1 0; 0 1 0 0; 0 1 1 0;1 0 0 0;1 0 1 0;1 1 0 0;1 1 1 0; 0 0 0 1; 0 0 1 1; 0 1 0 1; 0 1 1 1;1 0 0 1;1 0 1 1;1 1 0 1;1 1 1 1];
training_outx=[0 0 1 1; 0 1 0 1; 0 1 1 1;1 0 0 1;1 0 1 1;1 1 0 1;1 1 1 1;0 0 0 1; 0 1 0 0; 0 1 1 0;1 0 0 0; 1 0 1 0;1 1 0 0;1 1 1 0; 0 0 0 0; 0 0 1 0];
for x=1:10000
    training_set=training_setx(a,:);
    training_out=training_outx(a,:);
    % --------------------------- output hidden layer
    inputu=[1 training_set];
    sum_h=(w1*(inputu)')';
    o_h=1./(1+exp(-sum_h));
    % --------------------------- output layer
    input_h=[1 o_h];
    sum_out=(w2*(input_h)')';
    out=1./(1+exp(-sum_out));
    % ---------------------------- delta
    delta_out=(out.*(1-out)).*(training_out - out);
    delta_h=(delta_out*w2).*input_h.*(1-input_h);
    % update of weight --------------------------
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
plot(p.*p);
%set=[-1 -1 -1];
% testing the program
statx=input('starting state ');
ipo = input('enter word ','s');
finp=[];
for i=1:length(ipo)
    b=ipo(i);
    switch b
        case('A')
            set=[0 0 0];
        case('B')
            set=[0 0 1];
        case('C')
            set=[0 1 0];
        case('D')
            set=[0 1 1];
        case('E')
            set=[1 0 0];
        case('F')
            set=[1 0 1];
        case('G')
            set=[1 1 0];
        case('H')
            set=[1 1 1];
    end
    %ipox=set;
    %ipox=ipox+[statx];
    %print(ipox);
    ipox=[set statx];
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
    finp=[finp;out1];
    tempch=[];
    statx=out1( (output_x + 1):(output_x+states));
end
outzs=[''];
for f=1:length(ipo)
    tempch=finp(f,:);
    tempch=tempch(1:3);
    if tempch==[0 0 0]
        outzs=[outzs 'A'];
    end
    if tempch==[0 0 1]
        outzs=[outzs 'B'];
    end
    if tempch==[0 1 0]
        outzs=[outzs 'C'];
    end
    if tempch==[0 1 1]
        outzs=[outzs 'D'];
    end
    if tempch==[1 0 0]
        outzs=[outzs 'E'];
    end
    if tempch==[1 0 1]
        outzs=[outzs 'F'];
    end
    if tempch==[1 1 0]
        outzs=[outzs 'G'];
    end
    if tempch==[1 1 1]
        outzs=[outzs 'H'];
    end
end
outzs