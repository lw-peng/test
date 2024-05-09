    import re
    import io
    import pandas as pd
    from multiprocessing import Pool

    wd = "/home/penglingwei/pan_transcriptome/pan_process/bovine_unmapped"

    infile = f"{wd}/nonredundant/transcripts.nonredundant.fa.clstr"
    outfile = f"{wd}/distribution/transcript2supported.tsv"

    def parseCluster(cluster):
        represent_transcript = [i.split(">")[1] for i in cluster.split("\n") if "*" in i][0]
        # 转换成数据框处理
        df = pd.read_table(io.StringIO(cluster), header=None, sep=">")
        transcripts = df[1]
        supported = len(transcripts.str.split("_", expand=True)[0].drop_duplicates()) # 支持的样本数
        df = pd.DataFrame({"transcript": [represent_transcript], "supported": [supported]})
        return df

    def concatDf(df):
        global total_df
        total_df = pd.concat([total_df, df], axis=0)

    global total_df ; total_df = pd.DataFrame()
    f = open(infile)
    pool = Pool(processes=50)
    for cluster in re.split(r">Cluster \d+", f.read()):
        # 文本分块
        cluster = cluster.strip()
        cluster = cluster.replace("...", ">")
        if cluster == "":
            continue
        pool.apply_async(parseCluster, (cluster,), callback=concatDf)
    pool.close()
    pool.join()
    f.close()

    total_df.to_csv(outfile, header=True, index=False, sep="\t")
