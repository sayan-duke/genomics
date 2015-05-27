print "Enter expression gct file name (including .gct): ";
$expressionFile=<STDIN>;
chomp($expressionFile);
print "Enter phenotype label file name (including .cls): ";
$labelFile=<STDIN>;
chomp($labelFile);
print "Enter geneset gmt file name (including .gmt): ";
$genesetFile=<STDIN>;
chomp($genesetFile);

open(EXP,$expressionFile);
open(LAB,$labelFile);
open(GEN,$genesetFile);

#create file with only expression data, expression.txt,  and a descriptor list @D
@D;
open(EXPOUT, "> expression.txt");
<EXP>;
<EXP>;
<EXP>;
while(<EXP>){
	chomp($_);
	@temp=split("\t",$_);
	push(@D,$temp[0]);
	for ($i=2; $i<scalar @temp; $i++){
		print EXPOUT $temp[$i]."\t"}
	print EXPOUT "\n";
}

#create file with only class labels
<LAB>;
<LAB>;
open(LABOUT, "> labels.txt");
print LABOUT <LAB>;

#create file where each row is a geneset and each column is a gene from the expression data.  A 0 indicates that the gene is not in the geneset and a 1 indicates that the gene is in the geneset. 
@listind;
while(<GEN>){
%seen=();
chomp($_);
@set=split("\t",$_);
foreach $item (@set) { $seen{$item} = 1}
foreach $item (@D) {
	if ( $seen{$item}==1){ #it's in %seen
		push(@listind,1)}
	else {push(@listind,0)}
}
}

$numSets=(scalar @listind)/(scalar @D);
$sizeD=scalar @D;

open(OUT,"> listind.txt");

for ($j=0; $j<$numSets; $j++){
for ($i=0; $i<scalar @D; $i++){
print OUT $listind[$j*$sizeD+$i]."\t";
}
print OUT "\n";
}


