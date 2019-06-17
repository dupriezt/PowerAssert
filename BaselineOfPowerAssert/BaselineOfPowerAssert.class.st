Class {
	#name : #BaselineOfPowerAssert,
	#superclass : #BaselineOf,
	#category : #BaselineOfPowerAssert
}

{ #category : #baselines }
BaselineOfPowerAssert >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			spec
				baseline: 'ScriptableDebugger'
				with: 'github://dupriezt/ScriptableDebugger'. 
			"Packages"	
			spec
				package: 'PowerAssert'.
		]
]
