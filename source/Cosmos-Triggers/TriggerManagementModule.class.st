Class {
	#name : #TriggerManagementModule,
	#superclass : #SystemModule,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Triggers-SystemModel'
}

{ #category : #'instance creation' }
TriggerManagementModule class >> toInstallOn: aCompositeSystem [

	^ self new initializeToInstallOn: aCompositeSystem
]

{ #category : #initialization }
TriggerManagementModule >> initializeToInstallOn: aCompositeSystem [

	rootSystem := aCompositeSystem
]

{ #category : #private }
TriggerManagementModule >> name [

	^ 'Action triggers'
]

{ #category : #private }
TriggerManagementModule >> registerTriggerManagementSystemForInstallationIn: systems [

	^ self register: [ TriggerManagementSystem new ] in: systems
]

{ #category : #private }
TriggerManagementModule >> rootSystem [

	^ rootSystem 
]

{ #category : #private }
TriggerManagementModule >> systemInterfacesToInstall [

	^ #(#TriggerManagementSystem)
]
