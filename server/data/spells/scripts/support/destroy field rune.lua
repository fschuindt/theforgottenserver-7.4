function onCastSpell(creature, var)
	local position = variantToPosition(var)
	local tile = Tile(position)
	local field = tile and tile:getItemByType(ITEM_TYPE_MAGICFIELD)
	local removed = field ~= nil and isInArray(FIELDS, field:getId())
	
	while field and isInArray(FIELDS, field:getId()) do
		field:remove()
		field = tile:getItemByType(ITEM_TYPE_MAGICFIELD)
	end

	if removed then
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end
