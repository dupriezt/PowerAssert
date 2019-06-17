Extension { #name : #Object }

{ #category : #'*PowerAssert' }
Object >> powerAssert: aBlock [
	| dbg startContext stkSz argAsts astToValue statements node blockNode evalList |
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
	astToValue at: blockNode body children last put: (dbg context at: (dbg context size)).
	evalList add: {blockNode body	children last.  dbg context at: (dbg context size)}.
	"dbg inspect."
	"astToValue inspect."
	evalList inspect.
]
