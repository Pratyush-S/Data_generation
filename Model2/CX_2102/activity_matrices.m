load('work02');

[Arows,Acolumns]=size(activity);
Aw=zeros(Arows,Acolumns);
for i=1:Arows
    if (strcmpi(activity(i,1),"sitting"))
        Aw(i,1)=0.0058;
    elseif(strcmpi(activity(i,1),"reading"))
        Aw(i,1)=0.0056;
    elseif(strcmpi(activity(i,1),"eating"))
        Aw(i,1)=0.0077;    
    elseif(strcmpi(activity(i,1),"sleeping"))
        Aw(i,1)=0.0048;
    else
        Aw(i,1)=0.0000;
        %fprintf ('Row no. %d has error \n',i)
    end
    Aw(i,2)=cell2mat(activity(i,2));
end
assignin('base','Aw',Aw);
save('work02.mat','-append','Aw');

tcm=Tc*60;
AR=randi(Arows,31,3);
CR=randi(Arows,31,3);
AA={};AC={};catA={};catC={};
[AA{1},catA{1}]=getVal(AR,Aw);
[AC{1},catC{1}]=getVal(CR,Aw);

for i=1:tcm
    [AA{i+1},catA{i+1},AR]=updateAct(AA{i},catA{i},AR,Aw);
    [AC{i+1},catC{i+1},CR]=updateAct(AC{i},catC{i},CR,Aw);
    %D0 = (AA.*A);   %Activity based co2 generation rate matrices
    %D1 = (AC.*C);
    %Da=mat2cell(D0, [5 5 5 5 5 6], 3);
    %Dc=mat2cell(D1, [5 5 5 5 5 6], 3);
    %Invoke functions here to call updation
end
assignin('base','tcm',tcm);
assignin('base','AA',AA);
assignin('base','AC',AC);
save('work02.mat','-append','AA','AC','tcm');


function [X,Y,Z]=updateAct(X,Y,Z,ref)
    [m,n]=size(X);
    for i=1:m
        for j=1:n
            if(Y(i,j)>1)
                Y(i,j)=Y(i,j)-1;
            elseif(Y(i,j)==1)
                Z(i,j)=Z(i,j)+1;
                if(Z(i,j)>4)
                    Z(i,j)=Z(i,j)-4;
                end
                Y(i,j)=60*ref(Z(i,j),2);
                X(i,j)=ref(Z(i,j),1);
            end    
        end
    end
end

function [Y,Z]=getVal(X,ref)
    [m,n]=size(X);
    Y=zeros(m,n);Z=zeros(m,n);
    for i=1:m
        for j=1:n
            Y(i,j)=ref(X(i,j),1);
            Z(i,j)=60*ref(X(i,j),2);
        end
    end
end