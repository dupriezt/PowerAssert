Class {
	#name : #PowerAssertPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'expressionViewer',
		'expressionEvaluationResult',
		'executedBlock',
		'inspector',
		'inspectorLabel',
		'leftSpacerForInspectorLabel',
		'rightSpacerForInspectorLabel',
		'topSpacerForInspectorLabel',
		'evaluationData'
	],
	#classVars : [
		'ExecutedBlock',
		'PowerAssertResult'
	],
	#category : #PowerAssert
}

{ #category : #specs }
PowerAssertPresenter class >> defaultSpec [

"	^ SpecPanedLayout newVertical
			add: #expressionViewer;
			add: (SpecPanedLayout newVertical
				add: #expressionEvaluationResult;
				add: #inspector;
				yourself);
		yourself."
		
	^ SpPanedLayout newVertical
			add: (SpPanedLayout newVertical
				add: #expressionViewer;
				add: #expressionEvaluationResult;
				yourself);
			add: (SpBoxLayout newVertical
				add: #topSpacerForInspectorLabel withConstraints: [:cstr | cstr height: 10];
				add: (SpBoxLayout newHorizontal
					add: #leftSpacerForInspectorLabel;
					add: #inspectorLabel withConstraints: [:cstr | cstr expand: false];
					add: #rightSpacerForInspectorLabel;
					yourself)
					withConstraints: [:cstr | cstr expand: false];
				add: #inspector;
				yourself);
			yourself.
]

{ #category : #'instance creation' }
PowerAssertPresenter class >> openOn: powerAssertResult with: executedBlock [
	| presenter |
	PowerAssertResult := powerAssertResult.
	ExecutedBlock := executedBlock.
	presenter := self new openWithSpec.
	presenter window extent: 400@600.
	^ presenter.
]

{ #category : #accessing }
PowerAssertPresenter >> evaluationdata [
	^ evaluationData.
]

{ #category : #accessing }
PowerAssertPresenter >> evaluationdata: aValue [
	evaluationData := aValue.
]

{ #category : #accessing }
PowerAssertPresenter >> executedBlock: aValue [
	executedBlock := aValue
]

{ #category : #initialization }
PowerAssertPresenter >> highlightColour [
	^ UITheme current caretColor.
]

{ #category : #initialization }
PowerAssertPresenter >> initializeWidgets [
	"initialise instance variables according to the values of the class variables"
	| text string node blockNode startStyle stopStyle styleLength stringToStyle previousRaiseWarningValue |
	evaluationData := PowerAssertResult.
	executedBlock := ExecutedBlock.

	inspector := StInspector on: (StInspectorModel on: nil).
	
	inspectorLabel := self newLabel label: 'Inspector'; emphasis: #bold.
	leftSpacerForInspectorLabel := SpSpacerPresenter new.
	rightSpacerForInspectorLabel := SpSpacerPresenter new.
	topSpacerForInspectorLabel := SpSpacerPresenter new.

	expressionViewer := self newText
		text: executedBlock sourceNode formattedCode;
		enabled: false.
	
	expressionEvaluationResult := self newTable
		beSingleSelection;
		beResizable;
		addColumn: ((SpIndexTableColumn title: 'Eval Order') width: 70);
		addColumn: (SpStringTableColumn title: 'AST Node' evaluated: [:obj | obj at: 1]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [:obj | obj at: 2]);
		addColumn: (SpCheckBoxTableColumn title: 'replay' evaluated: [:obj | obj at: 3]);
		items: evaluationData;
		whenSelectionChangedDo: [:selection |
				inspectorLabel label: 'Inspecting: ', (selection selectedItem at: 2) asString.
				previousRaiseWarningValue := Deprecation raiseWarning.
				Deprecation raiseWarning: false. "Prevents deprecation windows popping up for the inspector whenever a new object is selected in the list"
				inspector model inspectedObject: (selection selectedItem at: 2).
				inspector refresh.
				inspector initialize. "Necessary hack for the inspector to actually refresh, until its #refresh method actually works"
				Deprecation raiseWarning: previousRaiseWarningValue. "Resets this setting value to what it was before"
				node := selection selectedItem at: 1.
				blockNode := executedBlock sourceNode.
				startStyle := node start - blockNode start.
				stopStyle := node stop - blockNode start.
				styleLength := stopStyle - startStyle + 1.
				string := executedBlock sourceNode sourceCode.
				text := '' asText.
				text := text, (string first: startStyle) asText. "Left part. Unstyled"
				string := string last: string size - startStyle.
				stringToStyle := (string first: styleLength). "Middle part. To be styled"
				text := text, (stringToStyle asText makeAllColor: self highlightColour; addAttribute: TextEmphasis underlined from: 1 to: stringToStyle size).
				text := text, (string last: string size - styleLength). "Right part. Unstyled"
				expressionViewer text: ''.
				expressionViewer text: text.
		].
	(expressionEvaluationResult items isEmpty) ifFalse: [expressionEvaluationResult selectIndex: 1].
]

{ #category : #TOREMOVE }
PowerAssertPresenter >> title [
	^ 'PowerAssert Visualisation'
]
