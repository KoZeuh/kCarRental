                                            --------------------------------
                                           ---COPYRIGHT © 2020 ~ KoZeuh#9070---
                                            --------------------------------

kLocVisible, BlipActif, Logo = false, false, "~g~$"

ActiverBlip = true -- false si vous ne voulez pas les Blips sur la carte
ActiverMarker = true -- false si vous ne voulez pas les Markers aux sols
ActiverPNJ = true -- false si vous ne voulez pas de PNJ sur le lieu de location

ESX = nil

ListePrix = {
    [1] = "30",
    [2] = "50"
}

OptionsPNJ = {
    [1] = {
        ["InfosPNJ"] = {
            ["x"] = -990.68, ['y'] = -2708.31, ['z'] = 12.83, ['h'] = 333.80, -- Coordonnées du ped
            ["modelHash"] = "a_m_m_bevhills_02" -- son model, liste trouvable sur https://docs.fivem.net/docs/game-references/ped-models/
        }
    },
    [2] = {
        ["InfosPNJ"] = {
            ["x"] = 1998.31, ['y'] = 3051.77, ['z'] = 46.21, ['h'] = 336.422,
            ["modelHash"] = "a_m_m_bevhills_02"
        },
    },
    [3] = {
        ["InfosPNJ"] = {
            ["x"] = -347.20, ['y'] = -874.98, ['z'] = 30.08, ['h'] = 259.04,
            ["modelHash"] = "a_m_m_bevhills_02"
        },
    }
}

RMenu.Add('kLocation', 'main', RageUI.CreateMenu("Location", "~b~Location de véhicule", nil, nil, "commonmenu", "gradient_bgd"))

Citizen.CreateThread(function()
    PosLocation = { 
	{x = -990.24, y = -2707.30, z = 13.83},
	{x = 1999.00, y = 3053.76, z = 47.05},
        {x = -344.04, y = -875.49, z = 31.07}
	}
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
	
  while true do
      RageUI.IsVisible(RMenu:Get('kLocation', 'main'), true, true, true, function()
        RageUI.Button("Location d'un scooter", "", {RightLabel = ListePrix[1].. "" ..Logo }, true, function(Hovered, Active, Selected)
            if (Selected) then
                SpawnVehicule("faggio")
                TriggerServerEvent('kLocation:PaiementFaggio')
            end
        end)

        RageUI.Button("Location d'une voiture", "", {RightLabel = ListePrix[2].. "" ..Logo }, true, function(Hovered, Active, Selected)
            if (Selected) then
                SpawnVehicule("panto")
                TriggerServerEvent('kLocation:PaiementPanto')          
            end
        end)

      end, function()
      end, 1)
        Citizen.Wait(0)
      end
  end)

function SpawnVehicule(choixvehicule)
	local ModelVehicule = GetHashKey(choixvehicule)
	RequestModel(ModelVehicule)
		while not HasModelLoaded(ModelVehicule) do
			RequestModel(ModelVehicule)
			Citizen.Wait(0)
		end
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
	local SpawnVehicule = CreateVehicle(ModelVehicule, x  , y  , z , 0.0, true, false)
	SetVehicleNumberPlateText(SpawnVehicule, " kLoca ")
	TaskWarpPedIntoVehicle(GetPlayerPed(-1),SpawnVehicule,-1)
end

Citizen.CreateThread(function()
	while true do
           Citizen.Wait(0)
         if ActiverBlip then
           if not BlipActif then
		for _, PosBlips in pairs(PosLocation) do
		  InfosBlips = AddBlipForCoord(PosBlips.x, PosBlips.y, PosBlips.z)
      		  SetBlipSprite(InfosBlips, 280)
      		  SetBlipDisplay(InfosBlips, 4)
      		  SetBlipScale(InfosBlips, 0.8)
      		  SetBlipColour(InfosBlips, 2)
      		  SetBlipAsShortRange(InfosBlips, true)
	  	  BeginTextCommandSetBlipName("STRING")
      		  AddTextComponentString("kLocation")
                  EndTextCommandSetBlipName(InfosBlips)
                  BlipActif = true         
                end
           else
           end
         end
	end
end)

Citizen.CreateThread(function()
   while true do
        Citizen.Wait(0)
      if ActiverMarker then
	for _, PositionLocation in pairs(PosLocation) do
	       DrawMarker(36, PositionLocation.x, PositionLocation.y, PositionLocation.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 1.75, 0, 204, 0, 100, false, true, 2, false, false, false, false)
        end
      end
   end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)		
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local PedinVehicle = IsPedSittingInAnyVehicle(PlayerPedId())
		local JoueurDansLaZone = false
		
	for _, PositionPlayer in pairs(PosLocation) do
		if(GetDistanceBetweenCoords(coords, PositionPlayer.x, PositionPlayer.y, PositionPlayer.z, true) < 1.30) then
		   JoueurDansLaZone = true
		end
	end
				
	if JoueurDansLaZone and not kLocVisible then
            RageUI.Visible(RMenu:Get('kLocation', 'main'), true)
            kLocVisible = true
	end
		
        if not JoueurDansLaZone then
            Citizen.Wait(150)
            RageUI.Visible(RMenu:Get('kLocation', 'main'), false)
            kLocVisible = false
            JoueurDansLaZone = false
        end


        if PedinVehicle and JoueurDansLaZone then
            RageUI.Visible(RMenu:Get('kLocation', 'main'), false)
            kLocVisible = false
            JoueurDansLaZone = false
        end
	end
end)

RecupModelPNJ = function(modelHash)
    if type(modelHash) == "string" then modelHash = GetHashKey(modelHash) end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
end

Citizen.CreateThread(function()
    for i=1, #OptionsPNJ do
        local pnj = OptionsPNJ[i]["InfosPNJ"]
        if ActiverPNJ then
            pnj["modelHash"] = pnj["modelHash"]
            RecupModelPNJ(pnj["modelHash"])
            if not DoesEntityExist(pnj["entity"]) then
                pnj["entity"] = CreatePed(4, pnj["modelHash"], pnj["x"], pnj["y"], pnj["z"], pnj["h"])
                SetEntityAsMissionEntity(pnj["entity"])
                SetBlockingOfNonTemporaryEvents(pnj["entity"], true)
                FreezeEntityPosition(pnj["entity"], true)
                SetEntityInvincible(pnj["entity"], true)
            end
            SetModelAsNoLongerNeeded(pnj["modelHash"])
        end
    end
end)
