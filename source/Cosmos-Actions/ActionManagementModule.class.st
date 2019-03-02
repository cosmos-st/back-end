Class {
	#name : #ActionManagementModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'instance creation' }
ActionManagementModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
ActionManagementModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
ActionManagementModule >> name [

	^ 'Actions'
]

{ #category : #private }
ActionManagementModule >> registerMetadataSystemForInstallationIn: systems [

	^ self register: [ ActionManagementSystem new ] in: systems
]

{ #category : #private }
ActionManagementModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
ActionManagementModule >> systemInterfacesToInstall [

	^ #(#ActionManagementSystemInterface)
]
