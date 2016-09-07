local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)

local area = createCombatArea(AREA_BEAM5, AREADIAGONAL_BEAM5)
setCombatArea(combat, area)

function onGetFormulaValues(cid, level, maglevel)
	min = -((level * 2) + (maglevel * 3)) * 0.68
	max = -((level * 2) + (maglevel * 3)) * 1.3
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var)
	-- check for stairHop delay
	if not getCreatureCondition(cid, CONDITION_PACIFIED) then
		return doCombat(cid, combat, var)
	else
		cid:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
		cid:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
end
