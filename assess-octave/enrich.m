
Out=[];

ex=1;

s=size(C);
n=s(2);

for c=1:n,
M=[];
Cors=C(:,c);
[Cors,I]=sort(Cors);
Cors=flipud(Cors);

for p=1:q,
Nh=sum(listind(p,:));
for i=1:length(I),
        sortL(i)=D(I(i));
	li(p,i)=listind(p,I(i));
end
L=fliplr(sortL);;
li=fliplr(li(p,:));

N=length(L);


NR=[];
Z=[];
One=[];
Score=[];

Score=[Cors,li'];
One=find(Score(:,2)==1);
Z=find(Score(:,2)==0);
NR(One)=abs(Cors(One).^ex);
NR=sum(NR);
Score(Z,2)=-1/(N-Nh);
Score(One,2)=abs(Score(One,1).^ex)/NR;
S=cumsum(Score(:,2),1);

Smax=max(S);
Smin=min(S);
if(abs(Smax)>abs(Smin))
	ES=Smax;
else
	ES=Smin;
end
M=[M;ES];
end

Out=[Out,M];
end


