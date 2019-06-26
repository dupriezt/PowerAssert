Class {
	#name : #PowerAssertReplayer,
	#superclass : #SpPresenter,
	#instVars : [
		'evaluatedBlock',
		'debugSession',
		'replayEvaluationData',
		'stack',
		'stepIntoButton',
		'stepOverButton',
		'stepOverReplayButton',
		'restartButton',
		'codeViewer',
		'currentNodeLabel',
		'currentNodeViewer',
		'inspectDebugSessionButton'
	],
	#classVars : [
		'DebugSession_',
		'EvaluatedBlock',
		'ReplayEvaluationData'
	],
	#category : #PowerAssert
}

{ #category : #specs }
PowerAssertReplayer class >> defaultSpec [

	^ SpBoxLayout newVertical
			add: #stack withConstraints: [:cstr | cstr height: 200];
			add: (SpBoxLayout newHorizontal
				add: #stepIntoButton;
				add: #stepOverButton;
				add: #stepOverReplayButton;
				add: #restartButton;
				add: #inspectDebugSessionButton;
				yourself)
				withConstraints: [:cstr | cstr height: 25];
			add: (SpBoxLayout newHorizontal
				add: #currentNodeLabel;
				add: #currentNodeViewer;
				yourself
			) withConstraints: [ :cstr | cstr height: 55 ];
			add: #codeViewer;
			"add: #variableInspector;"
			yourself
]

{ #category : #specs }
PowerAssertReplayer class >> openOnBlock: aBlock withReplayEvaluationData: aCollection [
	| process presenter |
	process := aBlock newProcess.
	EvaluatedBlock := aBlock.
	ReplayEvaluationData := aCollection.
	DebugSession_ := DebugSession named: 'PowerAssertReplayerDebugSession' on: process startedAt: process suspendedContext.
	presenter := self new openWithSpec.
	presenter window extent: 600@600.
]

{ #category : #accessing }
PowerAssertReplayer >> debugSession [
	^ debugSession
]

{ #category : #accessing }
PowerAssertReplayer >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
PowerAssertReplayer >> evaluatedBlock [
	^ evaluatedBlock
]

{ #category : #accessing }
PowerAssertReplayer >> evaluatedBlock: anObject [
	evaluatedBlock := anObject
]

{ #category : #initialization }
PowerAssertReplayer >> initializeWidgets [
	evaluatedBlock := EvaluatedBlock.
	replayEvaluationData := ReplayEvaluationData.
	debugSession := DebugSession_.
	
	currentNodeLabel := self newLabel
		label: 'CurrentNode:';
		yourself.
	currentNodeViewer := self newText
		enabled: false;
		yourself.
	
	stepIntoButton := self newButton
		label: 'Into';
		action: [ 
			debugSession stepInto.
			self updateForNewContext: debugSession interruptedContext.
		];
		yourself.
	stepOverButton := self newButton
		label: 'Over';
		action: [ 
			debugSession stepOver.
			self updateForNewContext: debugSession interruptedContext.
		];
		yourself.
	stepOverReplayButton := self newButton
		label: 'Over (Replay)';
		action: [ 
			debugSession stepOver.
			self updateForNewContext: debugSession interruptedContext.
			UIManager default notify: 'ToDo'.
		];
		yourself.
	restartButton  := self newButton
		label: 'Restart';
		action: [ 
			debugSession restart.
			self updateForNewContext: debugSession interruptedContext.
		];
		yourself.
	inspectDebugSessionButton := self newButton
		label: 'Inspect DebugSession';
		action: [ debugSession inspect ].
	"codeViewer := self newCode
		yourself."
	codeViewer := self newText
		yourself.
	stack := self newTable
		items: debugSession stack;
		beSingleSelection;
		whenSelectionChangedDo: [ :newSelection |
			self updateForNewContext: newSelection selectedItem.
		];
		yourself.
	stack selectIndex: 1.
]

{ #category : #accessing }
PowerAssertReplayer >> replayEvaluationData [
	^ replayEvaluationData
]

{ #category : #accessing }
PowerAssertReplayer >> replayEvaluationData: anObject [
	replayEvaluationData := anObject
]

{ #category : #initialization }
PowerAssertReplayer >> title [
	^ 'PowerAssert Replayer'
]

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> updateForNewContext: aContext [
	codeViewer text: aContext method sourceCode asText.
	currentNodeViewer text: ((debugSession interruptedContext method sourceNodeForPC: debugSession interruptedContext pc) sourceCode).
	stack items: debugSession stack.
	stack selectIndex: 1.
]
