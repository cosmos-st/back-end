Class {
	#name : #MetadataModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Metadata'
}

{ #category : #'instance creation' }
MetadataModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
MetadataModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
MetadataModule >> name [

	^'Metadata'
]

{ #category : #private }
MetadataModule >> registerMetadataSystemForInstallationIn: systems [

	^ self register: [ MetadataSystem new ] in: systems
]

{ #category : #private }
MetadataModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
MetadataModule >> systemInterfacesToInstall [

	^#(#MetadataSystemInterface)
]
