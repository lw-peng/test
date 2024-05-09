def extractChromosomeSequence(genome_fasta, coordinate):
    chromosome, start, end, strand = coordinate[0], coordinate[1], coordinate[2], coordinate[3]
    if strand == "+":
        with os.popen(f"{SAMTOOLS} faidx {genome_fasta} {chromosome}:{start}-{end} 2> /dev/null") as fasta:
            return "".join(fasta.read().split("\n")[1: ]) # 去除输出fasta自带的序列名
    if strand == "-":
        with os.popen(f"{SAMTOOLS} faidx {genome_fasta} {chromosome}:{start}-{end} --reverse-complement 2> /dev/null") as fasta:
            return "".join(fasta.read().split("\n")[1: ])