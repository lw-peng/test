[TOC]



##### bioProject获取文献信息

```python
import requests
from bs4 import BeautifulSoup
import re
class ParaseBioproject():
    def __init__(self, bioproject):
        url = f"https://www.ncbi.nlm.nih.gov/bioproject/?term={bioproject}"
        response = requests.get(url)
        html = response.text
        document = BeautifulSoup(html, "xml")

        self.bioproject = bioproject
        self.url = url
        self.document = document
    
    def Title(self):
        if "PRJNA" in self.bioproject:
            title = self.document.select_one(".Title > h2").text
        elif "PRJDB" in self.bioproject:
            title = self.document.select_one(".Title > h3").text
        else:
            title = ""
            print("Warn：Bioproject ID不正确")
        return title

    def Description(self):
        if "PRJNA" in self.bioproject:
            description = self.document.select_one("#DescrAll").text
            description = description.replace(" Less...", ".")

        elif "PRJDB" in self.bioproject:
            description = self.document.select_one(".Description").text
        else:
            description = ""
            print("Warn：Bioproject ID不正确")
        return description
```

##### bioSample号查找样本品种

```python
import requests
from bs4 import BeautifulSoup
class ParaseBioSample():
    def __init__(self, biosample):
        url = f"https://www.ncbi.nlm.nih.gov/biosample/{biosample}"
        response = requests.get(url)
        html = response.text
        document = BeautifulSoup(html, "xml")

        self.biosample = biosample
        self.url = url
        self.document = document
    def breed(self):
        trs = self.document.select("tr")
        for tr in trs:
            if tr.select_one("th").text == "breed":
                return tr.select_one("td").text
        print("NCBi未提供品种信息")
        return "-"

for biosample in open("BioSample.txt").readlines(): #输入
    biosample = biosample.strip()
    paraseBioSample = ParaseBioSample(biosample)
    print(paraseBioSample.breed()) #输出
```



##### bioproject和bioSample获取样本详细信息

```
import requests
from bs4 import BeautifulSoup
import pandas as pd

def sra2biosample(sra):
    url = f"https://www.ncbi.nlm.nih.gov/sra/{sra}[accn]"
    response = requests.get(url)
    html = response.text
    document = BeautifulSoup(html, "xml")
    biosample = document.select_one("a[title='Link to BioSample']").text
    return biosample


def getBiosampleInformation(biosample):
    url = f"https://www.ncbi.nlm.nih.gov/biosample/{biosample}"
    response = requests.get(url)
    html = response.text
    document = BeautifulSoup(html, "xml")
    div = document.select_one(".docsum")
    dls = div.select("dl")

    results = []
    for dl in dls:
        dt = dl.select_one("dt") 
        dd = dl.select_one("dd")
        term = dt.text.strip()
        if term == "Organism":
            description = []
            for children in dd.children:
                text = children.text.strip()
                if len(text) == 0: # 避免空行
                    continue
                description += [text]
            description = " | ".join(description)
            results.append(f"{term} => {description}")
        elif term == "Attributes":
            description = ""
            trs = dd.select("tr")
            for tr in trs:
                th = tr.select_one("th")
                td = tr.select_one("td")
                description += f"{th.text}: {td.text.strip()}; "
            results.append(f"{term} => {description}")
        else:
            description = dd.text.strip()
            results.append(f"{term} => {description}")
    return "\n".join(results)


class GetBioprojectInformation():
    def __init__(self, bioproject):
        url = f"https://www.ncbi.nlm.nih.gov/bioproject/{bioproject}"
        response = requests.get(url)
        html = response.text
        document = BeautifulSoup(html, "xml")
        self.bioproject = bioproject
        self.url = url
        self.document = document
    # description
    def Description(self):
        description = self.document.select_one("#DescrAll")
        description = self.document.select_one(".Description") if description is None else description
        description = description.text.replace(" Less...", ".")
        return description
    # table
    def Table(self):
        results = []
        table = self.document.select_one("#CombinedTable")
        for tr in table.select("tr"):
            term_description = []
            for td in tr.select("td"):
                term_description += [td.text.strip()]
            term, description = term_description[0], " | ".join(term_description[1: ])
            results += [f"{term} => {description}"]
        return "\n".join(results)
import os
def main():
    out_folder = "result"
    record = "record.txt"
    biosample2information = {}
    df = pd.read_table("Metadata_FarmGTEx_cattle_V0.tsv", header=0, sep="\t", nrows=10)

    for row in df.index:
        sra, bioproject = df.loc[row, ["Sample", "Bioproject"]].tolist()
        out_file = f"{out_folder}/{bioproject}.txt" 

        # bioSample
        try:
            biosample = sra2biosample(sra)
        except:
            with open(record, "a") as f:
                f.write(f"{sra}\n")
            continue

        # bioProject
        if not os.path.exists(out_file):
            try:
                getBioprojectInformation = GetBioprojectInformation(bioproject)
                bioproject_information = getBioprojectInformation.Description() + "\n" + getBioprojectInformation.Table()
            except:
                bioproject_information = "#Error#"
            with open(out_file, "w") as f:
                f.write(f">>>{bioproject}\n{bioproject_information}\n\n")

        # bioSample
        try:
            if biosample not in biosample2information:
                biosample = sra2biosample(sra)
                biosample_information = getBiosampleInformation(biosample)
                biosample2information[biosample] = biosample_information
            else:
                biosample_information = biosample2information[biosample]

        except:
            biosample_information = "#Error#"
            with open(record, "a") as f:
                f.write(f"{sra}\n")
        with open(out_file, "a") as f:
            f.write(f">>>{biosample} {sra}\n" + biosample_information + "\n")



if __name__ == "__main__":
    main()


```

