Class {
	#name : #CommandManagementModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'instance creation' }
CommandManagementModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
CommandManagementModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
CommandManagementModule >> name [

	^'Commands'
]

{ #category : #private }
CommandManagementModule >> registerCommandManagementSystemForInstallationIn: systems [

	^ self register: [ CommandManagementSystem new ] in: systems
]

{ #category : #private }
CommandManagementModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
CommandManagementModule >> systemInterfacesToInstall [

	^ #(#CommandManagementSystemInterface)
]
