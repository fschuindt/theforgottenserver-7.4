local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)

function onGetFormulaValues(cid, level, maglevel)
	min = -((level * 2) + (maglevel * 3)) * 0.2
	max = -((level * 2) + (maglevel * 3)) * 0.4
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var, isHotkey)
	-- check for stairHop delay
	if not getCreatureCondition(cid, CONDITION_PACIFIED) then
		-- check making it able to shot invisible creatures
		if Tile(var:getPosition()):getTopCreature() then
			return doCombat(cid, combat, var)
		else
			cid:sendCancelMessage("You can only use this rune on creatures.")
			cid:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	else
		-- attack players even with stairhop delay
		if Tile(var:getPosition()):getTopCreature() then
			if Tile(var:getPosition()):getTopCreature():isPlayer() then
				return doCombat(cid, combat, var)
			else
				cid:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
				cid:getPosition():sendMagicEffect(CONST_ME_POFF)
				return false
			end
		else
			cid:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
			cid:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end
end
