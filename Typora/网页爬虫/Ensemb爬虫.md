





https://bioconductor.org/packages/release/bioc/vignettes/biomaRt/inst/doc/accessing_ensembl.html

https://bioconductor.org/packages/release/bioc/manuals/biomaRt/man/biomaRt.pdf



#### 基因信息

##### 1 连接biomart

```R
library(biomaRt)
# 列出可以使用的biomart数据库
listEnsembl(mirror = "asia")
# 连接biomart数据库
ensembl <- useEnsembl(biomart = "genes", mirror = "asia", , version = 104)
# 列出可以使用的datasets
listDatasets(ensembl)
# 搜索dataset条目
searchDatasets(mart = ensembl, pattern = "btaurus")
# 使用指定的dataset
ensembl <- useDataset(dataset = "btaurus_gene_ensembl", mart = ensembl)
# 列出版本信息
listEnsemblArchives()

# 直接使用biomart数据库中的指定dataset
ensembl <- useEnsembl(biomart = "genes", dataset = "btaurus_gene_ensembl", mirror = "asia", version = 104)
```



##### 2 获取基因信息

> The `getBM()` function is the primary query function in biomaRt. It has four main arguments:
>
> - `attributes`: is a vector of attributes that one wants to retrieve (= the output of the query).（结果展示的列）
> - `filters`: is a vector of filters that one wil use as input to the query.（指定用于索引的列）
> - `values`: a vector of values for the filters. In case multple filters are in use, the values argument requires a list of values where each position in the list corresponds to the position of the filters in the filters argument (see examples below). （准备搜索的值）
> - `mart`: is an object of class `Mart`, which is created by the `useEnsembl()` function.（连接的biomart数据库）



```R
library(biomaRt)
ensembl <- useEnsembl(biomart = "genes", dataset = "btaurus_gene_ensembl", mirror = "asia", version = 104)
getBM(attributes = c("ensembl_transcript_id"), filters = "ensembl_transcript_id", values = c("ENSBTAT00000076619"), mart = ensembl)
# 列出attributes和filters信息
searchAttributes(mart = ensembl, pattern = "id")
searchFilters(mart = ensembl, pattern = "id")
```





##### 连接参考基因组biomart

```R
# 列出biomart
listEnsemblGenomes()
# 连接biomart数据库
ensembl <- useEnsemblGenomes(biomart = "plants_mart") # 即各物种大类
# 列出可以使用的datasets
listDatasets(ensembl)
# 搜索dataset条目
searchDatasets(mart = ensembl, pattern = "Arabidopsis")
# 使用指定dataset
ensembl <- useDataset(dataset = "athaliana_eg_gene", mart = ensembl)

ensembl <- useEnsemblGenomes(biomart = "plants_mart", dataset = "athaliana_eg_gene") #(貌似没有版本和镜像信息)
```

