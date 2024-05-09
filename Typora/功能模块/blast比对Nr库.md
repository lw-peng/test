    export wd=/home/penglingwei/pan_transcriptome/pan_process/bovine_unmapped
    export thread=45
    #
    export blastn=/home/penglingwei/software/blast/bin/blastn
    #
    export db=/home/data/database/Nt/nt
    # https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/
    #
    export blast_folder=${wd}/blast ; mkdir -p ${blast_folder}

    execute_blast () {
    query=$1
    out=$2
    ${blastn} \
        -db ${db} \
        -strand plus \
        -query ${query} \
        -outfmt "6 qseqid sseqid pident length qstart qend sstart send evalue bitscore qlen slen staxid sseq qcovs" \
        -max_target_seqs 1000 \
        -num_threads ${thread} \
        -out ${out}
    }

    export -f execute_blast
