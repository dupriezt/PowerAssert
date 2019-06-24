Class {
	#name : #PowerAsserterTest,
	#superclass : #TestCase,
	#instVars : [
		'pAsserter'
	],
	#category : #PowerAssert
}

{ #category : #example }
PowerAsserterTest >> evalBlock: aBlock [
	^ aBlock value.
]

{ #category : #example }
PowerAsserterTest >> exampleEvaluateBlock [
	^ [ self evalBlock: [ Point x:3 y:5 ] ]
]

{ #category : #example }
PowerAsserterTest >> exampleIfTrueIfFalse [
	| flag array |
	flag := true.
	array := { 2. 4 }.
	^ [ (flag ifTrue: [ array at: 1] ifFalse: [ array at: 2 ]) = 4].
]

{ #category : #example }
PowerAsserterTest >> exampleNumberToDo [
	^ [ 1 to: 3 do: [:i | Point x: i y: 2*i ] ]
]

{ #category : #example }
PowerAsserterTest >> exampleStatements [
	^ [ Point x:1 y:2. Point x:3 y:4 ]
]

{ #category : #example }
PowerAsserterTest >> exampleYadriggy [
	| array |
	array := { 2. 4. 6 }.
	^ [ (array at: 2) % 2 ~= 0 ]
]

{ #category : #running }
PowerAsserterTest >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
PowerAsserterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	pAsserter := PowerAsserter new
]

{ #category : #tests }
PowerAsserterTest >> test_evaluateBlock_componentApproach [
	"Not a real test"
	"Correct. The self node is recorded"
	pAsserter recordingMethodName: #recordEvaluationOf_componentApproach:.
	pAsserter evaluateAndRecord: self exampleEvaluateBlock.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_evaluateBlock_stepOver [
	"Not a real test"
	"Correct. The self node is not recorded. "
	pAsserter recordingMethodName: #recordEvaluationOf_stepOver:.
	pAsserter evaluateAndRecord: self exampleEvaluateBlock.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_evaluateBlock_stepOverAST [
	"Not a real test"
	"Correct. The self node is recorded"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOverAST:.
	pAsserter evaluateAndRecord: self exampleEvaluateBlock.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_ifTrueIfFalse_componentApproach [
	"Not a real test"
	"Incorrect. The array temp is recorded. The flag temp is not recorded. The = message-send is recorded."
	pAsserter recordingMethodName: #recordEvaluationOf_componentApproach:.
	pAsserter evaluateAndRecord: self exampleIfTrueIfFalse.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_ifTrueIfFalse_stepOver [
	"Not a real test"
	"Incorrect. The flag temp and the ifTrue:ifFalse: message-send are not seen in the recording. The value of 'array at: 1' is wrong (it is 4, while it is supposed to be 2)"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOver:.
	pAsserter evaluateAndRecord: self exampleIfTrueIfFalse.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_ifTrueIfFalse_stepOverAST [
	"Not a real test"
	"Incorrect. The flag temp is recorded. The ifTrue:ifFalse message sent is recorded once with the value of the array temp (wrong) and later with 2 (correct)"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOverAST:.
	pAsserter evaluateAndRecord: self exampleIfTrueIfFalse.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_numberToDo_componentApproach [
	"Not a real test"
	"Incorrect. Signals a SubscriptOutOfBound exception when recording the components of the to:do: message. When recording the receiver (the 1), the recording method assumes the receiver and all the arguments of the to:do: are on the stack (so 3 values), but they are not. There is just nil and 1 on the stack, instead of nil (I guess. I'm not sure what this nil is for), 1, 3 and the block."
	pAsserter recordingMethodName: #recordEvaluationOf_componentApproach:.
	pAsserter evaluateAndRecord: self exampleNumberToDo.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_numberToDo_stepOver [
	"Not a real test"
	"Incorrect. to:do: is compiled in-line. Multiple bytecode instructions are mapped to the to:do: message node (instead of being tied more precisely to its argument nodes etc) so this node is much more present in the recording than it should be. And the recorded values are all over the place."
	pAsserter recordingMethodName: #recordEvaluationOf_stepOver:.
	pAsserter evaluateAndRecord: self exampleNumberToDo.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_numberToDo_stepOverAST [
	"Not a real test"
	"Incorrect. The end check of the recording method (dbg currentNode == blockNode) is true immediately, so no recording happen. The first encountered bytecode is '61 <73>, pushConstant: nil', and its associated source node is the entire block for some reason"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOverAST:.
	pAsserter evaluateAndRecord: self exampleNumberToDo.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_statements_componentApproach [
	"Not a real test"
	"Incorrect. Does not pick up the first message-send, because it does not appear as a component (receiver/argument) of another message-send/assignment"
	pAsserter recordingMethodName: #recordEvaluationOf_componentApproach:.
	pAsserter evaluateAndRecord: self exampleStatements.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_statements_stepOver [
	"Not a real test"
	"Incorrect. Only shows message-send (which is fine in this case), but gets the value of the first message-send wrong. Probably because after the execution is stepped from the first message-send to the other, the value of the first is popped from the stack, preventing the recording function from accessing it (instead, it picks up the second argument of the second message-send (4))"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOver:.
	pAsserter evaluateAndRecord: self exampleStatements.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_statements_stepOverAST [
	"Not a real test"
	"Incorrect. Yields a SubscriptOutOfBound when it tries to get the value of the first message-send just after stepping over it. Since it is an ast step, the execution just popped the value of the first message-send and did not yet pushed the reveiver/arguments of the second when the recording function access the value stack"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOverAST:.
	pAsserter evaluateAndRecord: self exampleStatements.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_yadriggyExample_componentApproach [
	"Not a real test"
	"Correct. Shows all literals and the array temp"
	pAsserter recordingMethodName: #recordEvaluationOf_componentApproach:.
	pAsserter evaluateAndRecord: self exampleYadriggy.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_yadriggyExample_stepOver [
	"Not a real test"
	"Incorrect. Does not show litteral nodes, but they aren't that important anyway. Does not show the content of the array temp"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOver:.
	pAsserter evaluateAndRecord: self exampleYadriggy.
	pAsserter showEvaluationData.
]

{ #category : #tests }
PowerAsserterTest >> test_yadriggyExample_stepOverAST [
	"Not a real test"
	"Correct. Shows all literals and the array temp"
	pAsserter recordingMethodName: #recordEvaluationOf_stepOverAST:.
	pAsserter evaluateAndRecord: self exampleYadriggy.
	pAsserter showEvaluationData.
]
