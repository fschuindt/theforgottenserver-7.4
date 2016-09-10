local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 2*1000)
condition:setFormula(0, 40, 0, 120)
combat:setCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end