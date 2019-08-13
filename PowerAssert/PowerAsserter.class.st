Class {
	#name : #PowerAsserter,
	#superclass : #Object,
	#instVars : [
		'recordingMethodName',
		'evaluationData',
		'evaluatedBlock'
	],
	#category : #PowerAssert
}

{ #category : #asserting }
PowerAsserter >> assert: aBlock [
	^ self assert: aBlock description: 'PowerAssertion failed'.
]

{ #category : #asserting }
PowerAsserter >> assert: aBlock description: aStringOrBlock [
	^ self assert: aBlock description: aStringOrBlock testMode: false.
]

{ #category : #asserting }
PowerAsserter >> assert: aBlock description: aStringOrBlock testMode: aBoolean [
	| testMode assertionSuccess |
	testMode := aBoolean. "If true, this method will simply return the evaluation data so that it can be tested. Otherwise, opens a PowerAssertPresenter to show the evaluation data and signal an AssertionFailure"
"	evaluationData := self recordEvaluationOf: aBlock."
	self evaluateAndRecord: aBlock.
	assertionSuccess := false.
	[(evaluationData last at: 2) ifTrue: [ assertionSuccess := true ]] on: MessageNotUnderstood do: [ 1. "just catch the exception and do nothing. This is in case the result of the asserted block does not understand the #ifTrue: message" ].
	assertionSuccess ifFalse: [
		testMode ifTrue: [ ^ evaluationData ].
		self showEvaluationData.
		AssertionFailure signal: aStringOrBlock value
	]
]

{ #category : #asserting }
PowerAsserter >> assert: aBlock testMode: aBoolean [
	^ self assert: aBlock description: 'PowerAssertion failed' testMode: aBoolean.
]

{ #category : #'as yet unclassified' }
PowerAsserter >> evaluateAndRecord: aBlock [
	evaluatedBlock := aBlock.
	evaluationData := self perform: recordingMethodName with: aBlock.
	evaluationData := evaluationData collect: [ :item | item asOrderedCollection add: false; yourself ].
]

{ #category : #accessing }
PowerAsserter >> evaluationData [
	^ evaluationData
]

{ #category : #initialization }
PowerAsserter >> initialize [
	recordingMethodName := #recordEvaluationOf_stepOverAST:
]

{ #category : #recordingMethods }
PowerAsserter >> recordEvaluationOf_componentApproach: aBlock [
	| dbg evaluationData_ blockNode stkSz argAsts blockValue |
	dbg := SindarinDebugger debug: aBlock.
	evaluationData_ := OrderedCollection new.
	blockNode := dbg context closure sourceNode.

	[ dbg currentNode == blockNode ] whileFalse: [
		dbg currentNode isMessage ifTrue: [
			stkSz := dbg context size.
			argAsts := dbg currentNode arguments.
			evaluationData_ add: { dbg currentNode receiver. (dbg context at: (stkSz - argAsts size)) copy }.
			(dbg currentNode arguments isEmpty) ifFalse: [
				1 to: argAsts size do: [ :i |
					evaluationData_ add: { (argAsts at: i). (dbg context at: (stkSz - argAsts size + i)) copy }
				]
			].
		] ifFalse: [
			dbg currentNode isAssignment ifTrue: [ 
				evaluationData_ add: { dbg currentNode. (dbg context at: dbg context size) copy }.
			] ifFalse: [ 
				dbg currentNode isBlock ifFalse: [ self error: 'Not Message/Assignment/Block Node']
			]
		].
		dbg stepOver.
	].
	blockValue := dbg context at: (dbg context size).
	evaluationData_ add: {blockNode body	children last.  blockValue copy}.
	^ evaluationData_.
]

{ #category : #recordingMethods }
PowerAsserter >> recordEvaluationOf_stepOver: aBlock [
	| dbg evaluationData_ blockNode node |
	dbg := SindarinDebugger debug: aBlock.
	evaluationData_ := OrderedCollection new.
	blockNode := dbg context closure sourceNode.

	[dbg currentNode == blockNode] whileFalse: [
		node := dbg currentNode.
		dbg stepOver.
		evaluationData_ add: {node.dbg context top}.
		"self switch: { 
			{ [dbg currentNode isKindOf: RBTemporaryNode]. [ node := dbg currentNode. dbg stepOverBasic. evaluationData add: {node. dbg context top}] }
		} else: [ self error: 'Unrecognised node' ]."
		"dbg stepOverBasic."
	].
	^ evaluationData_.
]

{ #category : #recordingMethods }
PowerAsserter >> recordEvaluationOf_stepOverAST: aBlock [
	| dbg evaluationData_ blockNode node blockContext |
	dbg := SindarinDebugger debugAST: aBlock.
	evaluationData_ := OrderedCollection new.
	blockNode := dbg context closure sourceNode.
	blockContext:= dbg context.
	
	[dbg currentNode == blockNode] whileFalse: [
		node := dbg currentNode.
		dbg stepOverAST.
		"(dbg context ~= blockContext ) ifTrue: [ self halt ]."
		evaluationData_ add: {node. dbg context top}. 
	].
	^ evaluationData_.
]

{ #category : #accessing }
PowerAsserter >> recordingMethodName [
	^ recordingMethodName
]

{ #category : #accessing }
PowerAsserter >> recordingMethodName: anObject [
	recordingMethodName := anObject
]

{ #category : #accessing }
PowerAsserter >> showEvaluationData [
	PowerAssertPresenter openOn: evaluationData with: evaluatedBlock.
]
