local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 15*1000)
condition:setFormula(0, -80, 0, -240)
combat:setCondition(condition)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

function onCastSpell(creature, var)
	if not combat:execute(creature, var) then
		return false
	end

	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end