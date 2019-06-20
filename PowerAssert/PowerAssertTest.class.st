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
	| res |
	res := self powerAssert: [ Point x:5 y:6 ] testMode: true.
	self assert: (((res at: 1) at: 2) isKindOf: Point class). "It's not exactly the Point class, because the values are copies"
	self assert: ((res at: 2) at: 2) equals: 5.
	self assert: ((res at: 3) at: 2) equals: 6.
	self assert: (((res at: 4) at: 2) isKindOf: Point).
]
