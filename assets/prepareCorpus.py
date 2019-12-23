import ensurepip
ensurepip.bootstrap(upgrade=True)
import requests
import json

print("What text file would you like to use?")
usrinput = raw_input() 
text = open(usrinput, "rt")
tfile = text.read()

res = requests.post("https://www.dcode.fr/text-splitter", allow_redirects=False, data={
	'text': tfile,
	'split_mode': "nb_parts"
	'nb_parts': "10"
	'separator': "-----"
	'split_words': "false"
})

response = json.loads(res)
url = response.["result"]
url11 = url.replace("\n","\b")
url2 = url1.replace("\"\"", "\'\'")
url3 = url2.replace("\-\-\-\-\-","\b\n\n")

output = open("preparedCorpus.txt", "wt")
output.write(url3)
output.close()
print("Finished! You may now close this window.")
