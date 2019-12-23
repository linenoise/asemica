## javacrypt
An easy way to encrypt and decrypt text offline.


How to Use
-
Select what mode you would like to use, and choose if you would like the privacy feature.
This guards you against anyone who could be watching your activity.
Then continue to enter your message.
If you selected the encryption mode, choose to either make a "key" for your message or to make one yourself.
There is the option "Generate Key" to download your key if you make it longer than ten digits.
The more characters (or the higher the number) you enter in, the more complex the encryption will be.
If you set your mode to "decrypt", put in the key you have received.
There is an option to upload files.
It will take only files that have the title of "message.txt" or "key.txt" inside of the `javacrypt-master` folder.
For this feature to work, you may have to disable "Local File Restriction(s)" on your browser.

Options
-
`-c/--corpus: specify corpus filename or URL`
`-i/--input: specify input filename (defaults to STDIN)`
`-o/--output: specify output filename (defaults to STDOUT)`
`-f/--format: specify output format (defaults to none)`
`--force: forces runtime on an insufficiently complex corpus`
`-v/--verbost: increments verbosity setting (used for debugging)`

Available Formats
-
`none: doesn't format output; returns only word list`
`email: formats output to look like an informal email`
`poem: if you want your output to look like poetry`

Additional Information
-
By default, this application comes with 10 preset corpus files.
You can sub them out to your liking with other pieces of text.
A few changes in word choice may result in a different output!
The Python program located in the assets folder can do this for you, but it connects to the web to run its service.

Do not use the upload feature unless you have all other tabs closed on your browser or unless you have to.
These browsers have their security settings put into place for your sake.

Disconnect Wi-Fi and have pre-made .txt files to paste your code, preventing keylogging.

You can always save the code as a .txt file and compress it into a .zip file (or other kind).
Once you have to use it again, save the program as the file type it was before.
Along with this, you can turn the `.css` and `.js` files into `.min.css` and `.min.js` files.
Or you could also embed everything in `javacrypt.html` altogether!

`javacrypt` is a fork of linenoise/asemica.
Licensed under the GNU GENERAL PUBLIC LICENSE Version 3 (which should have come with the software downloaded).
*ALL OTHER DESERVED CREDIT GIVEN IN THE FORM OF COMMENTS THROUGHOUT THE CODE.*

https://n-o-d-e.net/clearnet.html
https://github.com/linenoise/asemica
https://github.com/ForgivenNin/javacrypt
