"
I'm a system that manages data. 

I allow the registration of streams and data points on them.

I also allow deregistration of streams.
"
Class {
	#name : #DataStreamManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'dataStreams'
	],
	#category : #'Cosmos-Data'
}

{ #category : #'private - preconditions' }
DataStreamManagementSystem >> assertIsNotAlreadyRegistered: aDataStream [

	AssertionChecker
		refuse: [ dataStreams includes: aDataStream ]
		because: 'A data stream with that name already exists in system'
		raising: ConflictingObjectFound
]

{ #category : #installing }
DataStreamManagementSystem >> dependencies [

	^ #(#EventNotificationSystemInterface #TimestampingSystemInterface #IdentifierSystemInterface)
]

{ #category : #managing }
DataStreamManagementSystem >> deregister: aDataStream [ 
	
	dataStreams remove: aDataStream 
]

{ #category : #'private - systems' }
DataStreamManagementSystem >> eventNotificationSystem [
	
	^ self >> #EventNotificationSystemInterface
]

{ #category : #'private - systems' }
DataStreamManagementSystem >> identifierSystem [

	^ self >> #IdentifierSystemInterface
]

{ #category : #installing }
DataStreamManagementSystem >> implementedInterfaces [

	^ #(#DataStreamManagementSystemInterface)
]

{ #category : #initialization }
DataStreamManagementSystem >> initialize [

	super initialize.
	dataStreams := OrderedCollection new
]

{ #category : #accessing }
DataStreamManagementSystem >> name [ 

	^ 'Data Stream Management'
]

{ #category : #'events handling' }
DataStreamManagementSystem >> notifyDataPointWasRegisteredOn: aDataStream [

	self eventNotificationSystem
		notifySubscribersTo: (DataPointRegistrationEvent on: aDataStream)
]

{ #category : #managing }
DataStreamManagementSystem >> register: aDataStream [

	self assertIsNotAlreadyRegistered: aDataStream.
	
	dataStreams add: aDataStream.
	self registerIdentifierFor: aDataStream.
	self registerTimestampFor: aDataStream.
	
	^ aDataStream
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> register: aDataPoint to: aDataStream [

	aDataStream add: aDataPoint.
	self notifyDataPointWasRegisteredOn: aDataStream
]

{ #category : #managing }
DataStreamManagementSystem >> register: aDataPoint toStreamNamed: aName [

	self
		withStreamNamed: aName
		do: [ :dataStream | self register: aDataPoint to: dataStream ]
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> registerIdentifierFor: aDataStream [

	self identifierSystem registerIdentifierFor: aDataStream
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> registerTimestampFor: aDataStream [

	self timestampingSystem registerModificationFor: aDataStream
]

{ #category : #querying }
DataStreamManagementSystem >> streamIdentifiedBy: anIdentifier [

	^ self identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Data stream with that identifier not found' ]
]

{ #category : #querying }
DataStreamManagementSystem >> streamNamed: aName [

	^ self withStreamNamed: aName do: [ :stream | stream ]
]

{ #category : #querying }
DataStreamManagementSystem >> streams [

	^ dataStreams copy 
]

{ #category : #'private - systems' }
DataStreamManagementSystem >> timestampingSystem [
	
	^ self >> #TimestampingSystemInterface
]

{ #category : #querying }
DataStreamManagementSystem >> withStreamNamed: aName do: aFoundBlock [

	^ dataStreams
		detect: [ :dataStream | dataStream name = aName ]
		ifFound: [ :dataStream | aFoundBlock value: dataStream ]
		ifNone: [ ObjectNotFound signal: ('Data stream named <1p> not found' expandMacrosWith: aName) ]
]
