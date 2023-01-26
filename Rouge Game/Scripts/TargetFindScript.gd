extends Node

class_name TargetFindScript

var team_size = 4

func select_targets(active_position, move):
	var tmp_target_list = []
	match move.targets:
		move.target_kinds.choose_enemy:
			if( active_position < team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
				
		move.target_kinds.choose_friend:
			if( active_position >= team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
		move.target_kinds.in_front:
			tmp_target_list.append(fmod(active_position+team_size, team_size*2))
		move.target_kinds.adjacent_enemy:
			var min_target = fmod(active_position+team_size, team_size*2)-1
			if(min_target < 0):
				min_target = 0
			if (active_position < team_size && min_target < team_size):
				min_target = team_size
			var max_target = fmod(active_position+team_size, team_size*2)+1
			if(max_target > team_size*2):
				max_target = team_size*2 -1
			if (active_position >= team_size && max_target >= team_size):
				max_target = team_size-1
			for i in range(min_target,max_target+1):
				tmp_target_list.append(i)
		
		move.target_kinds.all_enemy:
			if( active_position < team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
		move.target_kinds.me:
			tmp_target_list.append(active_position)
			
		move.target_kinds.all_team_other:
			match active_position:
				0:
					tmp_target_list.append(1)
					tmp_target_list.append(2)
					tmp_target_list.append(4)
				1:
					tmp_target_list.append(0)
					tmp_target_list.append(2)
					tmp_target_list.append(3)
				2:
					tmp_target_list.append(1)
					tmp_target_list.append(0)
					tmp_target_list.append(3)
				3:
					tmp_target_list.append(0)
					tmp_target_list.append(1)
					tmp_target_list.append(2)
				4:
					tmp_target_list.append(5)
					tmp_target_list.append(6)
					tmp_target_list.append(7)
				5:
					tmp_target_list.append(4)
					tmp_target_list.append(6)
					tmp_target_list.append(7)
				6:
					tmp_target_list.append(4)
					tmp_target_list.append(5)
					tmp_target_list.append(7)
				7:
					tmp_target_list.append(4)
					tmp_target_list.append(5)
					tmp_target_list.append(6)
		move.target_kinds.all_team:
			if active_position < team_size:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
			else:
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
	return tmp_target_list
