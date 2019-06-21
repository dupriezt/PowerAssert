Class {
	#name : #PowerAsserter,
	#superclass : #Object,
	#instVars : [
		'useBasicStepOver'
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
	| testMode evaluationData assertionSuccess |
	testMode := aBoolean. "If true, this method will simply return the evaluation data so that it can be tested. Otherwise, opens a PowerAssertPresenter to show the evaluation data and signal an AssertionFailure"
	evaluationData := self recordEvaluationOf: aBlock.
	assertionSuccess := false.
	[(evaluationData last at: 2) ifTrue: [ assertionSuccess := true ]] on: MessageNotUnderstood do: [ 1. "just catch the exception and do nothing. This is in case the result of the asserted block does not understand the #ifTrue: message" ].
	assertionSuccess ifFalse: [
		testMode ifTrue: [ ^ evaluationData ].
		PowerAssertPresenter openOn: evaluationData with: aBlock.
		AssertionFailure signal: aStringOrBlock value
	]
]

{ #category : #asserting }
PowerAsserter >> assert: aBlock testMode: aBoolean [
	^ self assert: aBlock description: 'PowerAssertion failed' testMode: aBoolean.
]

{ #category : #asserting }
PowerAsserter >> evaluateAndShowEncounteredASTNodeOf: aBlock [
	PowerAssertPresenter openOn: (self recordEncounteredASTNodesOf: aBlock) with: aBlock.
	
]

{ #category : #asserting }
PowerAsserter >> firstImplementation: aBlock [
	| dbg blockNode evaluationData node |
	dbg := ScriptableDebugger debug: aBlock.
	blockNode := dbg context closure sourceNode.
	evaluationData := OrderedCollection new.
	[ dbg currentNode == blockNode ] whileFalse: [
		node := dbg currentNode.
		dbg stepOver.
		evaluationData add: { node. dbg context top }.
	].
	^ PowerAssertPresenter openOn: evaluationData with: aBlock  
]

{ #category : #initialization }
PowerAsserter >> initialize [
	useBasicStepOver := false
]

{ #category : #asserting }
PowerAsserter >> recordEncounteredASTNodesOf: aBlock [
	"Evaluate aBlock step-by-step. Record only the AST nodes that are encountered (not their value)"
	| dbg evaluationData blockNode |
	dbg := ScriptableDebugger debug: aBlock.
	evaluationData := OrderedCollection new.
	blockNode := dbg context closure sourceNode.

	[dbg currentNode == blockNode] whileFalse: [
		evaluationData add: {dbg currentNode.nil}. useBasicStepOver ifTrue: [dbg stepOverBasic] ifFalse: [dbg stepOver].
	].
	^ evaluationData.
]

{ #category : #asserting }
PowerAsserter >> recordEvaluationOf: aBlock [
	| dbg evaluationData blockNode node |
	dbg := ScriptableDebugger debug: aBlock.
	evaluationData := OrderedCollection new.
	blockNode := dbg context closure sourceNode.

	[dbg currentNode == blockNode] whileFalse: [
		">"evaluationData add: {dbg currentNode.1}. dbg stepOverBasic.
		"self switch: { 
			{ [dbg currentNode isKindOf: RBTemporaryNode]. [ node := dbg currentNode. dbg stepOverBasic. evaluationData add: {node. dbg context top}] }
		} else: [ self error: 'Unrecognised node' ]."
		"dbg stepOverBasic."
	].
	">" evaluationData add: { 1. false }.
	^ evaluationData.
]

{ #category : #'as yet unclassified' }
PowerAsserter >> switch: aCollection else: aBlock [
	"Switch case. Expects aCollection to be of the form: {{conditionBlock1. statementBlock1}. {conditionBlock2. statementBlock2}. ...}"
	aCollection do: [ :item |
		(item at: 1) value ifTrue: [ (item at: 2) value. ^ self ]
	].
	aBlock value.
]

{ #category : #accessing }
PowerAsserter >> useBasicStepOver [
	^ useBasicStepOver
]

{ #category : #accessing }
PowerAsserter >> useBasicStepOver: anObject [
	useBasicStepOver := anObject
]
