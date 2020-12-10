###modified form Joana meier script
mkdir best_runs
for folder in */ ; do
cd $(echo $folder)
m=-1000000000000000
p=$1
c=0
best="xxxx"
diff=0
diffBest=0

for i in run*;
do
 a=$(ls | grep ${p}".tpl" | sed s'/.tpl//')

 # if the file is in the run directory
 if [ -e $i/$a.bestlhoods ]
 then
   l=$(cat $i/$a.bestlhoods | awk '{print $(NF-1)}' | tail -1 | cut -f 1 -d ".")
   diff=$(cat $i/$a.bestlhoods | awk '{print $NF-$(NF-1)}' | tail -1 | cut -f 1 -d ".")
   ((c++))
 else
   # if the file is in a subdirectory
   if [ -e $i/$a/$a.bestlhoods ]
   then
     l=$(cat $i/$a/$a.bestlhoods | awk '{print $(NF-1)}' | tail -1 | cut -f 1 -d ".")
     diff=$(cat $i/$a/$a.bestlhoods | awk '{print $NF-$(NF-1)}' | tail -1 | cut -f 1 -d ".")
     ((c++))
   else
     echo "no .bestlhoods file found in "$i
   fi

 fi


 if [ $l -gt $m ]
 then
   m=$l; x=$i; best=$i;
   diffBest=$diff
 fi
done

if [ -z ${x+1} ]
then echo "Error: No run with lik>-1000000000000000"
else mkdir bestrun
cp $x/* ./bestrun/
cp $x/$a/* ./bestrun/
mv ./bestrun ../best_runs/$a
fi
cd ..
echo -e "\n"$c" bestlhoods files found, "$best" with "$diffBest" Lhood diff fits best."; 
done
