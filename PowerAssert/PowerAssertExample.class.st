Class {
	#name : #PowerAssertExample,
	#superclass : #TestCase,
	#category : #PowerAssert
}

{ #category : #running }
PowerAssertExample >> runCaseManaged [
	^ self runCase
]

{ #category : #tests }
PowerAssertExample >> testPowerAssert [
	| array |
	array := { 2. 4. 6 }.
	self powerAssert: [ (array at: 2) % 2 ~= 0 ].
]
