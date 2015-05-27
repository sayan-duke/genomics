#! /usr/bin/octave -qf
%uses files expression.txt, labels.txt, and listind.txt created from formatForOctave.m 
clear all;

%value from argument line is the test sample. The rest will make up the training set.

argin=argv(1);
loost=cell2mat(argin);
loo=str2num(loost);
load listind.txt;
load labels.txt;
l=labels; 
load expression.txt;
y=expression;

[q,P]=size(listind);
D=1:P;

%nonparametric correlation
npcorrelations

C=logp;

%enrichment calculation
enrich


ES=[Out',l'];
testSample=ES(loo,:);
ES(loo,:)=[];


st1=sprintf('train%s.txt',loost);
save(st1, 'ES')

st2=sprintf('test%s.txt',loost);
save(st2, 'testSample')

quit
