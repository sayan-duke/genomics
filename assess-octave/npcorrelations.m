%clear all;

%load expression.txt; 
%y=expression; 
          
%load labels.txt; 
%l=labels; 
[c,ind]=sort(l); 
bins=min(min(c)):max(max(c)); 
[count,Number]=hist(c(:),bins); 
class0=ind(1:count(1)); 
class1=ind(count(1)+1:count(1)+count(2));

classes=sort([class0,class1]);  
x=y(:,classes); 
[genes,samples]=size(x); 

mn=min(x,[],2);
mn=repmat(mn,1,samples);
temp=x-mn;
mx=max(temp,[],2);
mx=repmat(mx,1,samples);
scaled=temp./mx;

looIndex0=find(class0==loo);
looIndex1=find(class1==loo);
class0(looIndex0)=[];
class1(looIndex1)=[];

m1=mean(scaled(:,class0),2);
m2=mean(scaled(:,class1),2);
sd1=std(scaled(:,class0),0,2);
sd2=std(scaled(:,class1),0,2);

pc1=zeros(genes,samples);
pc2=pc1;

mean1=repmat(m1,1,samples);
mean2=repmat(m2,1,samples);
std1=repmat(sd1,1,length(class0));
std2=repmat(sd2,1,length(class1));


for j=1:samples

A=scaled(:,j)<m1;
i=find(A);

X=repmat(scaled(i,j),1,length(class0));
XI=scaled(i,class0);

%integrate 0 to x
One=sum(-(std1(i,:).^2).*exp(-(XI-X).^2./(2*std1(i,:).^2))+std1(i,:).^2.*exp(-(XI.^2)./(2*std1(i,:).^2)),2);
Two=sum(-XI.*sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std1(i,:).^2)),2);
Three=sum(XI.*sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI)./sqrt(2*std1(i,:).^2)),2);
pc1(i,j)=(1./(std1(i,1)*sqrt(2*pi)*length(class0))).*(One+Two+Three);

%integrate x to 1
i=find(A==0);
X=repmat(scaled(i,j),1,length(class0));
XI=scaled(i,class0);
Ones=repmat(1,length(i),length(class0));
ONE=std1(i,:).^2.*exp(-(Ones-XI).^2./(2*std1(i,:).^2))-std1(i,:).^2.*exp(-(X-XI).^2./(2*std1(i,:).^2));
TWO=XI.*sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI-Ones)./sqrt(2*std1(i,:).^2));
THREE=-XI.*sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std1(i,:).^2));
FOUR=-sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI-Ones)./sqrt(2*std1(i,:).^2));
FIVE=sqrt(2*std1(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std1(i,:).^2));
pc1(i,j)=sum((ONE+TWO+THREE+FOUR+FIVE),2)./(length(class0)*std2(i,1)*sqrt(2*pi));

end

 
for j=1:samples
A=scaled(:,j)<m2;
i=find(A);
 
X=repmat(scaled(i,j),1,length(class1));
XI=scaled(i,class1);
 
%integrate 0 to x
One=sum(-(std2(i,:).^2).*exp(-(XI-X).^2./(2*std2(i,:).^2))+std2(i,:).^2.*exp(-(XI.^2)./(2*std2(i,:).^2)),2);
Two=sum(-XI.*sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std2(i,:).^2)),2);
Three=sum(XI.*sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI)./sqrt(2*std2(i,:).^2)),2);
pc2(i,j)=(1./(std2(i,1)*sqrt(2*pi)*length(class1))).*(One+Two+Three);

 
i=find(A==0);
X=repmat(scaled(i,j),1,length(class1));
XI=scaled(i,class1);
Ones=repmat(1,length(i),length(class1));
 
%integrate x to 1
ONE=std2(i,:).^2.*exp(-(Ones-XI).^2./(2*std2(i,:).^2))-std2(i,:).^2.*exp(-(X-XI).^2./(2*std2(i,:).^2));
TWO=XI.*sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI-Ones)./sqrt(2*std2(i,:).^2));
THREE=-XI.*sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std2(i,:).^2));
FOUR=-sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI-Ones)./sqrt(2*std2(i,:).^2));
FIVE=sqrt(2*std2(i,:).^2*pi).*.5.*erf((XI-X)./sqrt(2*std2(i,:).^2));
pc2(i,j)=sum((ONE+TWO+THREE+FOUR+FIVE),2)./(length(class1)*std2(i,1)*sqrt(2*pi));

end

t=zeros(size(x));
b=zeros(size(x));
compare=mean1>mean2;
i=find(compare);
t(i)=pc1(i)+.000001;
b(i)=pc2(i)+.000001;
j=find(compare==0);
t(j)=pc2(j)+.000001;
b(j)=pc1(j)+.000001;

logp=log(t./b);


