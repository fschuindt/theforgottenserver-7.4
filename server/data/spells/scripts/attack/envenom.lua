local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)

local condition = createConditionObject(CONDITION_POISON)
setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
--[[
addDamageCondition(condition, 3, 2000, -25)
addDamageCondition(condition, 3, 3000, -5)
addDamageCondition(condition, 4, 4000, -4)
addDamageCondition(condition, 6, 6000, -3)
addDamageCondition(condition, 9, 8000, -2)
addDamageCondition(condition, 12, 10000, -1)
]]--
setConditionParam(condition, CONDITION_PARAM_MINVALUE, 20)
setConditionParam(condition, CONDITION_PARAM_MAXVALUE, 70)
setConditionParam(condition, CONDITION_PARAM_STARTVALUE, 5)
setConditionParam(condition, CONDITION_PARAM_TICKINTERVAL, 6000)
setConditionParam(condition, CONDITION_PARAM_FORCEUPDATE, true)

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