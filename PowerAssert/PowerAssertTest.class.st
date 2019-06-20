Class {
	#name : #PowerAssertTest,
	#superclass : #TestCase,
	#category : #PowerAssert
}

{ #category : #'as yet unclassified' }
PowerAssertTest >> runCaseManaged [
	^ self runCase
]

{ #category : #tests }
PowerAssertTest >> testNonBooleanResult [
	self should: [self powerAssert: [ Point x:5 y:6 ] openVisualiser: false ] raise: TestFailure.
]
