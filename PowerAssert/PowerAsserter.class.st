Class {
	#name : #PowerAsserter,
	#superclass : #Object,
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
PowerAsserter >> recordEvaluationOf: aBlock [
	self shouldBeImplemented.
]
