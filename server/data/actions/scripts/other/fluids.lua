local drunk = Condition(CONDITION_DRUNK)
drunk:setParameter(CONDITION_PARAM_TICKS, 60000)

local poison = Condition(CONDITION_POISON)
poison:setParameter(CONDITION_PARAM_DELAYED, true)
poison:setParameter(CONDITION_PARAM_MINVALUE, -50)
poison:setParameter(CONDITION_PARAM_MAXVALUE, -120)
poison:setParameter(CONDITION_PARAM_STARTVALUE, -5)
poison:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
poison:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local fluidType = {3, 4, 5, 7, 10, 11, 13, 15, 19}
local fluidMessage = {"Aah...", "Urgh!", "Mmmh.", "Aaaah...", "Aaaah...", "Urgh!", "Urgh!", "Aah...", "Urgh!"}

function onUse(player, item, fromPosition, target, toPosition)

	local targetItemType = ItemType(target.itemid)
	if targetItemType and targetItemType:isFluidContainer() then
		if target.type == 0 and item.type ~= 0 then
			target:transform(target:getId(), item.type)
			item:transform(item:getId(), 0)
			return true
		elseif target.type ~= 0 and item.type == 0 then
			target:transform(target:getId(), 0)
			item:transform(item:getId(), target.type)
			return true
		end
	end
    local v = item.type
	if target:isCreature() then
		if v == 0 then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "It is empty.")
		elseif target == player then
			item:transform(item:getId(), 0)
			if v == 3 or v == 15 then
				player:addCondition(drunk)
			elseif v == 4 then
				player:addCondition(poison)
			elseif v == 7 then
				player:addMana(math.random(20, 75))
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			elseif v == 10 then
				player:addHealth(60)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			for i = 0, #fluidType do
				if v == fluidType[i] then
					player:say(fluidMessage[i], 1)
					return true
				end
			end
			player:say("Gulp.", 1)
		else
			Game.createItem(2016, v, toPosition):decay()
			item:transform(item:getId(), 0)
		end
	else
		local fluidSource = targetItemType and targetItemType:getFluidSource() or 0
		if fluidSource ~= 0 then
			item:transform(item:getId(), fluidSource)
		elseif v == 0 then
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "It is empty.")
		else
			if toPosition.x == CONTAINER_POSITION then
				toPosition = player:getPosition()
			end
			Game.createItem(2016, v, toPosition):decay()
			item:transform(item:getId(), 0)
		end
	end
	return true
end
