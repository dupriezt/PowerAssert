Class {
	#name : #PowerAssertExamples,
	#superclass : #TestCase,
	#category : #PowerAssert
}

{ #category : #running }
PowerAssertExamples >> runCaseManaged [
	^ self runCase
]

{ #category : #tests }
PowerAssertExamples >> testPowerAssertExample1 [
	| array |
	array := { 2. 4. 6 }.
	self powerAssert: [ (array at: 2) % 2 ~= 0 ].
]

{ #category : #tests }
PowerAssertExamples >> testPowerAssertExample2 [
	self powerAssert: [ Point x: 5 y:6 ].
]
