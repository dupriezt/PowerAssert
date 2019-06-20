Extension { #name : #Object }

{ #category : #'*PowerAssert' }
Object >> powerAssert: aBlock [
	<debuggerCompleteToSender>
	| dbg startContext stkSz argAsts blockNode evalList blockValue testResult |
	dbg := ScriptableDebugger debug: aBlock.
	startContext := dbg context.
	blockNode := startContext closure sourceNode.
	evalList := OrderedCollection new.
	[ dbg currentNode == blockNode ] whileFalse: [
		dbg currentNode isMessage ifTrue: [
			stkSz := dbg context size.
			argAsts := dbg currentNode arguments.
			evalList add: { dbg currentNode receiver. (dbg context at: (stkSz - argAsts size)) copy }.
			(dbg currentNode arguments isEmpty) ifFalse: [
				1 to: argAsts size do: [ :i |
					evalList add: { (argAsts at: i). (dbg context at: (stkSz - argAsts size + i)) copy }
				]
			].
		] ifFalse: [
			dbg currentNode isAssignment ifTrue: [ 
				evalList add: { dbg currentNode. (dbg context at: dbg context size) copy }.
			] ifFalse: [ 
				dbg currentNode isBlock ifFalse: [ self error: 'Not Message/Assignment/Block Node']
			]
		].
		dbg stepOver.
	].
	blockValue := dbg context at: (dbg context size).
	evalList add: {blockNode body	children last.  blockValue copy}.
	testResult := false.
	[blockValue ifTrue: [ testResult := true ]] on: MessageNotUnderstood do: [1].
	testResult ifFalse: [PowerAssertPresenter openOn: evalList with: aBlock. "evalList inspect." self assert: false ].
]
