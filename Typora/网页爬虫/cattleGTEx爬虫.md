搜索cattleGTEx网站的一个基因，获取这个基因的组织表达谱，并保存为文件，但是有些结果文件只有header，尚未优化

事先应在在输出文件夹中创建download和gene_expression两个子文件夹

```python
from selenium import webdriver
from selenium.webdriver.common.by import By #定位元素
from selenium.webdriver.support.wait import WebDriverWait #显示等待
from selenium.webdriver.support import expected_conditions as EC
from time import sleep
from selenium.webdriver.edge.options import Options
options = Options()
from shutil import move
import os

outfolder = "C:\\Users\\Peng Lingwei\\Desktop\\rumne"

#options.add_argument("--headless") #
options.add_argument("--disable-gpu") # 禁止gpu渲染图片
options.add_argument("--disable-extensions") # 禁止拓展
options.add_argument("download.prompt_for_download=false") # 禁用下载确认
options.add_experimental_option('prefs', {"download.default_directory": f"{outfolder}\\download"}) # 指定默认下载路径
 
# 打开浏览器
driver = webdriver.Edge(options=options)
driver.get("https://cgtex.roslin.ed.ac.uk/search/")

# 等待搜索界面加载完全
wait = WebDriverWait(driver, 10)
wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, ".webix_list_item")))


def execute(searched_gene):
	# 开始搜索基因
    search = driver.find_element(By.CSS_SELECTOR, "input")
    search.clear()
    search.send_keys(searched_gene)
    sleep(1) # 等待检索结果被展开

    # 选中被搜索的基因
    gene_names = driver.find_elements(By.CSS_SELECTOR, ".webix_list_item")
    if len(gene_names) == 0: # 搜索的基因不存在
        return 
    for gene_name in gene_names: # 
        gene = gene_name.text.split()[0] # 可能没有name
        if gene == searched_gene:
            gene_name.click()
            break

    # 提交搜索
    while True:
        try:
            driver.find_element(By.CSS_SELECTOR, "div[view_id='lb_gene'] button").click()
            break
        except:
            sleep(1)

    # 保存结果
    while True:
        try:
            # sleep(5) # 网速较慢时，按钮提前加载，而表格为加载，因此延时
            driver.find_element(By.XPATH, "//*[@id='cattleApp']/div/div/div[2]/div/div[2]/div/div[4]/div[3]/div/button").click() # 点击下载
            break
        except:
            sleep(1)        

    while True:
        file_list = os.listdir(f"{outfolder}\\download")
        if (not any(file.endswith('.tmp') for file in file_list)) and 'Data.csv' in file_list:
            sleep(0.5)
            move(f"{outfolder}\\download\\Data.csv", f"{outfolder}\\gene_expression\\{searched_gene}.gene_tpm.tsv",)
            break
        else:
            sleep(0.5)

genes = ["ENSBTAG00000052644", "ENSBTAG00000049795"]
for gene in genes:
    print(gene)
    execute(gene)
```





