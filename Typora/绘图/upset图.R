library(UpSetR)
df <- read.table("2.plot/group_deletion.upset.tsv", header=T, sep="\t")

tiff("2.plot/group_deletion.upset.tiff", width=36, height=12, units="cm", res=600, compression="lzw")
upset(df, 
    mb.ratio = c(0.55, 0.45), # 控制上方条形图以及下方点图的比例
    nsets=9, 
    keep.order=TRUE, order.by="freq", 
    nintersects=50, 
    line.size=0, point.size = 1,
    # show.numbers=FALSE,
    # number.angles = 45,
    shade.alpha=0, 
    matrix.color="black", main.bar.color="#BC3C29FF", 
    mainbar.y.label="Deletion Number", sets.x.label="Deletion Number in group/cell",
)
dev.off()