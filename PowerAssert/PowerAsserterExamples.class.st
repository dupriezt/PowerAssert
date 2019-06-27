Class {
	#name : #PowerAsserterExamples,
	#superclass : #TestCase,
	#category : #PowerAssert
}

{ #category : #tests }
PowerAsserterExamples >> testPowerAsserterReplayerExample [
	"In this example, we pick a divisor of 60 at random, divide 60 by it, and check that the result is an integer. This test passes for all elements of the divisorsOfSixty array, except the first one: 0. If the 0 is picked at random, the test fails because of a division by zero"
	| divisorsOfSixty |
	divisorsOfSixty := { 0. 1. 2. 3. 4. 5. 6. 10. 12. 15. 20. 30. 60 }.
	1 to: 10 do: [ :i | "This loop is not supposed to be part of the test. It just repeats the test multiple times to have a higher chance at getting the bug"
		PowerAsserter new assert: [ (60 / (divisorsOfSixty at: divisorsOfSixty size atRandom)) isInteger ]
	].
]

{ #category : #tests }
PowerAsserterExamples >> testPowerAsserterReplayerExample_clean [
	| divisorsOfSixty |
	divisorsOfSixty := { 0. 1. 2. 3. 4. 5. 6. 10. 12. 15. 20. 30. 60 }.
	PowerAsserter new assert: [ (60 / (divisorsOfSixty at: divisorsOfSixty size atRandom)) isInteger]
]
