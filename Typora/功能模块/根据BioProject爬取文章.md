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



        def Publications(self):
            table = self.document.select_one("#CombinedTable")
            if table is None:
                print(f"Warn: {self.bioproject}异常，请手动检查{self.url}")
                return ""
            #XXXtbody = table.select_one("tbody") # 解析器忽略tbody

            publications = []
            for tr in table.select("tr"): # 表中的每一行
                CTtitle = tr.select_one(".CTtitle").text # 第一列
                CTcontent = tr.select_one(".CTcontent") # 第二列
                if CTtitle == "Publications":
                    href = CTcontent.select_one("a").get("href")
                    href = f"https://www.ncbi.nlm.nih.gov{href}" if href.startswith("/pubmed/") else href
                    article = re.findall(r', "[^"]*", ', CTcontent.text)[0].split('"')[1]
                    publications.append(f"{article}({href})")
            publications = "-" if len(publications) == 0 else ", ".join(publications)
            
            print(f"Info: 成功从{self.bioproject}获得文章信息" if publications != "-" else f"{self.bioproject}不包含文章信息")
            return publications

    infile, outfile = "Bioprojects.txt", "outfile.txt"
    with open(outfile, 'w') as f:
        f.truncate(0)
    bioprojects = [i.strip() for i in open(infile).readlines()]

    for bioproject in bioprojects:
        f = open(outfile, "a", encoding="utf-8")
        print(f"\n开始处理{bioproject}")
        paraseBioproject = ParaseBioproject(bioproject)
        url = paraseBioproject.url
        publications = paraseBioproject.Publications()
        title = paraseBioproject.Title()
        description = paraseBioproject.Description()


        f.write(f"{bioproject}\n{url}\n{publications}\n{title}\n{description}\n#\n")
        




