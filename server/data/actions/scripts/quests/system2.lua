local config = {
--	[2285] = {
--		items = {
--			{itemId = 2356}
--		},
--		storage = Storage.DjinnWar.EfreetFaction.Mission03,
--		formerValue = 1,
--		newValue = 2,
--		needItem = {itemId = 2344},
--		effect = CONST_ME_MAGIC_BLUE
--	},
--	[2286] = {
--		items = {
--			{itemId = 2318}
--		},
--		storage = Storage.QuestChests.FamilyBrooch
--	},
--	[3002] = {
--		items = {
--			{itemId = 2147, count = 6}
--		},
--		storage = Storage.QuestChests.SixRubiesQuest
--	}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	if (useItem.time and player:getStorageValue(useItem.storage) > os.time())
			or player:getStorageValue(useItem.storage) ~= (useItem.formerValue or -1) then
		player:sendTextMessage(MESSAGE_INFO_DESCR, 'The ' .. ItemType(item.itemid):getName() .. ' is empty.')
		return true
	end

	if useItem.needItem then
		if player:getItemCount(useItem.needItem.itemId) < (useItem.needItem.count or 1) then
			return false
		end
	end

	local items, reward = useItem.items
	local size = #items
	if size == 1 then
		reward = Game.createItem(items[1].itemId, items[1].count or 1)
	end

	local result = ''
	if reward then
		local ret = ItemType(reward.itemid)
		if ret:isRune() then
			result = ret:getArticle() .. ' ' ..  ret:getName() .. ' (' .. reward.type .. ' charges)'
		elseif reward:getCount() > 1 then
			result = reward:getCount() .. ' ' .. ret:getPluralName()
		elseif ret:getArticle() ~= '' then
			result = ret:getArticle() .. ' ' .. ret:getName()
		else
			result = ret:getName()
		end

		if items[1].actionId then
			reward:setActionId(items[1].actionId)
		end

		if items[1].text then
			reward:setText(items[1].text)
		end

		if items[1].decay then
			reward:decay()
		end

	else
		if size > 8 then
			reward = Game.createItem(1988, 1)
		else
			reward = Game.createItem(1987, 1)
		end

		for i = 1, size do
			local tmp = Game.createItem(items[i].itemId, items[i].count or 1)
			if reward:addItemEx(tmp) ~= RETURNVALUE_NOERROR then
				print('[Warning] QuestSystem:', 'Could not add quest reward to container')
			else
				if items[i].actionId then
					tmp:setActionId(items[i].actionId)
				end

				if items[i].text then
					tmp:setText(items[i].text)
				end

				if items[i].decay then
					tmp:decay()
				end

			end
		end
		local ret = ItemType(reward.itemid)
		result = ret:getArticle() .. ' ' .. ret:getName()
	end

	if player:addItemEx(reward) ~= RETURNVALUE_NOERROR then
		local weight = reward:getWeight()
		if player:getFreeCapacity() < weight then
			player:sendCancelMessage('You have found ' .. result .. '. Weighing ' .. string.format('%.2f', (weight / 100)) .. ' oz, it is too heavy.')
		else
			player:sendCancelMessage('You have found ' .. result .. ', but you have no room to take it.')
		end
		return true
	end

	if useItem.say then
		player:say(useItem.say, TALKTYPE_MONSTER_SAY)
	end

	if useItem.needItem then
		player:removeItem(useItem.needItem.itemId, useItem.needItem.count or 1)
	end

	if useItem.effect then
		toPosition:sendMagicEffect(useItem.effect)
	end

	if useItem.missionStorage then
		player:setStorageValue(useItem.missionStorage.key, useItem.missionStorage.value)
	end

	player:sendTextMessage(MESSAGE_INFO_DESCR, 'You have found ' .. result .. '.')
	if useItem.time then
		player:setStorageValue(useItem.storage, os.time() + 86400)
	else
		player:setStorageValue(useItem.storage, useItem.newValue or 1)
	end
	return true
end
