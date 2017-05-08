Red [
	title:		"State Machine: A Simple JavaScript Expression Lexer"
	date:		{8-May-2017}
	file:		%simple-lexer.red
	author: 	"Wayne Cui"
	version:	0.0.1
	info:		"inspired by http://www.cnblogs.com/Random/p/3343074.html"
]

reader: function[ str [ string! ]][
	*reader: make object! [
		index: 1
		stream: rejoin [str space]
		char: has [][
			stream/(index)
		]

		length: has[][
			length? stream
		]

		pchar: has[][
			stream/(index - 1)
		]

		nchar: has[][
			stream/(index + 1)
		]

		eof: has[][
			index = (length? stream)
		]

		next: has[][
			index: index + 1
			index
		]

		prev: has[][
			index: index - 1
			index
		]
	]

	*reader
]

punctuator-list: ["{" "}" "(" ")" "[" "]" "." ";" "" "<" ">" "<="
                    ">=" "==" "!=" "===" "!==" "+" "-" "*" "%" "++" "--"
                    "<<" ">>" ">>>" "&" "|" "^^" "!" "~" "&&" "||" "?" ":"
                    "=" "+=" "-=" "*=" "%=" "<<=" ">>=" ">>>=" "&=" "|=" "^="] ;"^" should be escaped as "^^"

check-unicode-letter: function[c][
	letter: charset [#"a" - #"z" #"A" - #"Z"]
	parse to string! c [ some letter]
]

check-unicode-number: function[c][
	char-code: to binary! c
	((char-code >= #{0030}) and (char-code <= #{0039})) or 
	((char-code >= #{01D7CE}) and (char-code <= #{01D7FF})) 
]

emit-token: function [type /extern word][
	repend/only token-list [type word]
	;probe "=================="
	;probe token-list
	;probe "=================="
	word: copy ""
]

data-state: function[c /extern word][
	either not not find punctuator-list (to string! c) [
		word: c
		return :punctuator-state
	][
		either (check-unicode-letter c) 
			or (c = to binary! "_")
			or (c = to binary! "$")
			or (c = to binary! "\\")[

			word: c
			return :identifier-state
		][
			word: c
			return :double-string-literal-state
		]
	]
]

punctuator-state: function[c /extern word ireader][
	either find punctuator-list (rejoin [word c]) [
		word: rejoin [word c]
		return none
	][
		emit-token "pun"
		ireader/prev
		return :data-state
	]
]

identifier-state: function[c /extern word ireader][
	either (check-unicode-letter c) or (check-unicode-number c) [
		word: rejoin [word c]
		return none
	][
		emit-token "id"
		ireader/prev
		return :data-state
	]
]

double-string-literal-state: function[c /extern word][
	either (to string! c) = {\}[
		word: rejoin [word c]
		return :double-string-literal-escape-seq-state
	][
		either (to string! c) = {"} [
			word: rejoin [word c]
			emit-token "str"
			return :data-state
		][
			word: rejoin [word c]
			return none
		]
	]
]

double-string-literal-escape-seq-state: function[c /extern word][
	word: rejoin [word c]
	return :double-string-literal-state
]

token-list: copy []
word: copy ""

statement: {str<="123\"abc";}
ireader: reader rejoin [ statement space ]

state: :data-state
;probe state ireader/char
while [not ireader/eof] [
	print ireader/char
	new-state: state ireader/char
	;probe :new-state
	if not not :new-state [
		state: :new-state
	]
	
	ireader/next
]

probe token-list

