https://nanx.me/ggsci/articles/ggsci.html
##### 展示颜色
    library(ggsci)
    mypal <- pal_npg("nrc", alpha = 0.7)(9)
    mypal

    library(scales)
    show_col(mypal)