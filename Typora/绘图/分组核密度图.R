
p <- ggplot(df, aes(x=correlation, color=tissue)) + geom_density(size=0.5, key_glyph="smooth") 
# p <- p + scale_color_manual(labels=c("DRS", "PACS"), values=c(drs_color, dcs_color)) 
# p <- p + geom_vline(aes(xintercept=0.8),linetype="dashed", size=0.5) 
# p <- p + ylab("Density") 
p <- p + theme_bw() + theme(panel.border=element_blank(), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), axis.line=element_line(colour="black"))
p <- p + theme(axis.title.x=element_blank(), axis.title.y=element_text(size=text_size), axis.text=element_text(size=text_size, color="black")) + labs(x="Read integrity")
# c <- p + guides(color=guide_legend(title = ""), ncol=2) + theme(legend.position=c(0.2,0.9), legend.text=element_text(size=text_size))