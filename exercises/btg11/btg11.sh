#!/bin/sh

#set -xv

REFGZ=/bluearc/data/schatz/data/genomes/hg19/chromo/chr22.fa.gz
REF=chr22.fa
EXONGZ=/bluearc/data/schatz/data/genomes/hg19/hg19_exons.bed.gz
EXON=chr22_exons.bed
SORT=~/build/packages/coreutils-8.12/bin/sort


if [ ! -r $REF ]
then
  zcat $REFGZ > $REF
fi

if [ ! -r $EXON ]
then
  zcat $EXONGZ | grep '^22' | awk '{print "chr"$0}' > $EXON
  grep -v 'NM_005036_exon_8_0_chr22_46631030_f' $EXON.all > $EXON.keep
  grep 'NM_005036_exon_8_0_chr22_46631030_f' $EXON.all > $EXON.special
fi

if [ ! -r $EXON.keep.sfa ]
then
  fastaFromBed -fi $REF -bed $EXON.keep -name -tab -s -fo $EXON.keep.sfa.raw
  tr '\t' '|' < $EXON.keep.sfa.raw > $EXON.keep.sfa
fi

SPECIAL=special.fa

if [ ! -r $SPECIAL ]
then
  awk '{print $1"\t"$2"\t"$2+4000}' $EXON.special > $EXON.special.a
  awk '{print $1"\t"$2+4000"\t"$3}' $EXON.special > $EXON.special.b

  fastaFromBed -fi $REF -bed $EXON.special.a -fo $EXON.special.a.fa
  fastaFromBed -fi $REF -bed $EXON.special.b -fo $EXON.special.b.fa

  echo ">ins" > $SPECIAL.raw
  grep -v '>' $EXON.special.a.fa >> $SPECIAL.raw
  grep -v '>' hpv41.fa           >> $SPECIAL.raw
  grep -v '>' $EXON.special.b.fa >> $SPECIAL.raw

  fasta_formatter -w 70 -i $SPECIAL.raw -o $SPECIAL
fi

cov=20
readlen=100

if [ ! -r work ]
then
  mkdir work

   c=0
   for rec in `cat $EXON.keep.sfa`
   do
     c=`echo "$c+1" | bc`
     n=`echo $rec | cut -f1 -d'|'`
     s=`echo $rec | cut -f2 -d'|'`
     l=`echo $s | awk '{print length($1)}'`

     echo "$c $n $l";

     if [ $l -gt 500 ]
     then
       echo ">$n" >  work/$c.fa
       echo "$s"  >> work/$c.fa

       num=`echo "($cov * $l) / (2*$readlen)" | bc`

       echo "$c $n $l $cov $num"

       dwgsim -d 100 -e 0.001-0.05 -N $num -1 100 -2 100 -r .005 -R .5 -z 12345 -X .5 work/$c.fa work/$c >& work/$c.log
     fi
   done
fi

if [ ! -r work/special.bwa.read1.fastq ]
then
 l=`getlengths $SPECIAL | cut -f2 -d' '`
 num=`echo "($cov * $l) / (2*$readlen)" | bc`
 echo "$c $n $l $cov $num"
 dwgsim -d 100 -e 0.001-0.05 -N $num -1 100 -2 100 -r .005 -R .5 -z 12345 -X .5 $SPECIAL work/special >& work/special.log
fi

if [ ! -r read1.fq ]
then
  cat work/*.bwa.read1.fastq > read1.fq.raw
  cat work/*.bwa.read2.fastq > read2.fq.raw

  fastq_rename -renum -suffix /2 < read1.fq.raw > read1.fq
  fastq_rename -renum -suffix /2 < read2.fq.raw > read2.fq
fi


D=btg11
rm -rf $D
mkdir $D
cp read1.fq read2.fq $EXON $REF README.txt $D/
tar czvf $D.tgz $D

