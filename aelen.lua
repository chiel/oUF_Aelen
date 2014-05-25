local _TEXTURE = [[Interface\AddOns\TouchysMedia\statusbars\touchy-white]]

local frameWidth, frameHeight = 288, 26

local colors = setmetatable({
	power = setmetatable({
		['ENERGY'] = { 0.7372549019607844, 0.6862745098039216, 0.3764705882352941 },
		['MANA'] = { 0.2941176470588235, 0.6, 0.8980392156862745 },
		['RAGE'] = { 1, 0.3568627450980392, 0.3098039215686275 },
	}, {__index = oUF.colors.power}),
}, {__index = oUF.colors})

local backdrop = {
	bgFile = "Interface\\AddOns\\TouchysMedia\\backgrounds\\touchy-white",  
	edgeFile = "Interface\\AddOns\\TouchysMedia\\borders\\touchy-white",
	tile = false, tileSize = 4, edgeSize = 1,
	insets = { left = 1, right = 1, top = 1, bottom = 1 }
}

local PowerPostUpdate = function(power, unit, current, max)
	local _, powerType = UnitPowerType(unit)
	local r, g, b = unpack(colors.power.RAGE)

	if current > 39 then
		r, g, b = unpack(colors.power[powerType])
	end

	power:SetStatusBarColor(r, g, b)
end

local _, playerClass = UnitClass('player')

local Player = function(self, unit)

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	self:RegisterForClicks('AnyUp')

	self.colors = colors
	self:SetSize(frameWidth, frameHeight)

	-- health
	local HealthBg = CreateFrame('Frame', 'nil', self)
	HealthBg:SetHeight(17)
	HealthBg:SetBackdrop(backdrop)
	HealthBg:SetBackdropColor(.25, .25, .25, 1)
	HealthBg:SetBackdropBorderColor(0, 0, 0, 1)
	HealthBg:SetPoint('TOPLEFT', 0, 0)
	HealthBg:SetPoint('RIGHT', 0, 0)

	local Health = CreateFrame('StatusBar', nil, HealthBg)
	Health:SetStatusBarTexture(_TEXTURE)
	Health:SetStatusBarColor(.15, .15, .15, 1)
	Health:SetPoint('TOPLEFT', 1, -1)
	Health:SetPoint('BOTTOMRIGHT', -1, 1)
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
	PowerBg:SetPoint('BOTTOMLEFT', 0, 0)
	PowerBg:SetPoint('RIGHT', 0, 0)

	local Power = CreateFrame('StatusBar', nil, PowerBg)
	Power:SetStatusBarTexture(_TEXTURE)
	Power:SetPoint('TOPLEFT', 1, -1)
	Power:SetPoint('BOTTOMRIGHT', -1, 1)
	Power.frequentUpdates = true
	Power.PostUpdate = PowerPostUpdate
	self.Power = Power

	if playerClass == 'MONK' then
		local ClassIcons = {}
		local IconFrame = CreateFrame('Frame', nil, self)
		IconFrame:SetHeight(5)
		IconFrame:SetPoint('BOTTOMLEFT', 0, -8)
		IconFrame:SetPoint('RIGHT', 0, 0)

		local width = 48
		for index = 1, 5 do
			local IconBg = CreateFrame('Frame', nil, IconFrame)
			IconBg:SetBackdrop(backdrop)
			IconBg:SetBackdropColor(.25, .25, .25, 1)
			IconBg:SetBackdropBorderColor(0, 0, 0, 1)
			IconBg:SetPoint('TOPLEFT', (index - 1) * (width + 12), 0)
			IconBg:SetPoint('BOTTOM', 0, 0)
			IconBg:SetWidth(width)

			local Icon = IconBg:CreateTexture()
			Icon:SetTexture(_TEXTURE)
			Icon:SetVertexColor(1, 0, 0)
			Icon:SetPoint('TOPLEFT', 1, -1)
			Icon:SetPoint('BOTTOMRIGHT', -1, 1)
			ClassIcons[index] = Icon
		end
		self.ClassIcons = ClassIcons

		-- stagger
		local StaggerBg = CreateFrame('Frame', nil, self)
		StaggerBg:SetHeight(5)
		StaggerBg:SetBackdrop(backdrop)
		StaggerBg:SetBackdropColor(.25, .25, .25, 1)
		StaggerBg:SetBackdropBorderColor(0, 0, 0, 1)
		StaggerBg:SetPoint('TOPLEFT', 12, 1.5)
		StaggerBg:SetPoint('RIGHT', -12, 0)
		StaggerBg:SetFrameStrata('HIGH')
		StaggerBg:Hide()
		StaggerBg:RegisterEvent('PLAYER_REGEN_DISABLED')
		StaggerBg:RegisterEvent('PLAYER_REGEN_ENABLED')
		StaggerBg:SetScript('OnEvent', function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				self:Show()
			elseif event == 'PLAYER_REGEN_ENABLED' then
				self:Hide()
			end
		end)

		local Stagger = CreateFrame('StatusBar', nil, StaggerBg)
		Stagger:SetStatusBarTexture(_TEXTURE)
		Stagger:SetPoint('TOPLEFT', 1, -1)
		Stagger:SetPoint('BOTTOMRIGHT', -1, 1)
		self.Stagger = Stagger
	end
end

oUF:RegisterStyle('Classic', Player)

oUF:Factory(function(self)
	self:SetActiveStyle('Classic')
	local player = self:Spawn('player')
	player:SetPoint('CENTER', 0, -400.5)
	player:SetAlpha(.3)

	local EventFrame = CreateFrame('Frame')
	EventFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
	EventFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
	EventFrame:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_REGEN_DISABLED' then
			player:SetPoint('CENTER', 0, -200.5)
			player:SetAlpha(1)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			player:SetPoint('CENTER', 0, -400.5)
			player:SetAlpha(.3)
		end
	end)
end)
