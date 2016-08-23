local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatParam(combat, COMBAT_PARAM_DISPEL, CONDITION_POISON)

function onCastSpell(cid, var, isHotkey)
	if Tile(var:getPosition()):getTopCreature() then
		return doCombat(cid, combat, var)
	else
		cid:sendCancelMessage("You can only use this rune on creatures.")
		cid:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
end
