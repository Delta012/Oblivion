Scriptname OBL_SkeletalDragonSummonScript extends Actor

Actor Property PlayerRef Auto

MiscObject Property DragonBone Auto

Event OnLoad()

	PlayerRef.RemoveItem(DragonBone, 5)

EndEvent