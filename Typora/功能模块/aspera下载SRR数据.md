```
# input

run=$1 ; wd=$2
keyfile=/share/home/yzwl_zhouy/software/aspera-3.7.4/etc/asperaweb_id_dsa.openssh

# output

outfolder=${wd}/${run} ; mkdir -p ${outfolder}
tsv=${outfolder}/${run}.tsv
url="https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${run}&result=read_run&fields=run_accession,fastq_md5,fastq_aspera&format=tsv&download=true&limit=0"

echo "step1：从ebi中下载run详细信息" 
wget -c ${url} -O ${tsv} 
if [ -s "${fastq_aspera}" ] ; then echo "失败, 未获得${run_accession}" ; exit ; fi

echo "step2：aspera下载fastq数据" 
awk 'NR>1' ${tsv} | while IFS=$'\t' read -r run_accession fastq_md5 fastq_aspera
do
  fq=${outfolder}/${run_accession}.fq.gz
  num=0
  if [ "${fastq_aspera}" == "" ] ; then echo "下载失败, ${run_accession}无效" ; break ; fi
  while true
  do
    num=$((num+1))
    if [ ${num} -gt 5 ] ; then echo "${run_accession}下载失败, 已多次尝试" ; break ; fi

    if [ ! -f ${fq} ] || [ `md5sum ${fq} | awk '{print $1}'` != "${fastq_md5}" ] ; then
      echo "第${num}次下载" 
      time ascp -vQT -l 500M -P33001 -k 1 -i ${keyfile} era-fasp@${fastq_aspera} ${outfolder}/${run_accession}.fq.gz
    else
      echo "成功下载${run_accession}数据, 第${num}次成功"
      break
    fi

  done
done
```

