--ドドドセカンド Dododo Second
local s,id=GetID()
function s.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.fupfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_SPIRIT_STADIUM)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.fupfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--cost
	Duel.PayLPCost(tp,500)
	--effect
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=s.summonproc(c,true,true,1,1,SUMMON_TYPE_TRIBUTE,aux.Stringid(id,0),s.otfilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(s.eftg)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function s.summonproc(c,ns,opt,min,max,val,desc,f,sumop)
	val = val or SUMMON_TYPE_TRIBUTE
	local e1=Effect.CreateEffect(c)
	if desc then e1:SetDescription(desc) end
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	if ns and opt then
		e1:SetCode(EFFECT_SUMMON_PROC)
	else
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	end
	if ns then
		e1:SetCondition(Auxiliary.NormalSummonCondition1(min,max,f))
		e1:SetTarget(Auxiliary.NormalSummonTarget(min,max,f))
		e1:SetOperation(Auxiliary.NormalSummonOperation(min,max,sumop))
	else
		e1:SetCondition(Auxiliary.NormalSummonCondition2())
	end
	e1:SetValue(val)
	return e1
end
function s.otfilter(c,tp)
	return c:GetFlagEffect(id)~=0 and (c:IsControler(tp) or c:IsFaceup())
end
function s.eftg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(7) and c:IsSummonableCard()
end
