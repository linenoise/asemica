#!/usr/bin/perl -w
use strict;

###
# Asemica -- An asemic Markov-chained cipher
# Copyright (c) 2011 by Danne Stayskal <danne@stayskal.com>
# Modified by ForgivenNin @ GitHub.com (2019-2020)
###

###
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
###


###
# Retrieve data
###

open('INPT_FLE','<', "input.txt")
@lines = (1, 2, 3);
@tr = <INPT_FLE>
my $operation = tr[$lines[0]];
my $format = tr[$lines[1]];
my $input_file = tr[$lines[2]];

my $corpus_file = 'corpus.txt';


###
# Debug/Error Log
###

sub debug {
	my ($err) = @_;
	open("E", ">>", "errorlog.txt");
	E localtime() + "\n" + $err + "\n";
	close("E");
}


###
# Make sure we have necessary and sufficient inputs (command line or STDIN)
###

unless ($operation) {
	debug("No operation (encode or decode) specified.\n");
	exit 1;
}

unless ($operation eq 'enc' || $operation eq 'dec') {
	debug("Invalid operation specified: $operation\n");
	exit 1;
}

my $input = '';
unless ($input_file) {
	$input = join('',<STDIN>);
} else {
	open('INPUT', '<', $input_file) || debug("Can't read $input_file");
	$input = join('',<INPUT>);
	close('INPUT');
}


###
# Load and verify corpus
###

my $corpus = '';
unless ($corpus_file) {
	debug("No corpus specified.  Can't operate without a corpus.\n");
	exit 1;
}
if (-f $corpus_file) {
	### It's a flat file.  Load and move on.
	open('CORPUS','<', $corpus_file) || debug("Can't read $corpus_file");
	$corpus = join('',<CORPUS>);
	close('CORPUS');

} else {
	debug("Couldn't read corpus at $corpus_file\nExiting.\n");
	exit 1;
}



###
# Calculate and verify corpus tokens and transition matrix
###
my $tokens = tokenize_corpus($corpus);
my $transitions = generate_transitions(@$tokens);


###
# Run the actual encoding or decoding  procedure
###
my $output_text = '';
if ($operation eq 'enc') {

	$output_text = encode($input, $transitions, $tokens);

	if ($format) {
		$output_text = format_text($output_text, $format);
	}

} elsif ($operation eq 'dec') {

	$output_text = decode($input, $transitions, $tokens);

}


###
# Output the results and delete files
###
if ("output.txt") {
	open('OUTPUT', '>>', "output.txt") || debug("Can't write to 'output.txt'.\n");
  OUTPUT $output_text;
	close('OUTPUT');
}
unlink "input.txt"


###
# clean_input
# Removes all nonwords and HTML from input text
#
# Takes:
#   - $input, a scalar containing the input to be cleaned
# Returns:
#   - $output, a scalar containing the cleaned data
# Note:
#   Yes, this is a silly thing to have isolated like this, but I'm doing so
#   because the cleaning procedures need to be identical for encoding and
#   decoding to work properly.  This approach saves time and repetition.
###
sub clean_input {
	my ($input) = @_;

	$input =~ s/\n/ /g;      ### Change newlines to spaces
	$input =~ s/\<[^>]*//g;  ### Strip out HTML (poorly -- we can't assume any
	 						 ### modules other than perl's core will be around)
	$input =~ s/[^\w\']/ /g; ### Change non-word characters to spaces
	$input =~ s/\d/ /g;      ### Change numbers to spaces
	$input =~ s/\s+/ /g;     ### Change sequences of spaces to a single space
	$input =~ s/^\s+//;      ### Trim leading whitespace
	$input =~ s/\s+$//;      ### Trim trailing whitespace

	return $input;
}


###
# tokenize_corpus
# Breaks the input corpus into a series of processable "tokens"
#
# Takes:
#   - $corpus, a scalar containing the complete input corpus
# Returns:
#   - $tokens, an array reference of tokens (most likely "words") present
# Output looks like:
#   ['The','Project','Gutenberg', ... ,'about','new','eBooks']
###
sub tokenize_corpus {
	my ($corpus) = @_;

	$corpus = clean_input($corpus);
	my @tokens = split(/\s/, $corpus);

	return \@tokens;
}


###
# generate_transitions
# Creates the primary transition matrix for use in coding
#
# Takes:
#   - @tokens, an array of tokens present, sequentially, in the corpus
# Returns:
#   - $transitions, the transition matrix
# Output looks like:
#    {
#   	'atlantic' => {                      ### Lowercase form
#                'seen' => 2,                ### How many fimes seen in corpus
#                'exits' => {                ### Which words follow it?
#                             'City' => 1,   ### One instance of this
#                             'and' => 1     ### One instance of that
#                           },               ### Exits not guaranteed unique
#                'door' => [                 ### Doors are guaranteed unique
#                            'City',         ### Following door number 1
#                            'and'           ### Following door number 2
#                          ],
#                'doors' => 2,               ### Cached count of doors
#                'token' => 'Atlantic'       ### Original form of the token
#              },
#    ...
#    }
###
sub generate_transitions {
	my @tokens = @_;
	my $transitions = {};

	### Generate the initial transitions table
	foreach my $index (0..scalar(@tokens)){
		my $token = $tokens[$index-1];
		my $key = lc($token);

		$transitions->{$key}->{seen}++;
		$transitions->{$key}->{token} = $token;

		if ($tokens[$index+1]) {
			$transitions->{$key}->{exits}->{$tokens[$index+1]}++;
		}
	}

	### Calculate the exits and doors
	foreach my $transition (keys(%$transitions)){
		my @exits = keys(%{$transitions->{$transition}->{exits}});
		$transitions->{$transition}->{door} = [];
		my $found = {};
		foreach my $exit (sort(keys(%{$transitions->{$transition}->{exits}}))){
			unless ($found->{lc($exit)}) {
				push @{$transitions->{$transition}->{door}}, $exit;
			}
			$found->{lc($exit)} = 1;
		}
		$transitions->{$transition}->{doors} = scalar(
			@{$transitions->{$transition}->{door}}
		);
		if ($transitions->{$transition}->{doors} > 15) {
			$transitions->{$transition}->{meaningful} = 1;
		}
	}

	return $transitions;
}


###
# verify_exits
# Returns whether this corpus will work well as an encoding or decoding medium
#
# Takes:
#   - $transitions, the calculated transition matrix
# Returns:
#   - 1 if it will suffice, 0 if it probably won't.
# Note:
#   We are looking for how many nodes in the transition matrix have more than
#   15 doors (as they'll need minimally 16 in order for the relationship
#   between any node and its successor to be able to encode a binary nibble)
#   If there are fewer than 10 of these, chances are the encoding / decoding
#   is going to be of very low quality.
###
sub verify_exits {
	my ($transitions) = @_;
	my $count = 0;
	my @meaningful = ();
	foreach my $key (keys(%$transitions)){
		if ($transitions->{$key}->{doors} > 15){
			$count++;
			push @meaningful, $key;
		}
	}
	if ($count >=7) {
		return 1;
	} else {
		return;
	}
}


###
# encode
# Encodes an input file using the transition matrix calculated from the corpus
# Takes:
#   - $input, a scalar containing the input to be encoded
#   - $transitions, the transition matrix calculated from the corpus
#   - $tokens, an array reference of the token sequence from the key corpus
# Returns:
#   - $encoded_text, the encoded text
###
sub encode {
	my ($input, $transitions, $tokens) = @_;

	my $bits = unpack("b*", $input);
	my $nibbles;
	while (my $nibble = substr($bits,0,4,'')){
		push @$nibbles, bin2dec($nibble);
	}

	my $token = $tokens->[int(rand(scalar(@$tokens)))];
	my $encoded_text = '';
	my $last_token = $token; ### for debugging

	while (scalar(@$nibbles)){

		if ($transitions->{lc($token)}->{meaningful}){
			$encoded_text .= $token.' ';

			### This token means something.  Walk through the nibblth door.
			my $nibble = shift(@$nibbles);
			$token = $transitions->{lc($token)}->{door}->[$nibble];

		} else {
			$encoded_text .= $token.' ';

			### This token is irrelevant.  Stumble drunkenly through any door.
			$token = $transitions->{lc($token)}->{door}->[
						int(rand($transitions->{lc($token)}->{doors}))
					 ];
		}

		unless($token){
			use Data::Dumper;
			debug("DEBUG:\ntoken = $token\n".
				  "Transitions:".Dumper($transitions->{lc($token)}).
				  "\nlast_token = $last_token\n".
				  "Transitions:".Dumper($transitions->{lc($last_token)});)
			exit 1;
		}

		$last_token = $token;
	}
	$encoded_text .= $token.' ';

	return $encoded_text;
}


###
# decode
# Pieces an arbitrary binary sequence back together from ASCII input file
#
# Takes:
#   - $output_text, text originally output by an encoding pass of this script
#   - $transitions, the transition matrix generated from the key corpus
#   - $tokens, an array reference of the token sequence from the key corpus
# Returns:
#   - $reconstituted, the decoded text
###
sub decode {
	my ($input, $transitions, $tokens) = @_;

	my $decoded = '';

	$input = clean_input($input);

	my @words = split(/\s+/, $input);

	foreach my $i (0..scalar(@words)-2){
		if ($transitions->{lc($words[$i])}->{meaningful}){
			### We walked through a specific door.  Figure out which it was.
			my $num_doors = scalar(@{$transitions->{lc($words[$i])}->{door}});
			foreach my $j (0..$num_doors-1){
				my $on_door = lc($transitions->{lc($words[$i])}->{door}->[$j]);
				if ($on_door eq lc($words[$i+1])){
					my $binary = dec2bin($j);
					while (length($binary)<4){
						$binary = '0'.$binary;
					}
					$decoded .= $binary;
				}
			}
		}
		### TODO: a later version of this should use the less meaningful
		### nodes to encode information as well.  Really, any node with more
		### than one exit can be used to encode something (minimally, a single
		### bit), so in that sense any node with more than 2 exits /could/ be
		### a door.  We'd just have to modify the coders for variable lengths.
		### For right now, we're just using nodes with 16 or more exits (so
		### they can encode minimally a nibble), then only making use of the
		### first 16 doors from that node. This can be improved with variable-
		### length encoding.
	}

	my $decoded_text = pack('b*',$decoded);
	return $decoded_text;
}


###
# format_text
# Formats the output text to look like something human-created
#
# Takes:
#   - $input_text, a scalar containing the text to be formatted
#   - $format, a scalar specifying the desired format
# Returns:
#   - $output_text, a scalar containing the formatted text
###
sub format_text {
	my ($input_text, $format) = @_;

	my $formats = {
		'none' => sub { return join(' ',@_); },

		###
		# Poem format
		###
		'poem' => sub {
			my @words = @_;

			### Form the words into sentences
			my @puncts = ('.',' ',' ',' ',',',',',',','!','?');
			my @sentences = ();
			while (scalar(@words)) {
				my $sentence_length = 6 + int(rand(3));
				if (scalar(@words) < $sentence_length) {
					$sentence_length = scalar(@words);
				}
				my $sentence = join(' ',splice(@words,0,$sentence_length,()));
				$sentence = ucfirst($sentence).$puncts[int(rand(@puncts))];
				push @sentences, $sentence;
			}

			### Form the sentences into stanzas
			my @stanzas = ();
			while (scalar(@sentences)) {
				my $stanza_length = 4 + int(rand(7));
				if (scalar(@sentences) < $stanza_length) {
					$stanza_length = scalar(@sentences);
				}
				my $stanza = join("\n",splice(@sentences,0,$stanza_length,()));
				push @stanzas, $stanza;
			}
			return join("\n\n",@stanzas);
		},

		###
		# Email format
		###
		'email' => sub {
			my @words = @_;

			my $greeting = ucfirst(shift(@words));
			my $name = ucfirst(pop(@words));
			my $thanks = pop(@words);

			### Form the words into sentences
			my @puncts = qw/? . . . . . !/;
			my @sentences = ();
			while (scalar(@words)) {
				my $sentence_length = 7 + int(rand(10));
				if (scalar(@words) < $sentence_length) {
					$sentence_length = scalar(@words);
				}
				my $sentence = join(' ',splice(@words,0,$sentence_length,()));
				$sentence = ucfirst($sentence).$puncts[int(rand(@puncts))];
				push @sentences, $sentence;
			}

			### Form the sentences into paragraphs
			my @paragraphs = ();
			while (scalar(@sentences)) {
				my $paragraph_length = 4 + int(rand(7));
				if (scalar(@sentences) < $paragraph_length) {
					$paragraph_length = scalar(@sentences);
				}
				my $paragraph = join('  ',splice(@sentences,0,$paragraph_length,()));
				push @paragraphs, $paragraph;
			}
			my $body = join("\n\n   ",@paragraphs);
			return "$greeting,\n\n   $body\n\n$thanks,\n$name";
		},
	};
	if ($formats->{$format}) {
		return $formats->{$format}->(split(' ',$input_text));
	} else {
		debug("Unsupported format: $format\nExiting\n");
		exit 1;
	}
}
