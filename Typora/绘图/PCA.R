library(ggplot2)
library(magrittr)
library(ggsci)
library(patchwork)

pcaPlot <- function(infile, groupfile, outfile) {
    df <- read.table(infile, header=T, sep="\t", row.names=1)
    df <- prcomp(t(df)) # 主成分计算
    df <- df$x[, c("PC1", "PC2")] %>% as.data.frame() # 提取绘图用的PC1和PC2
    df0 <- read.table(groupfile, header=T, sep="\t", row.names=1)
    df$group <- sapply(rownames(df), function(x){df0[x, "group"]}) # 分组信息
    p <- ggplot(df) + geom_point(aes(x=PC1, y=PC2, color=group), size=1) 
    p <- p + scale_color_manual(values=c("Low"="blue", "High"="red")) # + scale_color_d3()
    p <- p + theme_bw() + theme(panel.border=element_blank(), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), axis.line=element_line(color="black"))
    p <- p + theme(axis.title=element_text(size=12), axis.text=element_text(size=12, color="black"))
    tiff(outfile, width=12, height=8, units="cm", res=600, compression="lzw")
    print(p)
    dev.off()
}