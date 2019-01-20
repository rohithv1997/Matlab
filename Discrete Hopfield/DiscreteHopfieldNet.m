w=[0]; n2=0; flag=1; count=0; x=[0]; b=[0]; yin=[-2 -2 -2 -2]; ce=0; e=0;

disp('DISCRETE HOPFIELD NETWORK (No Self Connections)');
ch=input('Enter 1 for Binary Input, 2 for Bipolar Input:   ');

if(ch~=1 && ch~=2)
    disp('Wrong Choice :( ');
    g=input('Press any key to Exit!!');
    break;
end;

n=input('Enter No.of Input Vectors: ');
if(n<1)
    disp('Inadequate No. of Vectors');
    g=input('Press any key to Exit!!');
    break;
end;

for I=1:n
    if(ch==1)
        a=input('Enter The Input Vector to be Stored in Binary form: ');
        for j=1:length(a)
            if(a(j)~=0 && a(j)~=1)
                disp('Input other than 0 / 1 :(');
                g=input('Press any key to Exit!!');
                break;
            end;
            a(j)=2*a(j)-1;
        end;
    elseif (ch==2)
        a=input('Enter The Input Vector to be Stored in Bipolar form: ');
        for j=1:length(a)
            if(a(j)~=-1 && a(j)~=1)
                disp('Input other than 1 / -1 :(');
                g=input('Press any key to Exit!!');
                break;
            end;
        end;  
    end;
    n2=n2+1; 
    for l=1:length(a)
        b(n2,l)=a(l);
    end;
    t=a'*a;
    for i=1:length(t)
        t(i,i)=0;
    end;
    w=w+t;
    disp('Weight Matrix in Bipolar Form= ');
    disp(w);
end;

if (ch==1)
    x=input('Enter Noisy input in Binary Form: ');
elseif (ch==2)
    x=input('Enter Noisy Input in Bipolar Form: ');
    for i=1:length(x)
        x(i)=(x(i)+1)/2;
    end;
end;

theta=input('Enter Threshold Value: ');
order=input('Enter Index Order for Updating Values: ');
for i=1:length(order)
    for j=i+1:length(order)
        if(order(i)==order(j))
            disp('Redundant Indices given');
            g=input('Press any key to Exit!!');
            break;
        end;
    end;
end;

if(ch==1)
    fprintf('\nStorage Capacity= %f\n',0.15*length(b));
elseif (ch==2)
    fprintf('\nStorage Capacity= %f\n',(length(b)/(2*log2(n))));
end;

y=x;
while flag==1
    flag=0; ce=0; e=0;
    for j=1:length(order)
        i=order(j);
        yin(i)=x(i)+sum(y*w(:,i));
        if yin(i)>theta
            yin(i)=1;
        elseif yin(i)==theta
            yin(i)=theta;
        else
            yin(i)=0;
        end;
        if y(i)~=yin(i)
            flag=1;
        end;
        ce2=yin(i)-x(i);
        y(i)=yin(i);
    end;
    fprintf('\n\nEpoch= %d ',count+1);
    count=count+1;
    fprintf('\ny =');
    disp(y);
    for j=1:length(b)
        e=e+y(j)*w(i,j);
    end;
    ce=-(e+x(i)-theta)*ce2;
    fprintf('Change in Energy= %d\n',ce);
    e=0; e1=0; e2=0; e3=0;
    for k=1:length(b)
        for j=1:length(b)
            if k~=j
                e1=e1+y(k)*y(j)*w(k,j);
            end;
        end;
        e2=e2+x(k)*y(k);
        e3=e3+theta*y(k);
    end;
    e=-0.5*e1-e2+e3;
    fprintf('\nEnergy of the net= %d\n',e);
end;

fprintf('\n'); f2=0;
if(flag==0)
    for i=1:length(y)
        y(i)=2*y(i)-1;
    end;
    for i=1:length(b(1))
        if(y==b(i,:))
            f2=1;
            break;
        end;
    end;
    if(f2==1)
        disp('Known State and Pattern Recollected !!!');
        fprintf('Pattern Recollected = '); 
        if(ch==1)
            
            for i=1:length(y)
                if y(i)==-1
                    y(i)=0;
                end;
            end;
        end;
        disp(y);
    elseif(f2==0)
        disp('Unknown Pattern / Spurious Stable State :(');
        fprintf('Pattern Generated = ');
         if(ch==1)
            for i=1:length(y)
                if y(i)==-1
                    y(i)=0;
                end;
            end;
        end;
        disp(y);
    end;
end;