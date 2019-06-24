Extension { #name : #DebugSessionPlus }

{ #category : #'*PowerAssert' }
DebugSessionPlus >> stepAST [
	self stepAST: interruptedContext.
]

{ #category : #'*PowerAssert' }
DebugSessionPlus >> stepAST: aContext [
	"Like a stepInto, but instead of stepping until an 'interesting' bytecode is reached, it steps until the current ast node is different."
	| currentNode |
	"Should not step more a process that is terminating, otherwise the image will get locked."
	self interruptedProcess isTerminating ifTrue: [ SteppingATerminatingProcess signal ].

	(self isContextPostMortem: aContext) ifTrue: [^ self].

	currentNode := interruptedProcess suspendedContext sourceNode.
	[interruptedProcess suspendedContext sourceNode == currentNode] whileTrue: [interruptedProcess step: aContext].
	self updateContextTo: interruptedProcess suspendedContext.
	"self updateContextTo: (self stepToFirstInterestingBytecodeIn: interruptedProcess)."
	
	triggerEventOn ifTrue: [self triggerEvent: #stepInto]
]

{ #category : #'*PowerAssert' }
DebugSessionPlus >> stepOverAST [
	self stepOverAST: interruptedContext.
]

{ #category : #'*PowerAssert' }
DebugSessionPlus >> stepOverAST: aContext [
	"Same as step over, but instead of then stepping to the next interesting bytecode, step until the current ast node is different."
	| newContext astNodeGetter previousASTNode |
	"Should not step more a process that is terminating, otherwise the image will get locked."
	self interruptedProcess isTerminating ifTrue: [ SteppingATerminatingProcess signal ].

	"Send the selected message in selectedContext, and regain control 
	after the invoked method returns."	
	(self isContextPostMortem: aContext) ifTrue: [^ self].
	
	astNodeGetter := [ interruptedProcess suspendedContext method sourceNodeForPC: interruptedProcess suspendedContext pc ].
	previousASTNode := astNodeGetter value.
	newContext := interruptedProcess completeStep: aContext.
	self updateContextTo:  
		(newContext == aContext
			ifTrue: [ (astNodeGetter value == previousASTNode) ifTrue: [ self stepOverAST ]. interruptedProcess suspendedContext  ]
			ifFalse: [ newContext ]).

	triggerEventOn ifTrue: [self triggerEvent: #stepOver]
]
