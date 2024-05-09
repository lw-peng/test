
    import pandas as pd
    def parseGtf(gtf, genes):
        df = pd.read_table(gtf, header=None, sep="\t", comment="#", low_memory=False)
        df.columns = ["chromosome", "source", "type", "start", "end", "score", "strand", "phase", "attribute"]
        df = df[df["type"]=="exon"]
        function1 = lambda attribute: [x.split("\"")[1] for x in attribute.split(";") if "gene_id" in x][0]
        function2 = lambda attribute: [x.split("\"")[1] for x in attribute.split(";") if "transcript_id" in x][0]
        function3 = lambda attribute: [x.split("\"")[1] for x in attribute.split(";") if "gene_name" in x][0] if "gene_name" in attribute else "-"
        df["gene"] = df["attribute"].apply(function1)
        df["transcript"] = df["attribute"].apply(function2)
        df["gene_name"] = df["attribute"].apply(function3)
    