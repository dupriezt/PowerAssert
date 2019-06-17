Class {
	#name : #MyTestCase,
	#superclass : #TestCase,
	#category : #PowerAssert
}

{ #category : #running }
MyTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #tests }
MyTestCase >> testPowerAssert [
	| array |
	array := { 2. 4. 6 }.
	self powerAssert: [ (array at: 2) % 2 ~= 0 ].
]
