local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)

local condition = createConditionObject(CONDITION_FIRE)
setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
addDamageCondition(condition, 3, 10000, -10)
addDamageCondition(condition, 10, 10000, -5)
setCombatCondition(combat, condition)

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