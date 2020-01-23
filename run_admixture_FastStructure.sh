#pipeline for data cooking by Fabian Salgado
module load plink/1.90
module load admixture/1.3.0
#use this pipeline to remove duplicates

LC_ALL=C sort -t $'\t' -k1,1 -k2,2n -k4,4  <your_vcf> | awk -F '\t' '/^#/ {print;prev="";next;} {key=sprintf("%s\t%s\t%s",$1,$2,$4);if(key==prev) next;print;prev=key;}' > no_duplicates.vcf

#next, use plink to create an input for admixture

#look for sites that are not in equilibrium

plink --vcf 090_filtered_without_outgroups.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --indep-pairwise 50 10 0.1 --out archivo.intermedio --vcf-idspace-to "-"

#prune the sites

plink --vcf 090_filtered_without_outgroups.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --extract archivo.intermedio.prune.in --make-bed --out unlinked_090_polythore --vcf-idspace-to "-"

###run admixture

#if your chromose labels has special character such as "_" remove those, admixture just receive integers as input. run the following command to prune the chromosome name=

sed -i 's/_//g' unlinked_090_polythore.bim
sed -i 's/locus//g' unlinked_090_polythore.bim

## run Admixture!
for K in 1 2 3 4 5 6 7 8 9 10;  do admixture --cv=10 unlinked_090_polythore.bed $K | tee log${K}.out; done

###Choose the best K

for i in $(ls log*);do
grep "K=" $i | cut -f 3,4 -d " " | sed -r 's/:/=/g' >> bestk.txt; done

#after choose your best K, run the following:


#for fastStructure




#transform bim file again to a vcf

plink --bfile gasteracantha --double-id --allow-extra-chr --set-missing-var-ids @:# --recode vcf --out filter_linked.vcf