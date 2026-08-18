Class {
	#name : 'BaselineOfTlaloc',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfTlaloc',
	#package : 'BaselineOfTlaloc'
}

{ #category : 'baselines' }
BaselineOfTlaloc >> baseline: spec [
	"baseline"

	<baseline>
	spec for: #common do: [ "Dependencies"
			self patternBuffer: spec.

			"Packages"
			spec package: 'Tlaloc' ]
]

{ #category : 'dependencies' }
BaselineOfTlaloc >> patternBuffer: spec [
	"baseline for PatternBuffer"

	spec baseline: 'PatternBuffer' with: [ spec repository: 'github://capsulecorplab/patternbuffer:v0.5.1/src' ]
]
