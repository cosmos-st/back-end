Class {
	#name : #TimestampingModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Timestamping'
}

{ #category : #'instance creation' }
TimestampingModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
TimestampingModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
TimestampingModule >> name [

	^ 'Timestamping'
]

{ #category : #initialization }
TimestampingModule >> registerIdentifierSystemForInstallationIn: systems [

	^ self register: [ TimestampingSystem new ] in: systems
]

{ #category : #private }
TimestampingModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
TimestampingModule >> systemInterfacesToInstall [

	^ #(#TimestampingSystemInterface)
]
