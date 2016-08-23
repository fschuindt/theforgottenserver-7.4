local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_BLOCKARMOR, true)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)

local area = createCombatArea(AREA_CROSS1X1)
setCombatArea(combat, area)

function onGetFormulaValues(cid, level, maglevel)
	min = 0
	max = -((level * 2) + (maglevel * 3)) * 1
--	min = -((level * 2) + (maglevel * 3)) * 0.15
--	max = -((level * 2) + (maglevel * 3)) * 0.9
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var, isHotkey)
	-- check for stairHop delay
	if not getCreatureCondition(cid, CONDITION_PACIFIED) then
		return doCombat(cid, combat, var)
	else
		cid:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
		cid:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
end
