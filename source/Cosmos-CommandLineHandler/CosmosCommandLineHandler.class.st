"
Usage: printVersion [ --port | --debug-mode ]
	--port Port number for http server
	--debug-mode Http server should be installed in debug mode
	
Documentation:
Prints the version number in an easy to parse format. This can be used in Jenkins with the ""Description Setter"" Plugin. Configure it like this:

Regular expression:  \[version\] (.*)
Description: \1


Examples:
	pharo Pharo.image printVersion
	#result will be something like:
	[version] 3.0 #30100

	pharo Pharo.image printVersion --numeric
	# will print a simpler version
	30100
	
	pharo Pharo.image printVersion --release
	# prints the Pharo release version
	3.0
"
Class {
	#name : #CosmosCommandLineHandler,
	#superclass : #ApplicationStarterCommandLineHandler,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-CommandLineHandler'
}

{ #category : #accessing }
CosmosCommandLineHandler class >> commandName [

	^ 'cosmos'
]

{ #category : #accessing }
CosmosCommandLineHandler class >> description [

	^ 'Cosmos command line handler'
]

{ #category : #'private - building cosmos API' }
CosmosCommandLineHandler >> addDumpStackErrorHandlerOn: api [

	api
		on: self exceptionsToHandle
		addErrorHandler: [ :signal :request | self dumpStackAndReport: signal ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	^ self configuration at: 'allowed-origins'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> baseUrl [

	^ ('http://' , self hostname) asUrl port: self port
]

{ #category : #activation }
CosmosCommandLineHandler >> basicActivate [

	self
		logInfo: 'Building and starting cosmos' 
			during: [ self buildAndStartCosmos ];
		logInfo: 'Building and starting RESTful API' 
			during: [ self buildAndStartCosmosAPI ];
		logInfo: 'Building and starting the periodical scheduler'
			during: [ self buildAndStartScheduler ]
]

{ #category : #'private - building cosmos system' }
CosmosCommandLineHandler >> buildAndStartCosmos [

	cosmos := CompositeSystem new.

	cosmos
		register: (TimeSystem using: SystemTimeSource new);
		register: EventNotificationSystem new;
		register: MetadataSystem new;
		register: (IdentifierSystem using: UUIDProvider new);
		register: TimestampingSystem new;
		register: DataStreamManagementSystem new;
		register: TriggerManagementSystem new;
		register: ActionManagementSystem new;
		register: CommandManagementSystem new.
		
	cosmos startUp
]

{ #category : #'private - building cosmos API' }
CosmosCommandLineHandler >> buildAndStartCosmosAPI [

	| api |

	api := HTTPBasedRESTfulAPI
		configuredBy:
			{(#port -> self port).
			(#debugMode -> self isDebugModeEnabled).
			(#serverUrl -> self baseUrl)}
		installing:
			{(DataStreamsRESTfulController workingWith: cosmos).
			(DataPointsRESTfulController workingWith: cosmos).
			(CommandsRESTfulController workingWith: cosmos).
			(ActionsRESTfulController workingWith: cosmos).
			(TriggersRESTfulController workingWith: cosmos)}.

	self addDumpStackErrorHandlerOn: api.
	self setAllowedCrossOriginResourseSharingOn: api.

	api
		install;
		start
]

{ #category : #'private - building scheduler' }
CosmosCommandLineHandler >> buildAndStartScheduler [

	| scheduler |

	scheduler := self periodicalScheduler.

	self timePeriodsToSchedule
		do: [ :timePeriod | 
			| task |

			task := Task
				named: ('Notify every <1p>' expandMacrosWith: timePeriod)
				do: [ cosmos >> #EventNotificationSystemInterface
						notifySubscribersTo: (TickEvent of: timePeriod) ].

			scheduler schedule: task toBeExecutedEvery: timePeriod ].

	scheduler start
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add: (OptionalArgument named: 'hostname' defaultingTo: 'localhost');
		add: (OptionalArgument named: 'port' defaultingTo: 57001 convertingWith: #asNumber);
		add:
			(MandatoryArgument
				named: 'allowed-origins'
				convertingWith: [ :string | ((string substrings: ',') collect: #trim) collect: #asUrl ]);
		asArray
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> hostname [

	^ self configuration at: 'hostname'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> logPrefix [

	^ 'cosmos'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	| schedulerClass |

	self flag: 'hack due to a bad deprecation from pharo, remove after drop support to Pharo 6.x'.
	
	(Smalltalk hasClassNamed: #DelaySpinScheduler)
		ifTrue: [ schedulerClass := Smalltalk classNamed: #DelaySpinScheduler ]
		ifFalse: [ schedulerClass := Smalltalk classNamed: #DelaySemaphoreScheduler ].

	^ PeriodicalScheduler workingWith: schedulerClass new
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> port [

	^ self configuration at: 'port'
]

{ #category : #'private - building cosmos API' }
CosmosCommandLineHandler >> setAllowedCrossOriginResourseSharingOn: api [

	api beCORSAwareAllowing: self allowedOrigins
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> timePeriodsToSchedule [

	^ {(TimeUnits second with: 10).
	(TimeUnits minute with: 1).
	(TimeUnits minute with: 10).
	(TimeUnits hour with: 1)}
]
