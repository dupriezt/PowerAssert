Class {
	#name : #PowerAssertReplayer,
	#superclass : #SpPresenter,
	#instVars : [
		'evaluatedBlock',
		'replayEvaluationData',
		'stack',
		'stepIntoButton',
		'stepOverButton',
		'stepOverReplayButton',
		'restartButton',
		'codeViewer',
		'scriptableDebugger',
		'replayValueLabel',
		'replayValueInspector',
		'inspectSelfButton',
		'inspectScriptableDebuggerButton'
	],
	#classVars : [
		'EvaluatedBlock',
		'ReplayEvaluationData',
		'ScriptableDebugger_'
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
				add: #inspectScriptableDebuggerButton;
				add: #inspectSelfButton;
				yourself)
				withConstraints: [:cstr | cstr height: 25];
			add: #codeViewer;
			add: (SpBoxLayout newHorizontal
				add: #replayValueLabel withConstraints: [:cstr | cstr width: 100];
				add: #replayValueInspector;
				yourself
			) withConstraints: [ :cstr | cstr height: 200 ];
			"add: #variableInspector;"
			yourself
]

{ #category : #specs }
PowerAssertReplayer class >> openOnBlock: aBlock withReplayEvaluationData: aCollection [
	| process presenter |
	process := aBlock newProcess.
	EvaluatedBlock := aBlock.
	ReplayEvaluationData := aCollection.
	ScriptableDebugger_ := ScriptableDebugger debug: aBlock.
	presenter := self new openWithSpec.
	presenter window extent: 600@600.
]

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> canReplay [
	^ (replayEvaluationData collect: [ :item | item at: 1 ]) identityIncludes: scriptableDebugger currentNode. 
]

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> emphasisColour [
		^ UITheme current caretColor.
]

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> emphasize: aString from: start to: stop [
	| leftPart rightPart middleAndRightPart middlePart |
	leftPart := (aString first: start - 1) asText.
	rightPart := (aString last: aString size - stop) asText.
	middleAndRightPart := aString last: aString size - start + 1.
	middlePart := (middleAndRightPart first: stop - start + 1) asText.
	middlePart := middlePart makeAllColor: self emphasisColour; addAttribute: TextEmphasis underlined from: 1 to: middlePart size.
	^ leftPart, middlePart, rightPart
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
	scriptableDebugger := ScriptableDebugger_.
	
	replayValueLabel := self newLabel
		label: 'Replay value:';
		yourself.
	replayValueInspector := StInspector on: (StInspectorModel on: nil).
	
	stepIntoButton := self newButton
		label: 'Into';
		action: [ 
			scriptableDebugger step.
			self updateForNewContext: scriptableDebugger context.
		];
		yourself.
	stepOverButton := self newButton
		label: 'Over';
		action: [ 
			scriptableDebugger stepOver.
			self updateForNewContext: scriptableDebugger context.
		];
		yourself.
	stepOverReplayButton := self newButton
		label: 'Over (Replay)';
		action: [ 
			scriptableDebugger stepOver.
			self updateForNewContext: scriptableDebugger context.
			UIManager default notify: 'ToDo'.
		];
		yourself.
	restartButton  := self newButton
		label: 'Restart';
		action: [ 
			self restart.
			self updateForNewContext: scriptableDebugger context.
		];
		yourself.
	inspectScriptableDebuggerButton := self newButton
		label: 'Inspect Scriptable Debugger';
		action: [ scriptableDebugger inspect ].
	inspectSelfButton := self newButton
		label: 'Inspect Self';
		action: [ self inspect ].
	"codeViewer := self newCode
		yourself."
	codeViewer := self newText
		yourself.
	stack := self newTable
		items: scriptableDebugger stack;
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

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> replayValue [
	| index |
	index := (replayEvaluationData collect: [ :item | item at: 1 ]) identityIndexOf: scriptableDebugger currentNode.
	^ (replayEvaluationData at: index) at: 2.
]

{ #category : #initialization }
PowerAssertReplayer >> restart [
	scriptableDebugger := ScriptableDebugger debug: evaluatedBlock.
]

{ #category : #accessing }
PowerAssertReplayer >> scriptableDebugger [
	^ scriptableDebugger
]

{ #category : #accessing }
PowerAssertReplayer >> scriptableDebugger: aValue [
	scriptableDebugger := aValue
]

{ #category : #initialization }
PowerAssertReplayer >> title [
	^ 'PowerAssert Replayer'
]

{ #category : #'as yet unclassified' }
PowerAssertReplayer >> updateForNewContext: aContext [
	codeViewer text: ''. "To force a refresh"
	codeViewer text: (self emphasize: aContext method sourceCode from: scriptableDebugger currentNode start to: scriptableDebugger currentNode stop).
	replayValueInspector model inspectedObject: nil.
	self canReplay ifTrue: [ 
		replayValueInspector model inspectedObject: self replayValue.
		replayValueInspector refresh.
		replayValueInspector initialize.
	 ].
	stack items: scriptableDebugger stack.
	stack selectIndex: 1.
	stepOverReplayButton enabled: self canReplay.
]
