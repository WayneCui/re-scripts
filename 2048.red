Red [
	Title: {2048}
	File: %2048.red
	Author: {WayneTsui}
	Description: {
		Inspired by https://github.com/mydzor/bash2048
	}
]
game: context [
	pipe: '|
	bar: append/dup copy [] quote '- 19
	content: append/dup copy [] "  " 19
	content/5: content/10: content/15: quote pipe
	score: 0

	generate: function [ values [block!] return: [block!]][
		replace replace copy values none 2 none 4
	]
	
	fill-content: function [ values [block!] return: [block!]][
		board: copy []
		repeat i 4 [
			temp: copy content
			repeat j 4 [
				value: values/((i - 1) * 4 + j)
				unless none? value [
					temp/(j * 5 - 1): value
					case [
						value < 10 [ ]
						value < 100 [ temp/(j * 5 - 2): reduce [space space]]
						value < 1000 [temp/(j * 5 - 2): "" ]
						true [temp/(j * 5 - 2): "" temp/(j * 5 - 3): reduce [space space]]
					]
				]
			]	
			append board compose [bar lf (content) lf (temp) lf (content) lf ]
		]
		append board bar
		board
	]

	move: function [ direction [char!] values [block!] return: [block!]][
		move-hori: function [ value [block!] action [block!] return: [block!]][
			result: copy []
			repeat i 4 [
				numbers: copy []
				nones: copy []
				parse reduce bind value 'i [
					collect into numbers [
						any [
							set s integer! keep (s) | set t none! (append nones t)
						]
					]
				]
				do bind action 'result
			]
			result
		]
		move-vert: function [ value [block!] action [block!] return: [block!]][
			;result: make block! 16
			result: append/dup copy [] none 16
			repeat i 4 [
				numbers: copy []
				nones: copy []
				parse reduce bind value 'i [
					collect into numbers [
						any [
							set s integer! keep (s) | set t none! (append nones t)
						]
					]
				]
				do bind action 'result
				result/(i): temp/1
				result/(i + 4): temp/2
				result/(i + 8): temp/3
				result/(i + 12): temp/4

			]
			result
		]

		merge: function [ blk [block!] return: [block!]][
			result: copy []
			parse blk [
				collect into result [
					any [
						set a integer! set b integer! 
						if(equal? a b) (append blk none game/score: game/score + a + b) 
						keep (a + b)
						|
						set a integer! keep (a)
						|
						set a none! keep (a)
					]
				]
			]
			head result
		]

		switch direction [
			#"h" #"H" #"a" #"A" [ ;Left
				blk: [ values/(i * 4 - 3) values/(i * 4 - 2) values/(i * 4 - 1) values/(i * 4)] 
				action: [append result merge append head numbers nones]
				result: move-hori blk action

			 ]
			#"l" #"L" #"d" #"D" [ ;Right
				blk: [ values/(i * 4 - 3) values/(i * 4 - 2) values/(i * 4 - 1) values/(i * 4)] 
				action: [append result reverse merge reverse append nones head numbers]
				result: move-hori blk action

			]	
			#"k" #"K" #"w" #"W" [ ;Up
				blk: [ values/(i) values/(i + 4) values/(i + 8) values/(i + 12)]
				action: [
					temp: copy []
					append temp merge append head numbers nones
				]
				result: move-vert blk action
			]	
			#"j" #"J" #"s" #"S" [ ;Down
				blk: [ values/(i) values/(i + 4) values/(i + 8) values/(i + 12)]
				action: [
					temp: copy []
					append temp reverse merge reverse append nones head numbers
				]
				result: move-vert blk action
		
			]
			#"q" #"Q" [ quit ]  
		]
		result
	]

	win?: function [ values [block!] return: [logic!]][
		either find values 2048 [
			print "Congratulations! You win!"
			true
		][
			false
		]
	]

	lose?: function [ values [block!] return: [logic!]][
		find-adjacent: function[ blk [block!] return: [ logic ]][
			parse blk [
				some [
					set a integer! set b integer! if ( equal? a b) (return true)
					|
					skip
				]
			]
			false
		]
		
		either find values none [
			false
		][
			repeat i 4 [
				if find-adjacent reduce [ values/(i * 4 - 3) values/(i * 4 - 2) values/(i * 4 - 1) values/(i * 4)][
					return false
				]
				if find-adjacent reduce [ values/(i) values/(i + 4) values/(i + 8) values/(i + 12) ][
					return false
				]
			]
			print "What a pity!"
			true
		]
	]
	
	start: does [
		values: append/dup copy [] none 16
		values: generate values
		print ["Score: " game/score]
		print fill-content values
		command: none 
		until[
			chars: charset {HhLlKkJjAaDdWwSsQq}
			until [
				command: ask "[H] left, [L] right, [K] up, [J] down or [Q]uit?"
				all [ not none? first command find chars first command]
			]
			;probe values
			privious: copy values
			values: move first command values
			unless equal? privious values [
				values: generate values
			]
			;probe values
			print ["Score: " game/score]
			print fill-content values
			any [ win? values lose? values]
		]
		if find [#"y" #"Y"] first ask "Play again?" [ start ] 
	]
]

game/start

