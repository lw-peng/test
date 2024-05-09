##### 一般热图

    library(pheatmap)
    plot_heatmap <- function(df) {
        p <- pheatmap(df,
                    # cellwidth=100, cellheight=18,
                    fontsize=15, 
                    # labels_col=groups,
                    angle_col="45", 
                    # cluster_cols = FALSE,
                    show_rownames = FALSE,
                    border_color = "black",
                    #display_number=T,
                    color=colorRampPalette(c("#4576B4", "white", "#DA3428"))(50),
                    # color=colorRampPalette(c("white", "#DA3428"))(50),
                    main = ""
                    )
        return(p)
    }
    
    df <- read.table("gene_expression.tsv", header=TRUE, sep="\t", row.names=1)
    tiff(file.path(wd, "OR_expression.heatmap.tiff"), width=96, height=48, units="cm", res=600, compression="lzw")
    plot_heatmap(df)
    dev.off()



##### 分组热图

```R
library(pheatmap)

# Dimension reduction
library(ggplot2)
library(ggsci)
df <- read.table("/home/zhangxiaolian/task/3_window_process/00_new/filter_1000bp_window.bed",head=T,sep = "\t", nrow=1000)  
# df <- read.table("/home/zhangxiaolian/task/3_window_process/00_new/filter_1000bp_window.bed",head=T,sep = "\t")  

chr_positions <- paste(df$chr, df$start, df$end, sep = "_")
rownames(df) <- chr_positions
df <- df[, -(1:3)]

tissues <- sapply(strsplit(colnames(df), "\\."), function(x) x[1])
annotation_col = data.frame(tissue=tissues, row.names=colnames(df))

tissues <- unique(tissues) # a->z
colors <- pal_d3(palette = c("category20"), alpha = 1)(16)
names(colors) <- tissues
tissue2color <- list(tissue=colors)
tissue2color

tiff('/home/zhangxiaolian/task/3_window_process/00_new/plot/8.tiff', width=20, height=30, units="cm", res=600, compression="lzw")
pheatmap(df, annotation_col=annotation_col, annotation_colors=tissue2color, cluster_cols = FALSE,show_colnames = FALSE,show_rownames = FALSE) # 列保持不变
dev.off()  

```





##### 分组热图

将指定组织分成多组，每组颜色域一样，其他组的组织颜色在该组设为white

```R
import pandas as pd
from more_itertools import chunked
df = pd.read_table("sample2tissue.tsv", header=0, sep="\t")
tissues = df["tissue"].drop_duplicates().tolist()
n = 0
for group in chunked(tissues, 9):
    n += 1
    df[f"group{n}"] = df["tissue"].apply(lambda tissue: tissue if tissue in group else "white")
    print(group)
    print(n)
df = df.drop(columns=["tissue"])
df.to_csv("grouped_tissue.tsv", header=True, index=False, sep="\t")
```

绘制分组热图

```R
library(pheatmap)
plot_heatmap <- function(df, df_row, df_col, color_list, tissue) {
    p <- pheatmap(df,
                # cellwidth=100, cellheight=18,
                fontsize=6, 
                # labels_col=groups,
                angle_col="90", 
                #cluster_cols = FALSE,
                cluster_rows = FALSE,
                show_rownames = FALSE,
                show_colnames = FALSE,
                border_color = "black",
                #display_number=T,
                color=colorRampPalette(c("#4576B4", "white", "#DA3428"))(50),
                # color=colorRampPalette(c("white", "#DA3428"))(50),
                main = tissue,
                annotation_row = df_row, 
                annotation_col = df_col,
                annotation_colors = color_list
                )
    return(p)
}
df_row <- read.table("gene2community.tsv", header=TRUE, sep="\t", row.names=1)
df_col <- read.table("grouped_tissue.tsv", header=TRUE, sep="\t", row.names=1)
genes <- rownames(df_row)[order(df_row$community)]
df0 <- read.table("sample2tissue.tsv", header=TRUE, sep="\t", row.names=1)
df <- read.table("gene_expression.tsv", header=TRUE, sep="\t", row.names=1)
df = df[genes, ]
df <- log10(df + 0.01)

color_list <- list()
colors <- c('white', '#e6194B', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#42d4f4', '#f032e6', '#fabed4')
for (group in colnames(df_col)) {
    tissues <- unique(df_col[group])
    names(colors) <- c("white", tissues[tissues!="white"])
    color_list[[group]] <- colors
}

tiff("gene_expression.heatmap.tiff", width=72, height=48, units="cm", res=600, compression="lzw")
plot_heatmap(df, df_row, df_col, color_list, "All")
dev.off()

```

