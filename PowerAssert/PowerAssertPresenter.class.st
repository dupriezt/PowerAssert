Class {
	#name : #PowerAssertPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'expressionViewer',
		'expressionEvaluationResult',
		'powerAssertResult',
		'executedBlock'
	],
	#classVars : [
		'ExecutedBlock',
		'PowerAssertResult'
	],
	#category : #PowerAssert
}

{ #category : #specs }
PowerAssertPresenter class >> defaultSpec [

	^ SpecPanedLayout newVertical
			add: #expressionViewer;
			add: #expressionEvaluationResult;
		yourself.
]

{ #category : #'instance creation' }
PowerAssertPresenter class >> openOn: powerAssertResult with: executedBlock [
	PowerAssertResult := powerAssertResult.
	ExecutedBlock := executedBlock.
	self new openWithSpec.
]

{ #category : #accessing }
PowerAssertPresenter >> executedBlock: aValue [
	executedBlock := aValue
]

{ #category : #initialization }
PowerAssertPresenter >> initializeWidgets [
	"initialise instance variables according to the values of the class variables"
	| text string node blockNode startStyle stopStyle styleLength stringToStyle |
	powerAssertResult := PowerAssertResult.
	executedBlock := ExecutedBlock.

	expressionViewer := self newText
		text: executedBlock sourceNode formattedCode;
		enabled: false.
	
	expressionEvaluationResult := self newTable
		beSingleSelection;
		beResizable;
		addColumn: ((IndexTableColumn title: 'Eval Order') width: 70);
		addColumn: (StringTableColumn title: 'AST Node' evaluated: [:obj | obj at: 1]);
		addColumn: (StringTableColumn title: 'Value' evaluated: [:obj | obj at: 2]);
		items: powerAssertResult;
		whenSelectionChangedDo: [:selection |
				node := selection selectedItem at: 1.
				blockNode := executedBlock sourceNode.
				startStyle := node start - blockNode start.
				stopStyle := node stop - blockNode start.
				styleLength := stopStyle - startStyle + 1.
				string := executedBlock sourceNode formattedCode.
				text := '' asText.
				text := text, (string first: startStyle) asText. "Left part. Unstyled"
				string := string last: string size - startStyle.
				stringToStyle := (string first: styleLength). "Middle part. To be styled"
				text := text, (stringToStyle asText makeAllColor: Color yellow; addAttribute: TextEmphasis underlined from: 1 to: stringToStyle size).
				text := text, (string last: string size - styleLength). "Right part. Unstyled"
				expressionViewer text: ''.
				expressionViewer text: text.
		];
		selectIndex: 1.
]

{ #category : #accessing }
PowerAssertPresenter >> powerAssertResult: aValue [
	powerAssertResult := aValue.
]

{ #category : #TOREMOVE }
PowerAssertPresenter >> title [
	^ 'PowerAssert Visualisation'
]
