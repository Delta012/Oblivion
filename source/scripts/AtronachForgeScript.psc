Scriptname AtronachForgeScript extends ObjectReference

Activator Property SummonFX Auto

Actor Property PlayerRef Auto

FormList Property RecipeList Auto
FormList Property ResultList Auto
FormList Property SigilRecipeList Auto
FormList Property SigilResultList Auto

ObjectReference Property CreatePoint Auto
ObjectReference Property DropBox Auto
ObjectReference Property LastSummonedObject Auto Hidden
ObjectReference Property SummonFXPoint Auto

Bool Property SigilStoneInstalled Auto Hidden

State Busy
	
	Event OnActivate(ObjectReference akActionRef)
	
		;None
	
	EndEvent

EndState

Auto State Ready

	Event OnActivate(ObjectReference akActionRef)
			
		GoToState("Busy")
		Bool DaedricItemCrafted

		If SigilStoneInstalled == True
			DaedricItemCrafted = ScanForRecipes(SigilRecipeList, SigilResultList)
			Utility.Wait(0.1)
		endIf

		If SigilStoneInstalled == False || DaedricItemCrafted == False
			ScanForRecipes(RecipeList, ResultList)
		endIf
		
		GoToState("Ready")
		
	EndEvent

EndState

Bool Function ScanForRecipes(FormList Recipes, FormList Results)

	Int I = 0
	Int T = Recipes.GetSize()
	Bool FoundCombine = False
	Bool Checking = True
		
	While Checking == True && I < T
		FormList CurrentRecipe = (Recipes.GetAt(I)) as FormList
		If CurrentRecipe == None
			;None
		else
			If ScanSubList(CurrentRecipe) == True
				RemoveIngredients(CurrentRecipe)
				FoundCombine = True
				Checking = False
			else
				;Found nothing
			endIf
		endIf
		
		If FoundCombine == False
			;Only increment if we are continuing to loop
			I += 1
		endIf
		
	endWhile

	If FoundCombine == True
		SummonFXPoint.PlaceAtMe(SummonFX)
		Utility.Wait(0.25)
		Form Result = Results.GetAt(I)
		ObjectReference SummonedRef = CreatePoint.PlaceAtMe(Result)
		Float ConjurationCraftXPGold = 2.1*(Result.GetGoldValue()*0.5)
		Float ConjurationCraftXPLevel = 2.1*((Result as Actor).GetLevel()*0.25)
		Game.AdvanceSkill("Conjuration", ConjurationCraftXPGold)
		Game.AdvanceSkill("Conjuration", ConjurationCraftXPLevel)
		If (LastSummonedObject)
			If ((LastSummonedObject as Actor).IsDead())
				LastSummonedObject.RemoveAllItems(DropBox, False, True)
				LastSummonedObject.Disable()
				LastSummonedObject.Delete()
			endIf
		endIf
		
		LastSummonedObject = SummonedRef
		
		If (SummonedRef as Actor) != None
			(SummonedRef as Actor).StartCombat(PlayerRef)
		endIf
		
		Return True
	else
		Return False
	endIf

EndFunction

Bool Function ScanSubList(FormList Recipe)
	
	Int Size = Recipe.GetSize()
	Int CNT = 0
	While CNT < Size
		Form ToCheck = Recipe.GetAt(CNT)
		If DropBox.GetItemCount(ToCheck) < 1
			Return False
		else
			;We have the item in CNT
		endIf
		CNT += 1
	endWhile
	
	Return True
	
EndFunction

Function RemoveIngredients(FormList Recipe)

	Int Size = Recipe.GetSize()
	 Int CNT = 0
	 While CNT < Size
		Form ToCheck = Recipe.GetAt(CNT)
		DropBox.RemoveItem(ToCheck, 1)
		CNT += 1
	endWhile

EndFunction

