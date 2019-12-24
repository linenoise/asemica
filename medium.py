import ensurepip
ensurepip.bootstrap(upgrade=True)
pip install -U Flask
from flask import Flask, render_template
import json
import subprocess


# Connect to HTML script(s).
app=Flask(__name__)
@app.route(‘/’)
def home():
return render_template(“home.html”)
if __name__ ==’__main__’:
app.run(debug=True)


# Write input for asemica and launch it
ob = json.loads(data)

file1 = open("input.txt", "w")
file1.write(ob["txt"])
file1.close()

file2 = open("stats.txt", "w")
file2.write(ob["operation"] + "\n" + ob["format"])
file2.close()

subprocess.Popen(["perl", "asemica.pl"], stdout=subprocess.PIPE)    
# Perl will delete files from here.
