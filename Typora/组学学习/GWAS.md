https://pbreheny.github.io/adv-gwas-tutorial/index.html





##### SNP质控

先对样本进行缺失质控再对SNP进行缺失质控

```
plink --file test_data --geno 0.02 --recode --out test1
plink --file test1 --mind 0.02 --recode --out test2
```

