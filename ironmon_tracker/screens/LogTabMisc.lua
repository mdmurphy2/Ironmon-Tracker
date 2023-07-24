LogTabMisc = {
	TitleResourceKey = "HeaderTabTrainers", -- Usage: Resources.LogOverlay[TitleResourceKey]
	Colors = {
		text = "Default text",
		border = "Upper box border",
		boxFill = "Upper box background",
		hightlight = "Intermediate text",
	}
}

local columnOffsetX = 100
LogTabMisc.Buttons = {
	PokemonGame = {
		type = Constants.ButtonTypes.NO_BORDER,
		getText = function(self) return Resources.LogOverlay.LabelPokemonGame .. ":" end,
		getValue = function(self) return RandomizerLog.Data.Settings.Game or Constants.BLANKLINE end,
		index = 1,
		box = { LogOverlay.margin + 3, LogOverlay.margin + 3, 100, 11 },
		draw = function(self, shadowcolor)
			Drawing.drawText(self.box[1] + columnOffsetX, self.box[2], self:getValue(), Theme.COLORS[self.textColor], shadowcolor)
		end,
	},
	RandomizerVersion = {
		type = Constants.ButtonTypes.NO_BORDER,
		getText = function(self) return Resources.LogOverlay.LabelRandomizerVersion .. ":" end,
		getValue = function(self) return RandomizerLog.Data.Settings.Version or Constants.BLANKLINE end,
		index = 2,
		box = { LogOverlay.margin + 3, LogOverlay.margin + 17, 100, 11 },
		draw = function(self, shadowcolor)
			Drawing.drawText(self.box[1] + columnOffsetX, self.box[2], self:getValue(), Theme.COLORS[self.textColor], shadowcolor)
		end,
	},
	RandomSeed = {
		type = Constants.ButtonTypes.NO_BORDER,
		getText = function(self) return Resources.LogOverlay.LabelRandomSeed .. ":" end,
		getValue = function(self) return RandomizerLog.Data.Settings.RandomSeed or Constants.BLANKLINE end,
		index = 3,
		box = { LogOverlay.margin + 3, LogOverlay.margin + 31, 100, 11 },
		draw = function(self, shadowcolor)
			Drawing.drawText(self.box[1] + columnOffsetX, self.box[2], self:getValue(), Theme.COLORS[self.textColor], shadowcolor)
		end,
	},
	SettingsString = {
		type = Constants.ButtonTypes.NO_BORDER,
		getText = function(self) return Resources.LogOverlay.LabelSettingsString .. ":" end,
		getValue = function(self) return RandomizerLog.Data.Settings.SettingsString or Constants.BLANKLINE end,
		index = 4,
		box = { LogOverlay.margin + 3, LogOverlay.margin + 45, 100, 11 },
		draw = function(self, shadowcolor)
			local settingsString = self:getValue()
			local offsetY = self.box[2] + Constants.SCREEN.LINESPACING
			for i = 1, 999, 38 do
				local settingsSegment = settingsString:sub(i, i + 37)
				if settingsSegment == "" then
					break
				end
				Drawing.drawText(self.box[1] + 8, offsetY, settingsSegment, Theme.COLORS[self.textColor], shadowcolor)
				offsetY = offsetY + Constants.SCREEN.LINESPACING
			end
		end,
	},
	ShareRandomizer = {
		type = Constants.ButtonTypes.FULL_BORDER,
		getText = function(self) return Resources.LogOverlay.ButtonShareSeed end,
		box = { Constants.SCREEN.WIDTH - LogOverlay.margin - 55, LogOverlay.tabHeight + 16, 50, 11 },
		onClick = function(self) LogTabMisc.openRandomizerShareWindow() end,
	},
	PreEvoSettingButton = {
		type = Constants.ButtonTypes.CHECKBOX,
		optionKey = "Show Pre Evolutions",
		getText = function(self) return Resources.LogOverlay.CheckboxShowPreEvolutions end,
		clickableArea = { LogOverlay.margin + 4, 120, 100, Constants.Font.SIZE, },
		box = { LogOverlay.margin + 4, 120, Constants.Font.SIZE - 1, Constants.Font.SIZE - 1, },
		toggleState = Options["Show Pre Evolutions"],
		updateSelf = function(self) self.toggleState = (Options[self.optionKey] == true) end,
		onClick = function(self)
			self.toggleState = Options.toggleSetting(self.optionKey)
			Program.redraw(true)
		end,
	},
}

function LogTabMisc.initialize()
	for _, button in pairs(LogTabMisc.Buttons) do
		if button.textColor == nil then
			button.textColor = LogTabMisc.Colors.text
		end
		if button.boxColors == nil then
			button.boxColors = { LogTabMisc.Colors.border, LogTabMisc.Colors.boxFill }
		end
	end

	LogTabMisc.refreshButtons()
end

function LogTabMisc.refreshButtons()
	for _, button in pairs(LogTabMisc.Buttons) do
		if type(button.updateSelf) == "function" then
			button:updateSelf()
		end
	end
end

function LogTabMisc.openRandomizerShareWindow()
	local form = Utils.createBizhawkForm(Resources.LogOverlay.PromptShareSeedTitle, 515, 235)

	local newline = "\r\n"

	local shareExport = {}
	for _, button in ipairs(Utils.getSortedList(LogTabMisc.Buttons)) do
		local infoString = string.format("%s %s", button:getText(), button:getValue())
		if button == LogTabMisc.Buttons.SettingsString then
			infoString = newline .. infoString
		end
		table.insert(shareExport, infoString)
	end

	forms.label(form, Resources.LogOverlay.PromptShareSeedDesc, 9, 10, 495, 20)
	forms.textbox(form, table.concat(shareExport, " " .. newline), 480, 120, nil, 10, 35, true, false, "Vertical")
	forms.button(form, Resources.AllScreens.Close, function()
		forms.destroy(form)
	end, 212, 165)
end

-- USER INPUT FUNCTIONS
function LogTabMisc.checkInput(xmouse, ymouse)
	Input.checkButtonsClicked(xmouse, ymouse, LogTabMisc.Buttons)
end

-- Unsure if this will actually be needed, likely some of them
function LogTabMisc.drawTab()
	local borderColor = Theme.COLORS[LogTabMisc.Colors.border]
	local fillColor = Theme.COLORS[LogTabMisc.Colors.boxFill]
	local shadowcolor = Utils.calcShadowColor(fillColor)

	-- Draw the Tab viewbox
	gui.defaultTextBackground(fillColor)
	gui.drawRectangle(LogOverlay.TabBox.x, LogOverlay.TabBox.y, LogOverlay.TabBox.width, LogOverlay.TabBox.height, borderColor, fillColor)

	-- Draw all buttons
	for _, button in pairs(LogTabMisc.Buttons) do
		Drawing.drawButton(button, shadowcolor)
	end
end
