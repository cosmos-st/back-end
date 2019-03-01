Class {
	#name : #IdentifierModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'instance creation' }
IdentifierModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
IdentifierModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
IdentifierModule >> name [

	^ 'Identifiers'
]

{ #category : #private }
IdentifierModule >> registerIdentifierSystemForInstallationIn: systems [

	^ self register: [ IdentifierSystem using: UUIDProvider new ] in: systems
]

{ #category : #private }
IdentifierModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
IdentifierModule >> systemInterfacesToInstall [

	^ #(#IdentifierSystemInterface)
]
