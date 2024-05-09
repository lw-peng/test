library(ggplot2)
library(ggpubr)

infile <- "/home/penglingwei/personal_project/result/figure/figure5/e/experiment_validation/qPCR/FADS2_230509.tsv"
plot <- function(infile, outfile) {
    data <- read.table(infile, header=T, sep=",")
    p <- ggbarplot(data, x = "group", y = "value", add = "mean_se",width = 0.5,
                    color = "group",fill = "group", 
                    position = position_dodge(0.1))
    p <- p + stat_compare_means(method = "t.test") 
    p <- p + theme_bw() + theme(panel.border=element_blank(), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), axis.line=element_line(colour="black"))
    p <- p + theme(axis.title=element_blank(), axis.text=element_text(size=12, color="black"))
    tiff(outfile, width=8, height=8, units="cm", res=600, compression="lzw")
    print(p)
    dev.off()
}

folder <- "/home/penglingwei/personal_project/result/diff_expression/drs/drs_construct/DEG_DEI/experiment_verify/qPCR"
file_names <- c("LPL", "ACSL4", "ACSL6")
for (file_name in file_names) {
    infile <- paste0(folder, "/", file_name)
    outfile <- paste0(folder, "/", file_name, ".tiff")
    plot(infile, outfile)
}
