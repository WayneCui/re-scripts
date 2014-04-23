Red [
	Title: {tic-tac-toe}
	File: %tic-tac-toe.red
	Author: "Wayne Tsui"
	Name: 'tia-tac-toe
	Description: {
		A Tic Tac Toe Game to play with a clever computer. 
		COMPUTER-STRATEGE employs the strategy from http://en.wikipedia.org/wiki/Tic-tac-toe
	}
]

tic-tac-toe: context [
	keypoints: [[ 1 2 3 ] [ 4 5 6 ] [ 7 8 9 ] [ 1 4 7 ] [ 2 5 8 ][ 3 6 9 ] [ 1 5 9 ][ 3 5 7 ]]
	center: 5
	corners: [ 1 3 7 9 ]
	sides: [ 2 4 6 8 ]

	validate-input: function [ position [block!] return: [logic!]][
		x: position/1
		y: position/2
		unless all [ x y integer? x integer? y x >= 1 x <= 3 y >= 1 y <= 3 ][ return false ]
		board/((x - 1) * 3 + y) = '_ 
	]

	test-over: function [ board[block!] return: [logic!]][
		fun: function['arg][
			either letter = arg ["You"] ["I"]
		]

		
		foreach point keypoints [
			oss: copy []
			xs: copy []
			foreach i point [append oss (board/:i = quote 'X)]
			foreach i point [append xs (board/:i = quote 'O)]
			case [
				all oss [print [fun 'X "win!"] return true]
				all xs [print [fun 'O "win!"] return true]
			]
		]
		unless find board '_ [ print "Tie!" return true ]
	]

	test-win: function[ board [ block! ] return: [logic!]][
		board: copy board
		foreach point keypoints [
			cs: copy []
			ps: copy []
			foreach i point [append cs (board/(i) = symbols/computer)]
			foreach i point [append ps (board/(i) = symbols/player)]

			case [
				all cs [ return true]
				all ps [ return true]
			]
		]
	]

	computer-stratege: function[ board [block!] return: [ unset! ]][
		temp: copy []
		cb: copy board
		
		if not find cb '_ [ exit ]
		until [
			append temp index? find cb '_
			cb: next cb
			not find cb '_
		]
		;First, check if we can win in the next move
		foreach i temp [
			cb: copy board
			cb/(i): symbols/computer
			if test-win cb [ return i ]
		]

		;;Second, check if the player could win on his next move, and block them.
		foreach i temp [
			cb: copy board
			cb/(i): symbols/player
			if test-win cb [ return i ]
		]
		;;Third, try to take one of the corners, if they are free.
		foreach i corners [
			if find temp i [ return i ]
		]
		;;Others
		case [
			find temp center [ center ]
			true [ first temp ]
		]
	]

	print-board: function[ board [block!]][
		print head insert at head insert at board 7 lf 4 lf
	]

	;MAIN PROGRAM
	start: does [
		print "Welcome to the tic tac toe game."
		print "Let's begin!"
		board: copy [ '_ '_ '_ '_ '_ '_ '_ '_ '_ ]
		
		;;Who will make the first move
		;player: true
		player: false

		until [
			letter: input "Do you want to be [X] or [O] or just [Q]uit?"
			switch/default first letter [
				#"x" #"X" [ symbols: [ player 'X computer 'O ] true ]
				#"o" #"O" [ symbols: [ player 'O computer 'X ] true ]
				#"q" #"Q" [ quit ]
			][
				print "Invalid input."
				false
			]
		]

		until [
			either player [
				print "It's your turn!"
				;player's move
				until [
					position: load input "Please enter [x y]:"
					validate-input position
				]
				board/((position/1 - 1) * 3 + position/2): symbols/player
				player: false
			][
				print "It's my turn!"
				;computor's move
				move: computer-stratege board
				board/(move): symbols/computer
				player: true
			]
			print-board copy board
			test-over board
		]
		if(first input "Try again? [Y/N]: ") = #"Y" [start]
	]
]

tic-tac-toe/start