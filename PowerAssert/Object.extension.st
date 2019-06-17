Extension { #name : #Object }

{ #category : #'*PowerAssert' }
Object >> powerAssert: aBlock [
	| dbg startContext stkSz argAsts astToValue statements node blockNode evalList blockValue |
	dbg := ScriptableDebugger debug: aBlock.
	startContext := dbg context.
	astToValue := Dictionary new.
	statements := startContext closure sourceNode body children.
	blockNode := startContext closure sourceNode.
	evalList := OrderedCollection new.
	[ dbg currentNode == blockNode ] whileFalse: [
		dbg currentNode isMessage ifTrue: [
			stkSz := dbg context size.
			argAsts := dbg currentNode arguments.
			astToValue at: dbg currentNode receiver put: (dbg context at: (stkSz - argAsts size)).
			evalList add: { dbg currentNode receiver. (dbg context at: (stkSz - argAsts size)) }.
			(dbg currentNode arguments isEmpty) ifFalse: [
				1 to: argAsts size do: [ :i |
					astToValue at: (argAsts at: i) put: (dbg context at: (stkSz - argAsts size + i)).
					evalList add: { (argAsts at: i). (dbg context at: (stkSz - argAsts size + i)) }
				]
			].
		] ifFalse: [
			dbg currentNode isBlock ifFalse: [ self error: 'Not Message/Block Node']
		].
		dbg stepOver.
	].
	blockValue := dbg context at: (dbg context size).
	astToValue at: blockNode body children last put: blockValue.
	evalList add: {blockNode body	children last.  blockValue}.
	[blockValue ifFalse: [self assert: false ]] on: Exception do: [:ex|  evalList inspect. ex pass.].
]
