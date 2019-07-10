% fill from the front with the row priority
P=evalin('base','P'); 
if any(P > 186)
   error('\n Error !! ,We can not accomodate more than 186 passengers, you have entered extra %d passengers',P-186)
end
x= 31;
b1=3; 
M = ceil(P/6);
A=zeros(x,b1);
C=zeros(x,b1);
B=zeros(x,1);
D1=zeros(x,7);
D=[A B C];
%[rows,columns]=size(D);
        p0 = M;
        for i=1:p0
        D(i,1:1)=1;
        end
       p1=(P-p0);
       p10=ceil(p1/5);
        for i=1:p10
        D(i,3:3)=1;
        end      
       p2=(P-(p0+p10));
       p20=ceil(p2/4);
        for i=1:p20
        D(i,7:7)=1;
        end
       p3=(P-(p0+p10+p20));
       p30=ceil(p3/3);
        for i=1:p30
        D(i,5:5)=1;
        end     
       p4=(P-(p0+p10+p20+p30));
       p40=ceil(p4/2);
        for i=1:p40
        D(i,2:2)=1;
        end
       p5=(P- (p0+p10+p20+p30+p40));
       p50=ceil(p5/1);
        for i=1:p50
        D(i,6:6)=1;
        end
       p6=(P- (p0+p10+p20+p30+p40+p50));
        for i=x:1
            for j=1:x
                for k=1:7
                    D1(i,k)=D(x,k);
                end
            end
        end
 for i=1:x
      A(i,1:3)=D(i,1:3);
      C(i,1:3)=D(i,5:7);
 end
assignin('base', 'A', A)
assignin('base', 'C', C)
assignin('base', 'B', B)
 O=D
 save('work02','-append','A','B','C');
 clear x b1 D D1 M i p0 p1 p10 p2 p20 p3 p30 p4 p40 p5 p50 p6 




