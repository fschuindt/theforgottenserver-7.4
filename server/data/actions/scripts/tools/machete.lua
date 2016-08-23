local JUNGLE_GRASS = { 2782, 3985 }
local WILD_GROWTH = { 1499 }

function onUse(player, item, fromPosition, target, toPosition)
	local targetId = target.itemid
	if isInArray(JUNGLE_GRASS, targetId) then
		target:transform(target.itemid-1)
		target:decay()
		return true
	end
	if isInArray(WILD_GROWTH, targetId) then
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end
	return destroyItem(player, target, toPosition)
end