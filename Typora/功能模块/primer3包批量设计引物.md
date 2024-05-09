使用python的primer3包批量设计引物，引物条件可以参照陈连福的生信博客 [primer3设计引物详解](http://www.chenlianfu.com/?tag=primer)

##### 代码

```python
# python3.10版本的primer3

from primer3 import design_primers
import pyfastx
import pandas as pd

PRIMER_PARAMETERS = {
    'PRIMER_OPT_SIZE': 20,
    'PRIMER_PICK_INTERNAL_OLIGO': 1,
    'PRIMER_INTERNAL_MAX_SELF_END': 8,
    'PRIMER_MIN_SIZE': 18,
    'PRIMER_MAX_SIZE': 25,
    'PRIMER_OPT_TM': 60.0,
    'PRIMER_MIN_TM': 55.0,
    'PRIMER_MAX_TM': 65.0,
    'PRIMER_PAIR_MAX_DIFF_TM': 4.0, # 两个引物之间的 TM 值最多相差4摄氏度
    'PRIMER_MIN_GC': 40.0,
    'PRIMER_MAX_GC': 60.0,
    'PRIMER_MAX_POLY_X': 100,
    'PRIMER_INTERNAL_MAX_POLY_X': 100,
    'PRIMER_SALT_MONOVALENT': 50.0,
    'PRIMER_DNA_CONC': 50.0,
    'PRIMER_MAX_NS_ACCEPTED': 0,
    'PRIMER_MAX_SELF_ANY': 12,
    'PRIMER_MAX_SELF_END': 8,
    'PRIMER_PAIR_MAX_COMPL_ANY': 12,
    'PRIMER_PAIR_MAX_COMPL_END': 8,
    'PRIMER_PRODUCT_SIZE_RANGE': [100, 300],
    'PRIMER_NUM_RETURN': 50
    }

def designPrimer(name, seq):
    # primer3设计引物
    primers = design_primers(
        {
            'SEQUENCE_ID': name,
            'SEQUENCE_TEMPLATE': seq,
            'SEQUENCE_INCLUDED_REGION': [0, len(seq)-1]
        }, PRIMER_PARAMETERS
    )

    # 处理输出结果
    dfs = pd.DataFrame()
    for PRIMER_LEFT, PRIMER_RIGHT, PRIMER_PAIR, PRIMER_INTERNAL in zip(primers["PRIMER_LEFT"], primers["PRIMER_RIGHT"], primers["PRIMER_PAIR"], primers["PRIMER_INTERNAL"]):
        df1 = pd.DataFrame([PRIMER_LEFT]) ; df1.columns = [f"LEFT:{i}" for i in df1.columns]
        df2 = pd.DataFrame([PRIMER_RIGHT]) ; df2.columns = [f"RIGHT:{i}" for i in df2.columns]
        df3 = pd.DataFrame([PRIMER_PAIR]) ; df3.columns = [f"PAIR:{i}" for i in df3.columns]
        df4 = pd.DataFrame([PRIMER_INTERNAL]) ; df4.columns = [f"INTERNAL:{i}" for i in df4.columns]
        df = pd.concat([df1, df2, df3, df4], axis=1)
        dfs = pd.concat([dfs, df], axis=0)    
    return dfs


input = "input.fasta"
output = "output.tsv"

fa = pyfastx.Fastx(input)
dfs = pd.DataFrame()
for name, seq in fa:
    df = designPrimer(name, seq)
    df["name"] = name
    dfs = pd.concat([dfs, df], axis=0)
dfs.to_csv(output, header=True, index=False, sep="\t")

```

##### 结果

| LEFT:PENALTY | LEFT:SEQUENCE        | LEFT:COORDS | LEFT:TM  | LEFT:GC_PERCENT | LEFT:SELF_ANY_TH | LEFT:SELF_END_TH | LEFT:HAIRPIN_TH | LEFT:END_STABILITY | RIGHT:PENALTY | RIGHT:SEQUENCE       | RIGHT:COORDS | RIGHT:TM | RIGHT:GC_PERCENT | RIGHT:SELF_ANY_TH | RIGHT:SELF_END_TH | RIGHT:HAIRPIN_TH | RIGHT:END_STABILITY | PAIR:PENALTY | PAIR:COMPL_ANY_TH | PAIR:COMPL_END_TH | PAIR:PRODUCT_SIZE | PAIR:PRODUCT_TM | INTERNAL:PENALTY | INTERNAL:SEQUENCE     | INTERNAL:COORDS | INTERNAL:TM | INTERNAL:GC_PERCENT | INTERNAL:SELF_ANY_TH | INTERNAL:SELF_END_TH | INTERNAL:HAIRPIN_TH | name                                      |
| ------------ | -------------------- | ----------- | -------- | --------------- | ---------------- | ---------------- | --------------- | ------------------ | ------------- | -------------------- | ------------ | -------- | ---------------- | ----------------- | ----------------- | ---------------- | ------------------- | ------------ | ----------------- | ----------------- | ----------------- | --------------- | ---------------- | --------------------- | --------------- | ----------- | ------------------- | -------------------- | -------------------- | ------------------- | ----------------------------------------- |
| 0.107312     | CCTGAAGATGCCCTCCACTG | [674, 20]   | 60.10731 | 60              | 0                | 0                | 0               | 3.66               | 0.034186      | TTCAGCATGGGGATCACCAC | [856, 20]    | 60.03419 | 55               | 21.81495          | 7.824225          | 44.71827         | 4.16                | 0.141499     | 10.30828          | 11.60204          | 183               | 87.58514        | 0.528751         | CTCCCACCTCACCGCGGTCA  | [725, 20]       | 60.52875    | 70                  | 27.17835             | 11.80736             | 26.27753            | lcl\|NC_010451.4_cds_XP_020917933.1_34232 |
| 0.107312     | CCTGAAGATGCCCTCCACTG | [674, 20]   | 60.10731 | 60              | 0                | 0                | 0               | 3.66               | 0.034186      | TTCAGCATGGGGATCACCAC | [856, 20]    | 60.03419 | 55               | 21.81495          | 7.824225          | 44.71827         | 4.16                | 0.141499     | 10.30828          | 11.60204          | 183               | 88.25727        | 0.528751         | CTCCCACCTCACCGCGGTCA  | [725, 20]       | 60.52875    | 70                  | 27.17835             | 11.80736             | 26.27753            | lcl\|NC_010451.4_cds_XP_013854347.2_34233 |
| 0.107312     | CCTGAAGATGCCCTCCACTG | [674, 20]   | 60.10731 | 60              | 0                | 0                | 0               | 3.66               | 0.034186      | TTCAGCATGGGGATCACCAC | [856, 20]    | 60.03419 | 55               | 21.81495          | 7.824225          | 44.71827         | 4.16                | 0.141499     | 10.30828          | 11.60204          | 183               | 86.24088        | 1.511973         | AGGCCTTCTCCACCTGCACCT | [706, 21]       | 59.48803    | 61.90476            | 0                    | 0                    | 26.50055            | lcl\|NC_010451.4_cds_XP_020958366.1_34237 |