from flask import Flask, render_template
import json
import subprocess


# Connect to HTML script(s).
app=Flask(__name__)
@app.route("/")
def home():
    return render_template('home.html')
    if __name__ == "__main__":
        app.run(debug=True)


# Write input for asemica and launch it
ob = json.loads(data)

file = open("input.txt", "w")
file.write(ob["operation"] + "\n" + ob["format"] + "\n" + ob["txt"])
file.close()

subprocess.Popen(["perl", "asemica.pl"])    
# Perl will delete files from here.
