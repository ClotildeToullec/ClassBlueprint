Class {
	#name : #MBClassBlueprintForStModelTest,
	#superclass : #MBClassBlueprintTest,
	#instVars : [
		'externalLocalVar',
		'accessClassVar',
		'deadBranchMethod',
		'deadInvocation1',
		'stubMethod',
		'stubInvocation',
		'deadInvocations2',
		'externalPackage'
	],
	#category : #'Moose-Blueprint-Models-Tests'
}

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accesses [

	access1 := FamixStAccess new
		           accessor: accessor1;
		           variable: attribute1;
		           mooseModel: model.
	accessClassVar := FamixStAccess new
		                  source: classMethod1;
		                  variable: classVar1;
		                  mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> accessors [

	accessor1 := FamixStMethod new
		             name: 'accessors1';
		             beGetter;
		             protocol: 'accessing';
		             mooseModel: model.
	accessor2 := FamixStMethod new
		             name: 'accessor2';
		             beSetter;
			protocol: 'accessing';
		             mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> attribute1 [

	^ attribute1
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> attributes [

	attribute1 := FamixStAttribute new
		              name: 'attribute1';
		              mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classMethods [

	classMethod1 := FamixStMethod new
		                name: 'classMethod1()';
							protocol: 'protocol1';
		                isClassSide: true;
		                mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> classVars [

	classVar1 := FamixStAttribute new
		             name: 'classVar1()';
		             isClassSide: true;
		             mooseModel: model.
	classVar2 := FamixStAttribute new
		             name: 'classVar2()';
		             isClassSide: true;
		             mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> createModel [

	model := FamixStModel new.
	externalModel := FamixStModel new
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> deads [

	deadMethod1 := FamixStMethod new
		               name: 'deadMethod1()';
		               protocol: 'dead';
		               mooseModel: model.
	deadBranchMethod := FamixStMethod new
		                    name: 'deadBranchMethod1()';
		                    protocol: 'dead';
		                    mooseModel: model.
	deadInvocation1 := FamixStInvocation new
		                   sender: deadMethod1;
		                   addCandidate: deadBranchMethod;
		                   receiver: deadBranchMethod;
		                   mooseModel: model;
		                   yourself.
	stubMethod := FamixStMethod new
		              name: 'stubMethod()';
		              isStub: true;
		              yourself.
	externalClass addMethod: stubMethod.
	stubInvocation := FamixStInvocation new
		                  sender: stubMethod;
		                  addCandidate: deadBranchMethod;
		                  receiver: deadBranchMethod;
		                  mooseModel: model;
		                  yourself.
	deadInvocations2 := FamixStInvocation new
		                    sender: deadBranchMethod;
		                    addCandidate: deadMethod1;
		                    receiver: deadMethod1;
		                    mooseModel: model;
		                    yourself.

	deadAttribute := FamixStAttribute new
		                 name: 'deadAttribute';
		                 mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> defineClass [

	class := FamixStClass new
		         name: 'class';
		         addMethod: deadMethod1;
		         addMethod: initializer1;
		         addMethod: initializer2;
		         addMethod: accessor1;
		         addMethod: accessor2;
		         addMethod: external1;
		         addMethod: classMethod1;
		         addMethod: internal1;
		         addAttribute: deadAttribute;
		         addAttribute: attribute1;
		         addAttribute: classVar1;
		         addAttribute: classVar2;
		         mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externalClassConf [

	externalMethod := FamixStMethod new
		                  name: 'externalMethod()';
			protocol: 'external method';
		                  parentType: externalClass;
		                  mooseModel: model.
	externalClass := FamixStClass new
		                 name: 'externalClass';
		                 addMethod: externalMethod;
		                 mooseModel: model.
	externalPackage := FamixStPackage new
		                   name: 'externalPackage';
		                   mooseModel: model.
	externalClass parentPackage: externalPackage.
	externalInvocation1 := FamixStInvocation new
		                       sender: externalMethod;
		                       addCandidate: external1;
		                       receiver: external1;
		                       mooseModel: model;
		                       yourself
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> externals [

	external1 := FamixStMethod new
		             name: 'external1()';
		             protocol: 'externals';
		             parentType: class;
		             mooseModel: model.
	self externalClassConf
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> initializers [

	initializer1 := FamixStMethod new
		                name: 'initializer1()';
		                protocol: 'initializer';
		                isConstructor: true;
		                mooseModel: model.
	initializer2 := FamixStMethod new
		                name: 'initializer2()';
		protocol: 'initializer';
		                isConstructor: true;
		                mooseModel: model
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> internals [

	internal1 := FamixStMethod new
		             name: 'internal1()';
			protocol: 'internal implementation';
		             mooseModel: model
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testAccessOnClassVar [

	| mbVarClass |
	mbVarClass := classBlueprint classVars detect: [ :cv | 
		              cv name includesSubstring: 'classVar1' ].

	self assert: mbVarClass attributeAccess isNotEmpty.
	self
		assert: mbVarClass attributeAccess first source entity
		equals: classMethod1.
	self
		assert: mbVarClass attributeAccess first target entity
		equals: classVar1
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testAttributes [

	self
		assert: (classBlueprint allAttributes collect: #entity) asSet size
		equals: { 
				attribute1.
				deadAttribute.
				classVar1.
				classVar2 } size
]

{ #category : #accessing }
MBClassBlueprintForStModelTest >> testCheckDead [

	self assert: deadBranchMethod belongsToDeadBranch equals: false
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testClassVar [

	self assert: (classBlueprint classVars collect: #entity) equals: { 
			classVar1.
			classVar2 } asOrderedCollection
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testDeadAttributes [

	self
		assertCollection: (classBlueprint deadAttributes collect: #name)
		hasSameElements: ({ 
				 attribute1.
				 deadAttribute.
				 classVar2 } collect: #name) asOrderedCollection
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testExternals [

	self
		assert: (classBlueprint methodModels detect: [ :each | 
				 each name = 'external1()' ]) entity isCalledExternally
		equals: true.
	self deny: (classBlueprint methodModels detect: [ :each | 
			 each name = 'internal1()' ]) entity isExternal
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testInitializers [

	self
		assert: (classBlueprint initializers collect: #entity) size
		equals: { 
				initializer1.
				initializer2 } size
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testIsInitializetMethod [

	self
		assert: (classBlueprint models detect: [ :each | 
				 each name includesSubstring: 'initialize' ]) entity isInitializer
		equals: true
]

{ #category : #tests }
MBClassBlueprintForStModelTest >> testModels [

	self
		assert: (classBlueprint models collect: #entity) asSet size
		equals: { 
				deadMethod1.
				deadAttribute.
				initializer1.
				initializer2.
				accessor1.
				accessor2.
				classVar1.
				classVar2.
				attribute1.
				classMethod1.
				external1.
				internal1 } size
]
