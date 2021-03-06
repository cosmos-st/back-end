"
I'm metadata.

I'm being used to describe ortogonal aspects of any object.


"
Class {
	#name : #Metadata,
	#superclass : #Object,
	#instVars : [
		'aspect',
		'describedObject',
		'data'
	],
	#category : #'Cosmos-Metadata'
}

{ #category : #'instance creation' }
Metadata class >> attaching: data as: anAspect of: aDescribedObject [

	^ self new initializeAttaching: data as: anAspect of: aDescribedObject
]

{ #category : #comparing }
Metadata >> = anObject [

	^ self == anObject
		or: [ self class = anObject class
				and: [ aspect = anObject aspect
						and: [ describedObject = anObject describedObject and: [ data = anObject data ] ] ] ]
]

{ #category : #accessing }
Metadata >> aspect [

	^ aspect
]

{ #category : #accessing }
Metadata >> data [

	^ data
]

{ #category : #accessing }
Metadata >> describedObject [

	^ describedObject 
]

{ #category : #comparing }
Metadata >> hash [

	^ (aspect hash bitXor: describedObject hash) bitXor: data hash
]

{ #category : #initialization }
Metadata >> initializeAttaching: aValue as: anAspect of: aDescribedObject [

	data := aValue.
	aspect := anAspect.
	describedObject := aDescribedObject
]

{ #category : #printing }
Metadata >> printOn: aStream [

	aspect printOn: aStream.
	aStream
		nextPutAll: ' of '.
	describedObject printOn: aStream.
	aStream
		nextPutAll: ' is '.
	data printOn: aStream
]
