extends Node

class_name TargetFindScript

var teamSize = 4

func select_targets(activePosition, move):
	var tempTargetList = []
	match move.targets:
		move.target_kinds.chooseEnemy:
			if( activePosition < teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
				
		move.target_kinds.chooseFriend:
			if( activePosition >= teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
		move.target_kinds.inFront:
			tempTargetList.append(fmod(activePosition+teamSize, teamSize*2))
		move.target_kinds.adjacentEnemy:
			var mintarget = fmod(activePosition+teamSize, teamSize*2)-1
			if(mintarget < 0):
				mintarget = 0
			if (activePosition < teamSize && mintarget < teamSize):
				mintarget = teamSize
			var maxtarget = fmod(activePosition+teamSize, teamSize*2)+1
			if(maxtarget > teamSize*2):
				maxtarget = teamSize*2 -1
			if (activePosition >= teamSize && maxtarget >= teamSize):
				maxtarget = teamSize-1
			for i in range(mintarget,maxtarget+1):
				tempTargetList.append(i)
		
		move.target_kinds.allEnemy:
			if( activePosition < teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
		move.target_kinds.me:
			tempTargetList.append(activePosition)
			
		move.target_kinds.allTeamOther:
			match activePosition:
				0:
					tempTargetList.append(1)
					tempTargetList.append(2)
					tempTargetList.append(4)
				1:
					tempTargetList.append(0)
					tempTargetList.append(2)
					tempTargetList.append(3)
				2:
					tempTargetList.append(1)
					tempTargetList.append(0)
					tempTargetList.append(3)
				3:
					tempTargetList.append(0)
					tempTargetList.append(1)
					tempTargetList.append(2)
				4:
					tempTargetList.append(5)
					tempTargetList.append(6)
					tempTargetList.append(7)
				5:
					tempTargetList.append(4)
					tempTargetList.append(6)
					tempTargetList.append(7)
				6:
					tempTargetList.append(4)
					tempTargetList.append(5)
					tempTargetList.append(7)
				7:
					tempTargetList.append(4)
					tempTargetList.append(5)
					tempTargetList.append(6)
		move.target_kinds.allTeam:
			if activePosition < teamSize:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
			else:
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
	return tempTargetList


