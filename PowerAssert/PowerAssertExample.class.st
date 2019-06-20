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

{ #category : #tests }
PowerAssertExample >> testPowerAssert2 [
	| input1 input2 result |
	input1 := { 1. 3. 9. 27. 81. 243}.
	input2 := { 1. 2. 4. 8. 16. 32 }.
	result := 0.
	self powerAssert: [ 1 to: input1 size do: [:i | result := result + (input1 at: i) - (input2 at: i)]. result = 2 ].
]

{ #category : #tests }
PowerAssertExample >> testPowerAssert3 [
	self powerAssert: [ Point x: 5 y:6 ].
]
