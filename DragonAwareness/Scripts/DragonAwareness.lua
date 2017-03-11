local version = "1.02"

local mfloor, lpairs = math.floor, pairs

local res = Game.Resolution()
local width = res.x

local enemies = {}
for i = 1, Game.HeroCount() do
	local hero = Game.Hero(i)
	if hero and hero.team ~= myHero.team then
		enemies[#enemies + 1] = hero
	end
end

local HudSprite
local UltUpSprite
local UltCdSprite
local ChampionSprite = {}
local SpellSprite = {}

local XPlevels = { 280, 660, 1140, 1720, 2400, 3180, 4060, 5040, 6120, 7300, 8580, 9960, 11440, 13020, 14700, 16480, 18360 }

local ChampionManaBarColor = {
	['Aatrox'] = function (unit) if unit.mana == 100 then return Draw.Color(255, 200, 40, 0) else return Draw.Color(255, 100, 100, 100) end end, 
	['Ahri'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Akali'] = function (unit) return Draw.Color(255, 178, 140, 1) end, 
	['Alistar'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Amumu'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Anivia'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Annie'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Ashe'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['AurelionSol'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Azir'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Bard'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Blitzcrank'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Brand'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Braum'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Caitlyn'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Camille'] = function (unit) if unit.mana == 100 then return Draw.Color(255, 200, 40, 0) elseif unit.mana >= 50 then return Draw.Color(255, 100, 100, 100) else return Draw.Color(255, 100, 100, 100) end end, 
	['Cassiopeia'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Chogath'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Corki'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Darius'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Diana'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['DrMundo'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Draven'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Ekko'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Elise'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Evelynn'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Ezreal'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['FiddleSticks'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Fiora'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Fizz'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Galio'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Gangplank'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Garen'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Gnar'] = function (unit) if unit.range > 240 then return Draw.Color(255, 200, 40, 0) else return Draw.Color(255, 100, 100, 100) end end, 
	['Gragas'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Graves'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Hecarim'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Heimerdinger'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Illaoi'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Irelia'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Ivern'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Janna'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['JarvanIV'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Jax'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Jayce'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Jhin'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Jinx'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Kalista'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Karma'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Karthus'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Kassadin'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Katarina'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Kayle'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Kennen'] = function (unit) return Draw.Color(255, 178, 140, 1) end, 
	['Khazix'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Kindred'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Kled'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['KogMaw'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Leblanc'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['LeeSin'] = function (unit) return Draw.Color(255, 178, 140, 1) end, 
	['Leona'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Lissandra'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Lucian'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Lulu'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Lux'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Malphite'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Malzahar'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Maokai'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['MasterYi'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['MissFortune'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Mordekaiser'] = function (unit) return Draw.Color(255, 100, 100, 100) end, 
	['Morgana'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nami'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nasus'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nautilus'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nidalee'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nocturne'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Nunu'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Olaf'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Orianna'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Pantheon'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Poppy'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Quinn'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Rammus'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['RekSai'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Renekton'] = function (unit) if unit.mana > 50 then return Draw.Color(255, 200, 40, 0) else return Draw.Color(255, 100, 100, 100) end end, 
	['Rengar'] = function (unit) if unit.mana < 5 then return Draw.Color(255, 100, 100, 100) else return Draw.Color(255, 200, 40, 0) end end, 
	['Riven'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Rumble'] = function (unit) if unit.mana < 50 then return Draw.Color(255, 100, 100, 100) else return Draw.Color(255, 220, 130, 0) end end, 
	['Ryze'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Sejuani'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Shaco'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Shen'] = function (unit) return Draw.Color(255, 178, 140, 1) end, 
	['Shyvana'] = function (unit) if unit.mana == 100 then return Draw.Color(255, 200, 40, 0) else return Draw.Color(255, 220, 130, 0) end end, 
	['Singed'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Sion'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Sivir'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Skarner'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Sona'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Soraka'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Swain'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Syndra'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['TahmKench'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Taliyah'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Talon'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Taric'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Teemo'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Thresh'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Tristana'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Trundle'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Tryndamere'] = function (unit) return Draw.Color(255, 200, 40, 0) end, 
	['TwistedFate'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Twitch'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Udyr'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Urgot'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Varus'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Vayne'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Veigar'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Velkoz'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Vi'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Viktor'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Vladimir'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Volibear'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Warwick'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	 --[[ Wukong ]] ['MonkeyKing'] = function (unit) return Draw.Color(255, 1, 130, 181) end,
	['Xerath'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['XinZhao'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Yasuo'] = function (unit) if unit.mana == unit.maxMana then return Draw.Color(255, 200, 40, 0) else return Draw.Color(255, 100, 100, 100) end end, 
	['Yorick'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Zac'] = function (unit) return Draw.Color(0, 0, 0, 0) end, 
	['Zed'] = function (unit) return Draw.Color(255, 178, 140, 1) end, 
	['Ziggs'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Zilean'] = function (unit) return Draw.Color(255, 1, 130, 181) end, 
	['Zyra'] = function (unit) return Draw.Color(255, 1, 130, 181) end
}

local function InitSprites()
	HudSprite = Sprite("DragonAwareness/Others/hud.png")
	UltUpSprite = Sprite("DragonAwareness/Others/hudUltUp.png")
	UltCdSprite = Sprite("DragonAwareness/Others/hudUltCd.png")
	
	for i, hero in lpairs(enemies) do
		ChampionSprite[hero.charName] = Sprite("DragonAwareness/Champions/"..hero.charName..".png", 0.62, 0.62)
	end
	
	SpellSprite["SummonerBarrier"] = Sprite("DragonAwareness/Spells/SummonerBarrier.png")
	SpellSprite["SummonerMana"] = Sprite("DragonAwareness/Spells/SummonerMana.png")
	SpellSprite["SummonerBoost"] = Sprite("DragonAwareness/Spells/SummonerBoost.png")
	SpellSprite["SummonerExhaust"] = Sprite("DragonAwareness/Spells/SummonerExhaust.png")
	SpellSprite["SummonerFlash"] = Sprite("DragonAwareness/Spells/SummonerFlash.png")
	SpellSprite["SummonerHaste"] = Sprite("DragonAwareness/Spells/SummonerHaste.png")
	SpellSprite["SummonerHeal"] = Sprite("DragonAwareness/Spells/SummonerHeal.png")
	SpellSprite["SummonerDot"] = Sprite("DragonAwareness/Spells/SummonerDot.png")
	SpellSprite["SummonerSnowball"] = Sprite("DragonAwareness/Spells/SummonerSnowball.png")
	SpellSprite["SummonerSmite"] = Sprite("DragonAwareness/Spells/SummonerSmite.png")
	SpellSprite["S5_SummonerSmitePlayerGanker"] = Sprite("DragonAwareness/Spells/S5_SummonerSmitePlayerGanker.png")
	SpellSprite["S5_SummonerSmiteDuel"] = Sprite("DragonAwareness/Spells/S5_SummonerSmiteDuel.png")
	SpellSprite["SummonerTeleport"] = Sprite("DragonAwareness/Spells/SummonerTeleport.png")
end

local function GetManaBarColor(champ)
	return Draw.Color(255,255,255,0)
end

Callback.Add("Load", function()
	InitSprites()
end)

Callback.Add("Draw", function()
	local x = width - 101
	local y = 70
	
	for i, hero in lpairs(enemies) do
		local y = y + (i - 1) * 120
		local champName = hero.charName
		local lvl = hero.levelData.lvl
		
		HudSprite:Draw(x, y)
		
		ChampionSprite[champName]:Draw(x + 14, y + 13)
		
		SpellSprite[hero:GetSpellData(SUMMONER_1).name]:Draw(x + 72, y + 13)
		local spellOneCd = hero:GetSpellData(SUMMONER_1).currentCd
		if spellOneCd ~= 0 then
			Draw.Rect(x + 71, y + 12, 22, 23, Draw.Color(200,0,0,0))
			Draw.Text(mfloor(spellOneCd), 14, x + 72, y + 16, Draw.Color(255,255,255,255))
		end
		
		SpellSprite[hero:GetSpellData(SUMMONER_2).name]:Draw(x + 72, y + 42)
		local spellTwoCd = hero:GetSpellData(SUMMONER_2).currentCd
		if spellTwoCd ~= 0 then
			Draw.Rect(x + 71, y + 41, 23, 23, Draw.Color(200,0,0,0))
			Draw.Text(mfloor(spellTwoCd), 14, x + 72, y + 45, Draw.Color(255,255,255,255))
		end
		
		Draw.Text(hero.name, 14, x + 17, y - 10, Draw.Color(255,220,220,220))
		
		if hero.dead then
			Draw.Rect(x + 14, y + 14, 51, 51, Draw.Color(180,0,0,0))
			Draw.Text("DEAD", 14, x + 39, y + 70, Draw.Color(255,255,0,0))
		else
			local HP = hero.health / hero.maxHealth * 81
			Draw.Rect(x + 13, y + 70, HP, 7, Draw.Color(255,0,160,60))
			
			local MP = hero.mana / hero.maxMana * 81
			Draw.Rect(x + 13, y + 77, MP, 7, ChampionManaBarColor[champName](hero))
		end
		
		local XP = 81 + ((hero.levelData.exp - XPlevels[lvl]) * 81 / (280 + (100 * (lvl - 1))))
		Draw.Rect(x + 13, y + 91, XP, 2, Draw.Color(255,163,72,249))
		
		local size = Draw.FontRect(lvl, 13)
		Draw.Rect(x + 13, y + 48, size.x + 10, size.y + 2, Draw.Color(200,0,0,0))
		Draw.Text(lvl, 13, x + 18, y + 48, Draw.Color(255,255,255,255))
		
		if hero:GetSpellData(_R).level ~= 0 then
			local ultCd = hero:GetSpellData(_R).currentCd
			if ultCd == 0 then
				UltUpSprite:Draw(x + 2, y + 2)
			else
				UltCdSprite:Draw({ x = 0, y = 12, w = 12, h = (12 * ultCd / hero:GetSpellData(_R).cd) }, x + 2, y + 14)
			end
		end
	end
end)