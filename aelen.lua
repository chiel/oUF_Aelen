local _TEXTURE = [[Interface\AddOns\TouchysMedia\statusbars\touchy-white]]

local colors = setmetatable({
	power = setmetatable({
		['RAGE'] = {0.62745098039, 0.11764705882, 0.11764705882},
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

local backdrop = {
	bgFile = "Interface\\AddOns\\TouchysMedia\\backgrounds\\touchy-white",  
	edgeFile = "Interface\\AddOns\\TouchysMedia\\borders\\touchy-white",
	tile = false, tileSize = 4, edgeSize = 1,
	insets = { left = 1, right = 1, top = 1, bottom = 1 }
}

local Player = function(self, unit)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self.colors = colors
	self:SetSize(214, 26)

	local classDisplayName, class, classID = UnitClass('player')
	print(classDisplayName, class, classID)
	print(colors)

	-- health
	local HealthBg = CreateFrame('Frame', 'nil', self)
	HealthBg:SetHeight(17)
	HealthBg:SetBackdrop(backdrop)
	HealthBg:SetBackdropColor(.25, .25, .25, 1)
	HealthBg:SetBackdropBorderColor(0, 0, 0, 1)
	HealthBg:SetPoint('TOP', 0, 0)
	HealthBg:SetPoint('LEFT', 0, 0)
	HealthBg:SetPoint('RIGHT', 0, 0)

	local Health = CreateFrame('StatusBar', nil, HealthBg)
	Health:SetStatusBarTexture(_TEXTURE)
	Health:SetStatusBarColor(.15, .15, .15, 1)
	Health:SetPoint('TOP', 0, -1)
	Health:SetPoint('LEFT', 1, 0)
	Health:SetPoint('RIGHT', -1, 0)
	Health:SetPoint('BOTTOM', 0, 1)
	Health.frequentUpdates = true
	Health.colorDisconnected = true
	Health.colorTapping = true
	self.Health = Health

	-- power
	local PowerBg = CreateFrame('Frame', 'nil', self)
	PowerBg:SetHeight(5)
	PowerBg:SetBackdrop(backdrop)
	PowerBg:SetBackdropColor(.25, .25, .25, 1)
	PowerBg:SetBackdropBorderColor(0, 0, 0, 1)
	PowerBg:SetPoint('TOP', 0, -21)
	PowerBg:SetPoint('LEFT', 0, 0)
	PowerBg:SetPoint('RIGHT', 0, 0)

	local Power = CreateFrame('StatusBar', nil, PowerBg)
	Power:SetStatusBarTexture(_TEXTURE)
	Power:SetPoint('TOP', 0, -1)
	Power:SetPoint('LEFT', 1, 0)
	Power:SetPoint('RIGHT', -1, 0)
	Power:SetPoint('BOTTOM', 0, 1)
	Power.colorPower = true
	Power.frequentUpdates = true
	self.Power = Power
end

oUF:RegisterStyle('Classic', Player)

oUF:Factory(function(self)
	self:SetActiveStyle('Classic')
	local player = self:Spawn('player')
	player:SetPoint('CENTER', 0, -300.5)
end)
