Class {
	#name : #PowerAsserterTest,
	#superclass : #TestCase,
	#instVars : [
		'pAsserter'
	],
	#category : #PowerAssert
}

{ #category : #tests }
PowerAsserterTest >> evalBlock: aBlock [
	^ aBlock value.
]

{ #category : #tests }
PowerAsserterTest >> exampleEvaluateBlock [
	^ [ self evalBlock: [ Point x:3 y:5 ] ]
]

{ #category : #tests }
PowerAsserterTest >> exampleIfTrueIfFalse [
	| flag array |
	flag := true.
	array := { 2.4 }.
	^ [ (flag ifTrue: [ array at: 1] ifFalse: [ array at: 2 ]) = 4].
]

{ #category : #'as yet unclassified' }
PowerAsserterTest >> exampleNumberToDo [
	^ [ 1 to: 3 do: [:i | Point x: i y: 2*i ] ]
]

{ #category : #tests }
PowerAsserterTest >> exampleStatements [
	^ [ Point x:1 y:2. Point x:3 y:4 ]
]

{ #category : #'as yet unclassified' }
PowerAsserterTest >> exampleYadriggy [
	| array |
	array := { 2. 4. 6 }.
	^ [ (array at: 2) % 2 ~= 0 ]
]

{ #category : #'as yet unclassified' }
PowerAsserterTest >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
PowerAsserterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	pAsserter := PowerAsserter new
]

{ #category : #tests }
PowerAsserterTest >> testNonBooleanResult [
	| res |
	res := pAsserter assert: [ Point x:5 y:6 ] testMode: true.
	self assert: (((res at: 1) at: 2) isKindOf: Point class). "It's not exactly the Point class, because the values are copies"
	self assert: ((res at: 2) at: 2) equals: 5.
	self assert: ((res at: 3) at: 2) equals: 6.
	self assert: (((res at: 4) at: 2) isKindOf: Point).
]

{ #category : #tests }
PowerAsserterTest >> testPowerAssert2 [
	| input1 input2 result |
	input1 := { 1. 3. 9. 27. 81. 243}.
	input2 := { 1. 2. 4. 8. 16. 32 }.
	result := 0.
	pAsserter assert: [ 1 to: input1 size do: [:i | result := result + (input1 at: i) - (input2 at: i)]. result = 2 ].
]

{ #category : #tests }
PowerAsserterTest >> testStepOverIfTrue [
	| dbg |
	dbg := ScriptableDebugger debug: [ true ifTrue: [ Point new ] ].
	dbg currentNode inspect.
]

{ #category : #tests }
PowerAsserterTest >> testToDo [
	pAsserter assert: [ 1 to: 5 do: [:i | Point new ] ] testMode: true.
]

{ #category : #tests }
PowerAsserterTest >> test_bytecodeOf_exampleEvaluateBlock [
	(OpalCompiler new compile: 'DoIt
	^ [ self evalBlock: [ Point x:3 y:5 ] ]') inspect
]

{ #category : #tests }
PowerAsserterTest >> test_firstImplementation_evaluateBlock [
	pAsserter firstImplementation: self exampleEvaluateBlock.
]

{ #category : #tests }
PowerAsserterTest >> test_firstImplementation_ifTrueIfFalse [
	pAsserter firstImplementation: self exampleIfTrueIfFalse.
]

{ #category : #tests }
PowerAsserterTest >> test_firstImplementation_numberToDo [
	pAsserter firstImplementation: self exampleNumberToDo.
]

{ #category : #tests }
PowerAsserterTest >> test_firstImplementation_statements [
	pAsserter firstImplementation: self exampleStatements.
]

{ #category : #tests }
PowerAsserterTest >> test_firstImplementation_yadriggy [
	pAsserter firstImplementation: self exampleYadriggy.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_evaluateBlock_basicStepOver [
	pAsserter useBasicStepOver: true.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleEvaluateBlock.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_evaluateBlock_stepOver [
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleEvaluateBlock.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_ifTrueIfFalse_basicStepOver [
	pAsserter useBasicStepOver: true.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleIfTrueIfFalse.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_ifTrueIfFalse_stepOver [
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleIfTrueIfFalse.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_numberToDo_basicStepOver [
	pAsserter useBasicStepOver: true.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleNumberToDo.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_numberToDo_stepOver [
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleNumberToDo.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_statements_basicStepOver [
	pAsserter useBasicStepOver: true.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleStatements.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_statments_stepOver [
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleStatements.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_yadriggyExample_basicStepOver [
	| array |
	array := { 2. 4. 6 }.
	pAsserter useBasicStepOver: true.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleYadriggy.
]

{ #category : #tests }
PowerAsserterTest >> test_recordAST_yadriggyExample_stepOver [
	| array |
	array := { 2. 4. 6 }.
	pAsserter evaluateAndShowEncounteredASTNodeOf: self exampleYadriggy.
]

{ #category : #tests }
PowerAsserterTest >> test_secondImplementation_evaluateBlock [
	pAsserter secondImplementation: self exampleEvaluateBlock.
]

{ #category : #tests }
PowerAsserterTest >> test_secondImplementation_ifTrueIfFalse [
	pAsserter secondImplementation: self exampleIfTrueIfFalse.
]

{ #category : #tests }
PowerAsserterTest >> test_secondImplementation_numberToDo [
	pAsserter secondImplementation: self exampleNumberToDo.
]

{ #category : #tests }
PowerAsserterTest >> test_secondImplementation_statements [
	pAsserter secondImplementation: self exampleStatements.
]

{ #category : #tests }
PowerAsserterTest >> test_secondImplementation_yadriggy [
	pAsserter secondImplementation: self exampleYadriggy.
]

{ #category : #tests }
PowerAsserterTest >> testifTrueIfFalse [
	| flag array |
	flag := true.
	array := { 2.4 }.
	"Works but powerassert misses the 'flag' node, probably because of a compilation optimisation of ifTrue:ifFalse:"
	pAsserter assert: [ (flag ifTrue: [ array at: 1] ifFalse: [ array at: 2 ]) = 4].
]
