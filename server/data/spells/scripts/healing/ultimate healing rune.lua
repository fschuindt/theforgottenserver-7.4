local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HEALING)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatParam(combat, COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
setCombatParam(combat, COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(cid, level, maglevel)
	if (((level * 2) + (maglevel * 3)) * 2) < 250 then
		min = 250
	else
		min = ((level * 2) + (maglevel * 3)) * 2
	end
	if (((level * 2) + (maglevel * 3)) * 2.8) < 250 then
		max = 250
	else
		max = ((level * 2) + (maglevel * 3)) * 2.8
	end
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var, isHotkey)
	if Tile(var:getPosition()):getTopCreature() then
		return doCombat(cid, combat, var)
	else
		cid:sendCancelMessage("You can only use this rune on creatures.")
		cid:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
end
