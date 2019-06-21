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
PowerAssertTest >> test2 [
	self powerAssert: [ 1 to: 5 do: [:i | Point new ] ] testMode: true.
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

{ #category : #tests }
PowerAssertTest >> testPowerAssert2 [
	| input1 input2 result |
	input1 := { 1. 3. 9. 27. 81. 243}.
	input2 := { 1. 2. 4. 8. 16. 32 }.
	result := 0.
	self powerAssert: [ 1 to: input1 size do: [:i | result := result + (input1 at: i) - (input2 at: i)]. result = 2 ].
]
