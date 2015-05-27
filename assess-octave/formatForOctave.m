%inputs are expression data as gct file and labels as cls file. Outputs are expression data text file and label text file for use in octave and file "listind.txt" which is a file that indexes which genes from the expression data set are in the genesets.

clear all

%read gct file
infile=input('Enter name of expression gct file: ','s');
strs = textread(infile,'%s','delimiter','\n');
lines = cell(length(strs));
for k = 1:length(strs)
s = strs{k};
lines{k} = strread(s,'%s');
end

P=length(lines);

%create file with only expression data
expression=[];
for i=4:P,
gene=lines{i};
numGene=[];
for j=3:length(gene),
g=cell2mat(gene(j));
g=str2num(g);
numGene=[numGene,g];
end
expression=[expression;numGene];
end

save expression.txt expression -ascii;

%create file with only class labels
infile=input('Enter name of phenotype label cls file: ','s');
l=textread(infile,'%s','delimiter','\n');
labels=cell2mat(l(3));
labels=str2num(labels);
save labels.txt labels -ascii;

%create gene descriptor list
D=[];
for p=4:P,
Line=lines{p};
Line=Line(1:length(Line));
D=[D,Line(1)];
end

%read genesets
infile=input('Enter name of geneset gmt file: ','s');
strs = textread(infile,'%s','delimiter','\n');
genesets = cell(length(strs));
for k = 1:length(strs)
s = strs{k};
genesets{k} = strread(s,'%s');
end
[q,P]=size(genesets);


%create cell matrix for which genes are in geneset, numericSet. Each row is a geneset and contains which genes from original expression data set are in that geneset.

numericSet=[];
for p=1:P,
Set=genesets{p}';
Set=Set(1:length(Set));
L=D;
N=length(Set);
 
t=1;
set=[];
for j=1:N
regex=strcmp(L,Set(j));
        if (sum(regex)==1)
        one=find(regex);
        set(t)=one;
        t=t+1;
        end
        end
 
numericSet{p}=set;
end
 
D=1:length(D);
 
%create matrix where each row is a geneset and each column is a gene from the expression data. A 0 indicated that the gene is not in the geneset and a 1 indicated that the gene is in the geneset.

[q,P]=size(numericSet);
 
listind=[];
emptySets=[];
for p=1:P,
numSet=numericSet{p};
 
if (size(numSet)==0)
emptySets=[emptySets,p];
p=p+1;
numSet=numericSet{p};
end
 
L=D;
 
N=length(L);
 
li=[];
Score=[];
Zeros=[];
 
for j=1:N
regex=(L(j)==numSet);
       if(sum(regex)==1)
                li(j)=1;
                one=find(regex);
                numSet(one)=[];
        end
        if (length(numSet)==0)
                break;
        end
end
 
Zeros=zeros(1,N-j);
li=[li,Zeros];
 
listind=[listind;li];
end
 
save listind.txt listind -ascii;

