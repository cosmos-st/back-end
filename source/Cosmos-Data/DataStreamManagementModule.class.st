Class {
	#name : #DataStreamManagementModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Data'
}

{ #category : #'instance creation' }
DataStreamManagementModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
DataStreamManagementModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
DataStreamManagementModule >> name [

	^'Data streams'
]

{ #category : #private }
DataStreamManagementModule >> registerDataStreamManagementSystemForInstallationIn: systems [

	^ self register: [ DataStreamManagementSystem new ] in: systems
]

{ #category : #private }
DataStreamManagementModule >> rootSystem [

	^ rootSystem
]

{ #category : #private }
DataStreamManagementModule >> systemInterfacesToInstall [

	^ #(#DataStreamManagementSystemInterface)
]
