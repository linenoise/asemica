import ensurepip
ensurepip.bootstrap(upgrade=True)
pip install -U Flask
from flask import Flask, render_template
import json


# Connect to HTML script(s).
app=Flask(__name__)
@app.route(‘/’)
def home():
return render_template(“home.html”)
if __name__ ==’__main__’:
app.run(debug=True)


# Write input for asemica and launch it
ob = json.loads(data)

file1 = open("perlpath.txt", "r")
p = file1.read()
file1.close()

file2 = open("input.txt", "w")
file2.write(ob["txt"])
file2.close()

file3 = open("stats.txt", "w")
file3.write(ob["operation"] + "\n" + ob["format"])
file3.close()

# Perl can/will delete files from here as needed.
