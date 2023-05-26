local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)

--[=[
	@class KnitUtil

	A module that contains useful functions for projects that use [Knit](https://sleitnick.github.io/Knit/).
]=]
local KnitUtil = {}

function KnitUtil:_getComponentsTable()
	local tabl = Knit.components or Knit.Components
	if tabl == nil then
		Knit.components = {}
		return Knit.components
	end
	return tabl
end

--[=[
	Requires all children of the provided Instance.

	@param container Instance -- The folder containing the Components
	@return table {Component}

	```lua
	-- Require the module
	local KnitUtil = require(somewhere.KnitUtil)

	-- Locate components folder
	local componentsFolder = ReplicatedStorage.Client.Components

	-- Load all of the components
	local components = KnitUtil.LoadComponents(componentsFolder)
	```
]=]
function KnitUtil.LoadComponents(container: Instance)
	Knit.components = Knit.components or {}

	local components = KnitUtil:_getComponentsTable()

    for _, v in pairs (container:GetChildren()) do
		if v:IsA("ModuleScript") then
			print("Loading component", v)

			local component = require(v)

			table.insert(components, component)
			Knit.components[component.Tag or v.Name] = component

			print("\tLoaded component", v)
		end
    end

	return components
end

--[=[
	Searches all the Instance's components for a specific method.

	@param instance Instance -- The Instance to search
	@param methodName string -- The name of the method to look for
	@return method function? -- The method that was found
	@return component Component? -- The component instance the method belongs to 

	### Writing cleaner code with MethodFromInstance

	Let's say we have two components: a door and a light switch. We want to write a script to interact with these objects and any new ones we may come up with in the future:

	#### Door Component
	```lua
	local Door = Component.new {
		Tag = "Door"
	}

	function Door:_open()
		print("Door open")
		self.isOpen = true
	end

	function Door:_close()
		print("Door closed")
		self.isOpen = false
	end

	function Door:OnInteract(open: boolean)
		if open then
			if self.isOpen then
				self:_close()
			else
				self:_open()
			end
		end
	end

	function Door:Construct()
		self.isOpen = false
	end
	```

	#### Light Switch Component
	```lua
	local LightSwitch = Component.new {
		Tag = "LightSwitch"
	}

	function LightSwitch:_turnOn()
		print("Light on")
		self.isOn = true
	end

	function LightSwitch:_turnOff()
		print("Light off")
		self.isOn = false
	end

	function LightSwitch:OnInteract(on: boolean)
		if on then
			if self.isOn then
				self:_turnOff()
			else
				self:_turnOn()
			end
		end
	end

	function LightSwitch:Construct()
		self.isOn = false
	end
	```

	#### Interaction Script (without MethodFromInstance)

	Without `MethodFromInstance`, we might write some interaction code like this:
	```lua
	-- Require components we can interact with
	local DoorComponent = require(somewhere.Components.DoorComponent)
	local LightSwitchComponent = require(somewhere.Components.LightSwitch)

	local function InteractWith(instance: Instance)
		-- Scan through the Instance's components for an 'OnInteract' method
		if CollectionService:HasTag(instance, "Door") then
			DoorComponent:FromInstance(instance):OnInteract(true)
		elseif CollectionService:HasTag(instance, "LightSwitch") then
			LightSwitchComponent:FromInstance(instance):OnInteract(true)
		else if ....... then
			-- etc etc etc
			.....
		end
	end

	-- Open the door
	InteractWith(workspace.Door)
	-- Flick the light switch to on
	InteractWith(workspace.LightSwitch)
	```

	#### Final Result (using MethodFromInstance)

	This code is bad because it will get messy as we add more types of Components to our game.

	However, if we instead use `MethodFromInstance` we don't need to modify the code every time we create a new component.

	Below is an example that implements `MethodFromInstance`:
	```lua
	local function InteractWith(instance: Instance)
		-- Scan through the Instance's components for an 'OnInteract' method
		local onInteract = KnitUtil.MethodFromInstance(instance, "OnInteract")

		if onInteract then
			-- Call the method
			onInteract(true)
		end
	end

	-- Open the door
	InteractWith(workspace.Door)
	-- Flick the light switch to on
	InteractWith(workspace.LightSwitch)
	```
]=]
function KnitUtil.MethodFromInstance(instance: Instance, methodName: string)
	local components = KnitUtil:_getComponentsTable()

	for _, tag in pairs (CollectionService:GetTags(instance)) do
		local componentBase = components[tag]		
		if not componentBase then
			continue
		end
		
		local component = componentBase:FromInstance(instance)		
		if not component then
			continue
		end
		
		local value = component[methodName]
		if value and typeof(value) == "function" then
			return function(...)
				return component[methodName](component, ...)
			end, component
		end
	end
end

--[=[
	Similar to `MethodFromInstance`, but for non-methods.

	@param instance Instance -- The Instance to search
	@param variableName string -- The variable to look for
	@return variable any -- The variable that was found
	@return component Component? -- The component instance the method belongs to 

	```lua
	local function GetHealth(enemy: Instance)
		local health: number? = KnitUtil.VariableFromInstance(enemy, "MyHealth")
		return health
	end

	print(GetHealth(workspace.Zombie))
	print(GetHealth(workspace.Player))
	print(GetHealth(workspace.DestructableBox))
	```
]=]
function KnitUtil.VariableFromInstance(instance: Instance, variableName: string)
	local components = KnitUtil:_getComponentsTable()

	for _, tag in pairs (CollectionService:GetTags(instance)) do
		local componentBase = components[tag]		
		if not componentBase then
			continue
		end
		
		local component = componentBase:FromInstance(instance)		
		if not component then
			continue
		end

		local variable = component[variableName]
		if variable then
			return variable, component
		end
	end
end

return KnitUtil