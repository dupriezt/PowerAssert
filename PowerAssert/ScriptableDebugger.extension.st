Extension { #name : #ScriptableDebugger }

{ #category : #'*PowerAssert' }
ScriptableDebugger >> debugAST: aBlock [
	"Same as #debug:, but uses stepAST to get to the block closure execution (this avoids skipping over the first few bytecodes as #step do"
	process := aBlock newProcess name: 'ExecutionDebuggedByScriptableDebugger'.
	debugSession := DebugSessionPlus newWithName: 'ScriptableDebuggerDebugSession' forProcess: process.
		debugSession deactivateEventTriggering.
	[ self selector = #newProcess] whileFalse: [ self step]. "Step the process to get out of the on:do: context added at the bottom of its stack"
	[self selector = #newProcess] whileTrue: [ self stepAST ]. "Step the process so that it leaves BlockClosure>>#newProcess and enters the block for which a process was created"
	^ self
]

{ #category : #'*PowerAssert' }
ScriptableDebugger class >> debugAST: aBlock [
	"Creates an execution of aBlock and returns an instance of ScriptableDebugger attached to this execution"
	^ self new debugAST: aBlock

]

{ #category : #'*PowerAssert' }
ScriptableDebugger >> stepAST [
	"Executes the next instruction. If the instruction is a message-send, step inside it."
	"See DebugSessionPlus>>#stepAST:"
	| unhandledException |
	((self currentNode isMessage) and: [(self messageSelector = #unhandledErrorDefaultAction:) and: [ self messageReceiver isKindOf: UIManager ]]) ifTrue: [ 
	"The debugged execution signalled an exception, this exception was not handled and is about to cause a debugger to open."
	"Signalling an exception **in the scriptable debugger's process** to inform the user of this"
		unhandledException := self messageArguments at: 1.
		UnhandledExceptionSignalledByADebuggedExecution signalWithException: unhandledException.
	].
	debugSession stepAST.
	stepHooks do: [ :aBlock | aBlock value ].
]

{ #category : #'*PowerAssert' }
ScriptableDebugger >> stepOverAST [
	self debugSession stepOverAST.
]
