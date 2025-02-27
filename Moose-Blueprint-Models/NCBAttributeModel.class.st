"
I represent a model for class attributes
"
Class {
	#name : #NCBAttributeModel,
	#superclass : #NCBHighlightableModel,
	#instVars : [
		'attributeAccess',
		'setter',
		'getter',
		'type'
	],
	#category : #'Moose-Blueprint-Models'
}

{ #category : #'instance creation' }
NCBAttributeModel class >> newFrom: anEntity [ 
	^ self new
		entity: anEntity ;
		create
]

{ #category : #accessing }
NCBAttributeModel >> accessors [

	^ { 
		  getter.
		  setter } reject: #isNil
]

{ #category : #accessing }
NCBAttributeModel >> addIncoming: anAttributeAccessModel [

	anAttributeAccessModel source isSetter ifTrue: [ 
		self setter: anAttributeAccessModel source.
		setter protecting: self ].
	anAttributeAccessModel source isCBGetter ifTrue: [ 
		self getter: anAttributeAccessModel source.
		getter protecting: self ].
	(self getter isNil and: [ 
		 anAttributeAccessModel source isLazyInitializer ])
		ifTrue: [ 
			self getter: anAttributeAccessModel source.
			getter protecting: self ]
		ifFalse: [ attributeAccess add: anAttributeAccessModel ]
]

{ #category : #accessing }
NCBAttributeModel >> attributeAccess [
	^ attributeAccess
]

{ #category : #operations }
NCBAttributeModel >> create [

	self initializeAttributeAccess.
	self initializeDescription.
	self initializeType.
]

{ #category : #accessing }
NCBAttributeModel >> directInternalAccesses [ 

	^ self entity incomingAccesses select: [ :each | each source parentType = entity parentType ].
]

{ #category : #accessing }
NCBAttributeModel >> getter [ 
	^ getter
]

{ #category : #accessing }
NCBAttributeModel >> getter: aGetter [
	getter := aGetter 
]

{ #category : #accessing }
NCBAttributeModel >> getterShape [

	^ self hasGetter
		  ifTrue: [ getter shape  ]
		  ifFalse: [ nil ]
]

{ #category : #testing }
NCBAttributeModel >> hasGetter [ 

	^ getter isNil not
]

{ #category : #testing }
NCBAttributeModel >> hasSetter [ 
	^ setter isNil not
]

{ #category : #accessing }
NCBAttributeModel >> initializeAttributeAccess [

	attributeAccess := OrderedCollection new
]

{ #category : #accessing }
NCBAttributeModel >> initializeDescription [

	description := NCBAttributeDescription newFrom: self.

]

{ #category : #accessing }
NCBAttributeModel >> initializeType [

	| subclasses sources sourcesClasses |
	subclasses := entity parentType subclassHierarchy.
	sources := entity incomingAccesses collect: #source.
	sourcesClasses := sources collect: [ :each | each parentType ].

	(sourcesClasses anySatisfy: [ :each | subclasses includes: each ]) 
		ifTrue: [ 
			self type: #'Attribute accessed by subclass(es) of this class'.
			^ self ].

	self type: #Attribute
]

{ #category : #testing }
NCBAttributeModel >> isDead [
^ self entity isDead
]

{ #category : #accessing }
NCBAttributeModel >> newIncomingConnection [

	^ CBAttributeAccessModel new
		  initializeDescription;
		  yourself
]

{ #category : #accessing }
NCBAttributeModel >> printOn: aStream [

	aStream nextPutAll: '('.
	self name asString printOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #accessing }
NCBAttributeModel >> resetTypeWithClass: aFamixStClass [

	| subclasses sources sourcesClasses |
	subclasses := aFamixStClass subclassHierarchy.
	sources := entity incomingAccesses collect: #source.
	sourcesClasses := sources collect: [ :each | each parentType ].

	sourcesClasses ifNil: [ 
		self type: #Attribute.
		^ self ].

	(sourcesClasses anySatisfy: [ :each | subclasses includes: each ]) 
		ifTrue: [ self type: #'Attribute accessed by subclass(es) of this class']
]

{ #category : #accessing }
NCBAttributeModel >> setter [ 
	^ setter
]

{ #category : #accessing }
NCBAttributeModel >> setter: aSetter [ 
	setter := aSetter 
]

{ #category : #accessing }
NCBAttributeModel >> setterShape [

	^ self hasSetter
		  ifTrue: [ setter shape  ]
		  ifFalse: [ nil ]
]

{ #category : #accessing }
NCBAttributeModel >> shape [

	shape := RSBox new
		         model: self;
		         border: self description border;
		         color: self description color;
		         height: self description height;
		         width: self description width.
	shape addInteraction: CBLayersPopup new.
	self addHighlightableInteraction.
	^ self withProtectorsOf: shape
]

{ #category : #accessing }
NCBAttributeModel >> type [ 
	^ type
]

{ #category : #accessing }
NCBAttributeModel >> type: aSymbol [ 
	type := aSymbol 
]

{ #category : #accessing }
NCBAttributeModel >> withProtectorsOf: aShape [

	| composite shapes |
	shapes := { 
		          self setterShape.
		          aShape.
		          self getterShape } reject: #isNil.
	composite := RSComposite new
		             addAll: shapes;
		             model: shapes;
		             yourself.
	RSVerticalLineLayout new
		gapSize: 1;
		on: composite nodes.
	composite adjustToChildren.
	composite padding: 1.
	composite nodes do: [ :each | each addInteraction: NCBDraggableAttribute new].
	^ composite
]
