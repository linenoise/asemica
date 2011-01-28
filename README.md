Asemica
=======

*An asemic Markov-chained cipher*

Asemica is a symmetric cipher whose key is a document and whose ciphertext looks like plaintext. For example, this plaintext:

> Meet @Joe's, 6pm

could become this ciphertext:

> to achieve this and any applicable patent claim is based The Free program INCLUDING a computer or A Major Component in NO EVENT UNLESS and FITNESS FOR an aggregate does terminal interaction through the Program's commands or DATA OR LOSSES SUSTAINED BY court order to an appropriate Legal Notices however if the PROGRAM IS addressed as IS addressed as changed so that copyright permission to Apply These requirements of an implementation available for and OR A 

Any single piece of plaintext should produce any number of cryptographically equivalent ciphertexts, and all of these ciphertexts will decrypt to the initial plaintext when given an identical document-key, called the *corpus file*.  All information about the input file is represented in the states between most of the ciphertext words, rendering the ciphertext asemic (meaning "without meaning").

Example Use
-----------

To produce this example, we can use the GNU GPL version 3 as a corpus file. This is included in this distribution as LICENSE.txt.  As a general rule, however, the larger and more complex the corpus file, the shorter the ciphertext should be.  To perform this example operation, clone this project and run the following:

	$ echo "Meet @Joe's, 6pm" | ./asemica enc -c LICENSE.txt

Which will output a ciphertext that looks similar to the one above (though probably not identical).  To decrypt a ciphertext, you can either save the ciphertext to a file (with the -o parameter) or pipe it back into another Asemica process:

	$ echo "Meet @Joe's, 6pm" | ./asemica enc -c LICENSE.txt | ./asemica dec -c LICENSE.txt 

Which should output the initial plaintext, "Meet @Joe's, 6pm".

Asemica can also read and write these files, rather than reading them from the standard input and output data streams:

	$ echo "Meet @Joe's, 6pm" > plain.txt
	
	$ ./asemica enc -c LICENSE.txt -i plain.txt -o cipher.txt
	
	$ cat cipher.txt 
	applications with other PROGRAMS EVEN the IMPLIED warranty OF Others' Freedom 
	If propagation that arrangement or ANY further restrictions within the 
	Appropriate copyright notice like laws that apply These things To Apply and 
	FITNESS FOR an aggregate if your copyrighted material added under version 
	Disclaimer for at all notices displayed by procuring conveyance of Liability 
	provided by modifying or adapt all civil liability to OPERATE WITH ABSOLUTELY 
	NO charge under trademark law No Surrender of Liability to USE in favor of ALL 
	versions may not available or CORRECTION Limitation of ALL 
	
	$ ./asemica dec -c LICENSE.txt  -i cipher.txt
	Meet @Joe's, 6pm


Ciphertext Formatting
---------------------

Certain aspects of ciphertext formatting are free-form.  You can add spacing, punctuation, and HTML tags, and you can freely change the case of any letters present in the ciphertext.  None of these changes will render the ciphertext undecipherable.  Some of these formatting options are built-in: as an example, you can have Asemica format your ciphertext to look like an email.

	$ echo "Meet @Joe's, 6pm" | ./asemica enc -c LICENSE.txt -f email

This should produce something that looks like:

> In,
> 
> Determining whether the COST OF THE Free of THE Free copyleft license But in!  Future versions of ALL its resulting copyright also convey.  Or A FAILURE OF MERCHANTABILITY or ANY.  Implied INCLUDING ANY applicable terms are not available to an appropriate Legal?  Notices however if the PROGRAM IS addressed as IS addressed as changed so This requirement.  To Apply along with section does terminal interaction.  Through the Installation Information must suffice to USE sell offer valid.  If conditions Definitions.
> 
> This,
>
> License

Decrypting this ciphertext with the same corpus file will produce the expected output:

> Meet @Joe's, 6pm

Remote Keys
-----------

If you want to store your document-key on a remote server (accessible over HTTP or HTTPS), you can pass that URL to the -c argument in the same manner you'd pass a filename:

	$ echo "Meet @Joe's, 6pm" | ./asemica enc -c http://www.gutenberg.org/dirs/etext98/2ws2610.txt

This specific example will encode your plaintext using Project Gutenberg's Etext of Shakespeare's *Hamlet* as a document key:

> heaven Repent but 'tis dangerous lunacy Ros Good Laertes Laer And Guild I'll anoint my abridgment comes Between maids' legs Oph And Ber He closes with Project Should give exact command or Refund of Christians nor hatchment o'er which had as Hamlet ' I I Sailor He Fran Nay that Pol At Midnight of ALL


Under the Hood
==============

Asemica is written in perl and uses curl when asked to load a remote corpus over HTTP or HTTPS.  It doesn't depend on any library not present in the usual perl distribution, so this should run on any system capable of running both perl and curl.  The author has only tested it on linux (Ubuntu 10.10) and Mac OS X (10.6.6).

The Document-Key ("Corpus file")
---------------------------

Asemica works primarily by means of a corpus file: a document serving as a cryptographic key.  This corpus file can be HTML or plaintext, and can be a plain file or a remote URL that Asemica should load.  The "feel" of the output text will depend entirely upon the chosen corpus, and not all documents will function equally well as a key.

Ideally, this corpus file would be on the large side (over 5,000 words or thereabouts) and linguistically diverse enough to contain adequate numbers of "transition exit states" (described below).  If the corpus you've chosen won't work very well as a key, Asemica will advise you to find a better one, though you can always run it with --force and hope for the best.

The State Transition Matrix
---------------------------

The core of Asemica is the Markov chain state transition matrix calculated from the corpus file.  Minimally, Asemica looks for at least seven unique "meaningful transition tokens" in a given corpus.  A single meaningful transition token is defined as a unique word present in the document at least 16 times, each time with a different word following it.  In general, the more meaningful transition tokens present in a document, the shorter the ciphertext will be.

This matrix encodes a specific pattern in the corpus: which words are followed how many times by which other words.  These transitions (i.e. word-followed-by-N-words) are counted and sorted into "meaningful" transitions (those with 16 or more exit states) and meaningless transitions.  Meaningful transitions are called such because they're able minimally to serialize a nibble of data (that is, a half byte) and are subsequently systematically traversed.  Meaningless transitions, unable to serialize a nibble, are randomly traversed.  This property allows a single input plaintext to produce multiple cryptographically equivalent ciphertexts.

Runtime Options
===============

	Usage: ./asemica (enc|dec) -c <corpus_file> [-i <input_file>] [-o <output_file>] [-f <format>] [--force] [--help]

	OPTIONS:
	   -c/--corpus:  specify corpus filename or URL
	   -i/--input:   specify input filename (defaults to STDIN)
	   -o/--output:  specify output filename (defaults to STDOUT)
	   -f/--format:  specify output format (defaults to none)
	   --force:      forces runtime on an insufficiently complex corpus
	   --help:       displays this message
	   -v/--verbost: increments verbosity setting (used for debugging)
	AVAILABLE FORMATS:
	   none:         doesn't format output; returns only word list
	   email:        formats output to look like an informal email
	   poem:         if you want your output to look like poetry
	EXAMPLES
	   echo "message" | ./asemica enc -c corpus.txt -o asemic.txt
	   ./asemica dec -c corpus.txt -i asemic.txt
	
Feedback
========

Please direct any comments, questions, suggestions, bug reports, or feature requests to Dann Stayskal <dann@stayskal.com>.  If you're a coder, feel free to contribute.

Contributing
------------

1. Fork this repository.
2. Create a branch (`git checkout -b my_asemica`)
3. Commit your changes (`git commit -am "Added essay formatter"`)
4. Push to the branch (`git push origin my_asemica`)
5. Create an [Issue][1] with a link to your branch
6. Wait

Thanks
------

Special thanks to:

* Suzy Choate, for suggesting case insensitivity in the output text.

License
=======

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

[1]: http://github.com/danndalf/asemica/issues

