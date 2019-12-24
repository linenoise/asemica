## asemicrypt
An easy way to encrypt and decrypt text offline.

How to Use
-
Before you get started, you may need the most recently updated versions of Python, Perl, and Bash (programming languages) and your browser.
You will also need to execute `install.sh` just once for `run.py` to use a file path.
Now, the first thing to do is click on `run.py`, and it will open up `home.html`.
From there, you will be guided in choosing the format of your message, what your message is, and a PIN to protect it.
Write your input only through this method.
Then the scripts shall do their thing, and you will see that your messages are in `output.txt`.

Additional Information
-
Files in the `texts` folder come with a timestamp.
If there are any problems that occur in the process, find what went wrong in `errorlog.txt`.
You can change swap `corpus.txt` with another file of your liking, but it has to have the same title.
There is a Python program located in the assets folder (`prepareCorpus.py`) that can format a corpus file for you, but it connects to the web to run its service.
If needed, disconnect Wi-Fi and have pre-made .txt files to paste your code, preventing keylogging.
The stylesheet, `style.css`, is not required, and it can be removed if desired.

`asemicrypt` is a fork of linenoise/asemica.
Licensed under the GNU GENERAL PUBLIC LICENSE Version 3 (which should have come with the software downloaded).
The default corpus file that comes with this repository has been provided by Kassidy Jones (2017).
ALL OTHER DESERVED CREDIT GIVEN IN THE FORM OF COMMENTS THROUGHOUT THE CODE.

https://n-o-d-e.net/clearnet.html
https://github.com/linenoise/asemica
https://github.com/ForgivenNin/asemicrypt
