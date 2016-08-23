function onUse(player, item, fromPosition, target, toPosition)
	local count = getPlayerInstantSpellCount(player)
	local text = ""
	local spells = {}
	for i = 0, count - 1 do
		local spell = getPlayerInstantSpellInfo(player, i)
		if spell.mlevel ~= (nil) and spell.mana > 0 then
			if spell.manapercent > 0 then
				spell.mana = spell.manapercent .. "%"
			end
			spells[#spells + 1] = spell
		end
	end

	table.sort(spells, function(a, b) return a.mlevel < b.mlevel end)

	local prevLevel = -1
	for i, spell in ipairs(spells) do
		local line = ""
		if prevLevel ~= spell.mlevel then
			if i ~= 1 then
				line = "\n"
			end
			line = line .. spell.mlevel .. ". Level Spells \n"
			prevLevel = spell.mlevel
		end
		text = text .. line .. "   " .. spell.words .. " - " .. spell.name .. " : " .. spell.mana .. "\n"
	end

	player:showTextDialog(item:getId(), text)
	return true
end