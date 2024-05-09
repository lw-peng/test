爬取各物种OR基因table

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
print(driver.get_cookies(), 1)
driver.get("https://cord.ihuman.shanghaitech.edu.cn/page/cord/search")
# cookies原因，故执行2次
driver.get("https://cord.ihuman.shanghaitech.edu.cn/page/cord/search")


wait = WebDriverWait(driver, 10)

selector = "#el-collapse-content-5829 > div > div:nth-child(2) > div.ct-input.el-input.el-input--medium.el-input--suffix > input:nth-child(1)"
xpath = '//*[@id="el-collapse-content-9124"]/div/div[2]/div[2]/input'
#search = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, selector)))
search = driver.find_element(By.XPATH, xpath)
search.clear()
search.send_keys("Bos taurus")
sleep(1) # 等待检索结果被展开

```



爬取OR基因序列

```python
import requests
import json
from fake_useragent import UserAgent 

headers = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6',
    'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3MDk1NDY0MjgsInVzZXJJZCI6InVzZXItaWQtYWJjIn0.YRil917BdWVHBp8fErj9VGLiCpYV4TSlzXymjEcj2o0r_acFiVQKvhOsFmuzTURw0PDOs2Is9j8nYwc5qOt1lA',
    'Connection': 'keep-alive',
    #'Cookie': 'JSESSIONID=370F12281332E4D9DB5CD2414D9A351E; KnowledgeGraphSearchHist=927885000915861504; ai_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3MDk1NDY0MjgsInVzZXJJZCI6InVzZXItaWQtYWJjIn0.YRil917BdWVHBp8fErj9VGLiCpYV4TSlzXymjEcj2o0r_acFiVQKvhOsFmuzTURw0PDOs2Is9j8nYwc5qOt1lA',
    'Host': 'cord.ihuman.shanghaitech.edu.cn',
    #'Referer': 'https://cord.ihuman.shanghaitech.edu.cn/page/cord/detail/MKOZDAF',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    #'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0',
    'User-Agent': UserAgent().random, 
    'sec-ch-ua': '"Not A(Brand";v="99", "Microsoft Edge";v="121", "Chromium";v="121"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"'
} # Authorization是必须的


def getSequence(entry):
    url = f"https://cord.ihuman.shanghaitech.edu.cn/v2/graph/detail/sequence/{entry}?entry={entry}"
    response = requests.get(url, headers = headers).json()
    return {"dna": response["data"]["dnaSequence"], "protein": response["data"]["proteinSequence"]}
        

```

