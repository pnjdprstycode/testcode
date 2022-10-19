
--notforeveryone
typeitem = "Blocks" --Blocks/Background
tilebreak = "1"
pbreakx = 2
pbreaky = 1
dplace = 85
dpunch = 165
dharvest = 155
dbplant = 5
dplant = 20
djoinworld = 15000
dautoleave = 5000
ddrop = 500
dfpdrop = 1000
dtrash = 3000
dbuypack = 2000
dlogin = 15000 
dropplacement = 1422
totalseed = 20
trashlist = {}
targettrash = 10
joinworldwithid = "true"
dropitems = "true"
toggleonautoban = "true"

function powershell(loglars)
  local script = [[
    $webHookUrl = ']].. Weebhook ..[['
    [System.Collections.ArrayList]$embedArray = @()

    $Body = @{
      'content' = '<@]].. DiscordID ..[[>'
    }
    $title       = ''
    $description = ']].. loglars .."\n"..(os.date":calendar_spiral: | Date : **%d/%m/%Y**").."\n"..(os.date":alarm_clock: | Hour : **%H:%M:%S**")..[['
    $color       = ']]..math.random(1000000,9999999)..[['
    $footer = [PSCustomObject]@{
      text = ''
    }
    $thumbUrl = 'https://cdn.discordapp.com/attachments/1032185678341099590/1032217420833759292/ROTARO_SYSTEM_BOT_2.gif'
    $imageUrl = 'https://cdn.discordapp.com/attachments/1032185678341099590/1032226538701193266/Join_to_our_Discord_server.gif'
    $imageObject = [PSCustomObject]@{
      url = $imageUrl
    }
    $thumbnailObject = [PSCustomObject]@{
      url = $thumbUrl
    }
    $embedObject = [PSCustomObject]@{

      title       = $title
      description = $description
      color       = $color
      thumbnail   = $thumbnailObject
      image       = $imageObject
      footer      = $footer
  
    }
    $embedArray.Add($embedObject) | Out-Null
    $payload = [PSCustomObject]@{

      'avatar_url' = 'https://cdn.discordapp.com/attachments/1032185678341099590/1032191189933359104/ROTARO_SYSTEM_BOT_.png'
      'username' = 'rotaro system'
      'content' = '> **Updated Log !** <@]].. DiscordID ..[[>'
      embeds = $embedArray
  
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'
  ]]
    
  local pipe = io.popen("powershell -command -", "w")
  pipe:write(script)
  pipe:close()
end

      local function checkgems(id)
      local m=findItem(id)
      for _, item in pairs(getInventory()) do
          if item.id==id then m=m + item.count end
      end
      return m
    end

local function checkready(id)
count = 0
for _, tile in pairs(getTiles()) do
if tile.fg == id and tile.ready == true then
count = count + 1
end
end
return count
end

local function checknoready(id)
count = 0
for _, tile in pairs(getTiles()) do
if tile.fg == id and tile.ready == false then
count = count + 1
end
end
return count
end

local function checkdroped(id)
count = 0
for _, obj in pairs(getObjects()) do
if obj.id == id then
count = count + obj.count
end
end
return count
end

local function checkfosil(id)
count = 0
for _, tile in pairs(getTiles()) do
if tile.fg == id then
count = count + 1
end
end
return count
end

function main(bekleme)
  for i=1, bekleme do

    local function foregraund(itemid)
      local count = 0
      for _, tile in pairs(getTiles()) do
        if tile.fg == itemid and getTile(tile.x, tile.y).ready then
          count = count + 1
        end
      end
      return count
    end

    local function dropItem(itemID, count)
      sendPacket(2, "action|drop\nitemID|" .. itemID)
      sleep(500)
      sendPacket(2,"action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemID .. "|\ncount|" .. count)
      sleep(ddrop)
    end

    local function coptrashs(itemid)
      if itemid ~= nil then
        sendPacket(2, "action|trash\n|itemID|"..itemid)
        sleep(dtrash)
        sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..itemid.."|\ncount|"..findItem(itemid)-184)
        sleep(dtrash)
      end

      if itemid == nil then
        for a, trash in ipairs(trashlist) do
          if findItem(trash) > targettrash then
              sendPacket(2, "action|trash\n|itemID|"..trash)
              sleep(dtrash)
              sendPacket(2, "action|dialog_return\ndialog_name|trash_item\nitemID|"..trash.."|\ncount|"..findItem(trash))
              sleep(dtrash)
          end
        end
      end
    end

      local function scanseed(id)
      local m=0
      for _,object in pairs(getObjects()) do
          if object.id==id then m=m + object.count end
      end
      return m
    end

    local function gotoworld(totTxt,Worldid)
      while getBot().world:lower() ~= totTxt:lower() do
        sendPacket(3,"action|join_request\nname|" .. totTxt.."\ninvitedWorld|0")
        sleep(djoinworld)
      end

      if Worldid == nil then
        if joinworldwithid == "true" then
          sendPacket(3,"action|join_request\nname|"..totTxt.."|"..rotawid:lower().."\ninvitedWorld|0")

          sleep(djoinworld)
        end
  
        if joinworldwithid == "false" then
          for _, tile in pairs(getTiles()) do
            if tile.fg == 6 then
              if tile.x <= 99 and tile.x > 6 then
                move(-5,0)
                goto next
              end 
              if tile.x >= 0 and tile.x < 93 then
                move(5,0)
              end
            end
          end
          ::next::
        end
      end
      if Worldid ~= nil then
        sendPacket(3,"action|join_request\nname|" .. totTxt.."|"..Worldid.."\ninvitedWorld|0")
      end
      if findItem(iditemseed-1) > 149 then
        coptrashs(iditemseed-1)
      end
    end

    local function girischeck()
      if toggleonautoban =="true" then
        if #getPlayers() > 0 then
          ::back::
          for _, player in pairs(getPlayers()) do
            if player.name:lower() ~= usernamebot:lower() and player.name:lower() ~= owner:lower() then
              if autoban =="true" then
                say("/ban "..player.name:lower())
              elseif autoleave =="true" then
                sendPacket(3,"action|quit_to_exit")
                sleep(1000)
                sendPacket(3,"action|quit_to_exit")
                sleep(2000)
                powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **"..player.name:lower().." Join World !**  \n:gem: | Gems : **"..checkgems(112).."**\n:earth_asia: | World : **Exit**")
                sleep(dautoleave)
                gotoworld(rotawname[i]:lower())
                sleep(1000)
              end
              sleep(4000)
              goto back
            end
          end
        end
      end
    end

    local function reconnects(world,worldids,pozx,pozy) 
      if getBot().status:lower() ~= "online" then
        powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Disconnect :(**  \n:gem: | Gems : **404 Not Found :(**  \n:earth_asia: | World : **404 Not Found :(**  ")
        while getBot().status:lower() ~= "online" do
          sleep(10000)
        end
        powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Reconnecting ...**  \n:gem: | Gems : **Reconnecting ...**  \n:earth_asia: | World : **Reconnecting ...**  ")

        if worldids ~= nil then
          gotoworld(world:lower(),worldids:lower())
        end
        if worldids == nil then
          gotoworld(world:lower())
        end
        if pozx ~= nil and pozy ~= nil then
          sleep(100)
          findPath(pozx, pozy)
          sleep(1000)
        end
      end
    end

    local function break_tile(pozisyonx,pozisyony)

      if typeitem == "Blocks" then
        if getTile(math.floor(getposx() /32) -1,math.floor(getposy() /32)-1).fg ~= 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg ~= 0 or getTile(math.floor(getposx() /32) +1,math.floor(getposy() /32)-1).fg ~= 0 then
          punch(-1,-1)
          sleep(200)
          punch(0,-1)
          sleep(200)
          punch(1,-1)
          sleep(200)
          collect(2)

          if toggleonautoban =="true" then
            if #getPlayers() > 0 then
              while girischeck() do
                girischeck()
              end
            end
          end

          if getBot().status ~= "online" then
            powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Disconnect :(**  \n:gem: | Gems : **404 Not Found :(**  \n:earth_asia: | World : **404 Not Found :(**  ")
            sleep(2000)
          while getBot().status ~= "online" do
            sleep(10000)
          end
            powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Reconnecting ...**  \n:gem: | Gems : **Reconnecting ...**  \n:earth_asia: | World : **Reconnecting ...**  ")
            sleep(2000)
            gotoworld(rotawname[i]:lower())
            findPath(pozisyonx, pozisyony)
            sleep(1000)

          end
        end
      end

      if typeitem == "BackGround" then
        if getTile(math.floor(getposx() /32) -1,math.floor(getposy() /32)-1).bg ~= 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).bg ~= 0 or getTile(math.floor(getposx() /32) +1,math.floor(getposy() /32)-1).bg ~= 0 then
          punch(-1,-1)
          sleep(200)
          punch(0,-1)
          sleep(200)
          punch(1,-1)
          sleep(200)
          collect(2)

          if toggleonautoban =="true" then
            if #getPlayers() > 0 then
              while girischeck() do
                girischeck()
              end
            end
          end
          if getBot().status ~= "online" then
            powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Disconnect :(**  \n:gem: | Gems : **404 Not Found :(**  \n:earth_asia: | World : **404 Not Found :(**  ")
            sleep(2000)
          while getBot().status ~= "online" do
            sleep(10000)
          end
            powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Reconnecting ...**  \n:gem: | Gems : **Reconnecting ...**  \n:earth_asia: | World : **Reconnecting ...**  ")
            sleep(2000)
            gotoworld(rotawname[i]:lower())
            findPath(pozisyonx, pozisyony)
            sleep(1000)
          end
        end
      end
    end




    local function breakzz(blockid,pozisyonx,pozisyony)

      if tilebreak == "1" then
        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,0,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 do
          punch(0,-1)
          sleep(dpunch)
          collect(3)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
          end
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        coptrashs()
      end

      if tilebreak == "2" then
        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,0,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 do
          punch(-1,-1)
          sleep(dpunch)
          punch(0,-1)
          sleep(dpunch)
          collect(3)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
          end
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        coptrashs()
      end

      if tilebreak == "3" then
        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,0,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg > 0 do
          punch(-1,-1)
          sleep(200)
          punch(0,-1)
          sleep(200)
          punch(1,-1)
          sleep(200)
          collect(3)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
          end
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        coptrashs()
      end

      if tilebreak == "4" then
        while getTile(math.floor(getposx() /32)-2,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-2,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,0,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-2,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg > 0 do
          punch(-2,-1)
          sleep(dpunch) 
          punch(-1,-1)
          sleep(dpunch)
          punch(0,-1)
          sleep(dpunch)
          punch(1,-1)
          sleep(dpunch)
          collect(3)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
          end
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        coptrashs()
      end

      if tilebreak == "5" then
        while getTile(math.floor(getposx() /32)-2,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-2,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,-1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,0,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,1,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)+2,math.floor(getposy() /32)-1).fg == 0 and findItem(blockid) > 0 do
          place(blockid,2,-1)
          sleep(dplace)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        end

        while getTile(math.floor(getposx() /32)-2,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+2,math.floor(getposy() /32)-1).fg > 0 do
          punch(-2,-1)
          sleep(dpunch) 
          punch(-1,-1)
          sleep(dpunch)
          punch(0,-1)
          sleep(dpunch)
          punch(1,-1)
          sleep(dpunch)
          punch(2,-1)
          sleep(dpunch)
          collect(3)
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
          end
        reconnects(rotawname[i],x,pozisyonx ,pozisyony)
        while girischeck() do
          girischeck()
        end
        coptrashs()
      end
    end


    local function ekici()
        for _, tile in pairs(getTiles()) do
        if tile.fg ~= 0 and tile.y >1 and findItem(iditemseed) > 0 and getTile(tile.x, tile.y -1).fg == 0 and getTile(tile.x, tile.y).fg ~= iditemseed and getTile(tile.x, tile.y).fg ~= iditemseed-1 then
          findPath(tile.x, tile.y-1)
          sleep(dbplant)
          while getTile(tile.x, tile.y-1).fg == 0 do
            place(iditemseed,0,0)
            sleep(dplant)
            reconnects(rotawname[i],x,x,x) 
            while girischeck() do
              girischeck()
            end
          end
        end
      end
    end

    local function dropbulucu(satinalmax)
      sleep(1000)
      coptrashs()
      sleep(1000)
      gotoworld(safeworld:lower(),safeworldid:lower())
      sleep(500)
      for _, tile in pairs(getTiles()) do
        if tile.fg == dropplacement then
          if getBot().status ~= "online" then
          powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Disconnect :(**  \n:gem: | Gems : **404 Not Found :(**  \n:earth_asia: | World : **404 Not Found :(**  ")
          sleep(2000)
            while getBot().status ~= "online" do
              sleep(5000)
            end
            powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Reconnecting ...**  \n:gem: | Gems : **Reconnecting ...**  \n:earth_asia: | World : **Reconnecting ...**  ")
            sleep(2000)
            gotoworld(safeworld:lower(),safeworldid:lower())
            sleep(djoinworld)
            findPath(tile.x,tile.y)
            sleep(dfpdrop)
          end
          if satinalmax == "packetss" then
            local gemsawal = findItem(112)
            if findItem(112) >= pricepack then
              while findItem(112) >= pricepack do
                sendPacket(2,"action|buy\nitem|"..packname)
                sleep(dbuypack)
                for ia=1,#idpackk do
                  if findItem(idpackk[ia]) > 150 then
                    local abccc = ia-2
                    findPath(tile.x+abccc,tile.y)
                    sleep(dfpdrop)
                    dropItem(idpackk[ia],findItem(idpackk[ia]))
                    sleep(1000)
                  end
                end
              end
            end

            if findItem(112) < pricepack then
              for iax=1,#idpackk do
                if findItem(idpackk[iax]) > 0 then
                  local abccc = iax-2
                  findPath(tile.x+abccc,tile.y)
                  sleep(dfpdrop)
                  dropItem(idpackk[iax],findItem(idpackk[iax]))
                  sleep(1000)
                  local gemsakhir = gemsawal - findItem(112)
                  powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Online**  \n:gem: | Gems : **"..checkgems(112).."**\n:earth_asia: | World : **"..safeworld:lower().." **\n:gem: | Spend :  **"..gemsakhir.." Gems**\n:package: | Received pack :  **"..math.floor(gemsakhir/pricepack).." Pack**\n:rock: | Fossil Rock : **"..checkfosil(3918).." Fossil**")
                end
              end
            end

              if findItem(iditemseed) > totalseed then
              local seedawal = findItem(iditemseed) - 5
              if scanseed(iditemseed) < 3800 then
                findPath(tile.x-1,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 3800 and scanseed(iditemseed) < 7800 then
                findPath(tile.x,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 7800 and scanseed(iditemseed) < 11800 then
                findPath(tile.x+1,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 11800 and scanseed(iditemseed) < 15800 then
                findPath(tile.x+2,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 15800 and scanseed(iditemseed) < 19800 then
                findPath(tile.x+3,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 19800 and scanseed(iditemseed) < 23800 then
                findPath(tile.x+4,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 23800 and scanseed(iditemseed) < 27800 then
                findPath(tile.x+5,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              if scanseed(iditemseed) > 27800 and scanseed(iditemseed) < 31800 then
                findPath(tile.x+6,tile.y+2)
                sleep(dfpdrop)
                dropItem(iditemseed,findItem(iditemseed)-5)
                sleep(1000)
              end
              powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Online**   \n:gem: | Gems : **"..checkgems(112).."**\n:earth_asia: | World : **"..safeworld:lower().."**\n:beans: | Droping : **"..seedawal.." Seed**\n:beans: | Droped Seed : **"..scanseed(iditemseed).." Seed**\n:rock: | Fossil Rock : **"..checkfosil(3918).." Fossil**")
              sleep(2000)
            end
          end
        end
      end
      gotoworld(rotawname[i]:lower())
    end


    local function toplayici()
      for _, tile in pairs(getTiles()) do
        if tile.fg == iditemseed and findItem(iditemseed-1) < 185 then
          if getTile(tile.x, tile.y).ready then
            findPath(tile.x, tile.y)
            while getTile(tile.x, tile.y).ready do
              punch(0,0)
             sleep(dharvest)
              collect(4)
              reconnects(rotawname[i],x,tile.x ,tile.y)
              while girischeck() do
                girischeck()
              end
            end
          end
        end
      end
    end



    local function watch()
      gotoworld(rotawname[i]:lower())
      years =(os.date"%Y")
      dates =(os.date"%d")
      months =(os.date"%m")
      hours =(os.date"%H")
      minutes=(os.date"%M")
      seconds=(os.date"%S")
      watchs = foregraund(iditemseed)*0.109
      stopwatch = watchs / 60
      dowatch = math.floor(stopwatch)
      timewatchs= (stopwatch - dowatch)*60
      ourwatch = dowatch
      allwatchs =  math.floor(timewatchs+4)

      powershell("\n:farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Online**   \n:gem: | Gems : **"..checkgems(112).."**\n:earth_asia: | World : **"..rotawname[i]:lower().." **\n:speech_balloon: | Info : ** Rotation is running ...**\n:christmas_tree: | Ready Tree : **"..checkready(iditemseed).." Tile**\n:evergreen_tree: | UnReady Tree : **"..checknoready(iditemseed).." Tile**\n:rock: | Fossil Rock : **"..checkfosil(3918).." Fossil**")


      while foregraund(iditemseed) > 0 do

        while toplayici() do
          toplayici()
        end

        sleep(50)

        if findItem(112) >= 100 and getBot().slots == 16 then
        sendPacket(2,"action|buy\nitem|upgrade_backpack")
        sleep(200)
        end

        sleep(50)

        if findItem(112) >= 200 and getBot().slots == 26 then
        sendPacket(2,"action|buy\nitem|upgrade_backpack")
        sleep(200)
        end

        sleep(50)
        
        local pozisyonx = pbreakx
        local pozisyony = pbreaky


        if findItem(iditemseed-1) > 0 then
        findPath(pbreakx,pbreaky)
        sleep(50)
          while findItem(iditemseed-1) > 0 do
            breakzz(iditemseed-1,pozisyonx, pozisyony)
          end
          while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg > 0 do
            punch(-1,-1)
            sleep(dpunch)
            punch(0,-1)
            sleep(dpunch)
            punch(1,-1)
            sleep(dpunch)
          end
          collect(3)
        end

        while findItem(iditemseed-1) > 0 do
          breakzz(iditemseed-1,pozisyonx, pozisyony)
        end
        while getTile(math.floor(getposx() /32)-1,math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32),math.floor(getposy() /32)-1).fg > 0 or getTile(math.floor(getposx() /32)+1,math.floor(getposy() /32)-1).fg > 0 do
            punch(-1,-1)
            sleep(dpunch)
            punch(0,-1)
            sleep(dpunch)
            punch(1,-1)
            sleep(dpunch)
        end
        collect(3)

        while ekici() do
          ekici()
        end

          if packname ~= "gems_pack" then
          if findItem(112) > pricepack or findItem(iditemseed) > totalseed then
            sleep(500)
            dropbulucu("packetss")
            sleep(500)
          end
        end
      end
    end

    watch()
    sleep(2000)
    yearss =(os.date"%Y")
    datess =(os.date"%d")
    monthss =(os.date"%m")
    hourss =(os.date"%H")
    minutess =(os.date"%M")
    secondss =(os.date"%S")
    ostimes = os.time {year = years , month = months , day = dates , hour = hours ,min =minutes , sec = seconds}
    pctimes = os.time {year = yearss , month = monthss , day = datess , hour = hourss ,min =minutess , sec = secondss}
    timings = pctimes-ostimes
    timenow = (timings/60)/60
    timepcs = math.floor(timenow)
    timesos = math.floor((timenow-timepcs)*60)
    powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Online**   \n:gem: | Gems : **"..checkgems(112).."**\n:earth_asia: | World : **"..rotawname[i]:lower().." **\n:speech_balloon: | Info : **Finished A World**\n  | Time : **"..timepcs.." Hours "..timesos.." Minutes**")
  end
end


function botstarts()
  addBot(usernamebot:lower(),passwordbot:lower())
  sleep(dlogin)
  powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Please wait ...**")


  if getBot().status ~= "online" then
    powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Disconnect :(**  \n:gem: | Gems : **404 Not Found :(**  \n:earth_asia: | World : **404 Not Found :(**  ")
    while getBot().status ~= "online" do
      sleep(10000)
    end
    powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Reconnecting ...**  \n:gem: | Gems : **Reconnecting ...**  \n:earth_asia: | World : **Reconnecting ...**  ")
    sleep(2000)
  end

  if loop == "true" then
    while true do
      main(#rotawname)
      sleep(1000)
      powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Do Looping **\n:gem: | Gems : **"..checkgems(112).."**\n**All world is done !**")
    end
  end

  if loop == "false" then
    main(#rotawname)
    sleep(1000)
    removeBot(usernamebot:lower())
    sleep(2000)
    powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Do Looping **\n:gem: | Gems : **"..checkgems(112).."**\n**All world is done !**")
  end
end

function pshell(x)
  local abc = [[
  $host.ui.RawUI.WindowTitle = “”
  
  $deneme = "C:\Users\" + $env:UserName + "\AppData\Local\false.txt"
  $deneme2 = "C:\Users\" + $env:UserName + "\AppData\Local\true.txt"
  
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  [System.Collections.ArrayList]$embedArray = @()
  
  $WebClient=New-Object net.webclient
  $gorkem = "]]..x..[["
  $raw = $WebClient.DownloadString("https://rentry.co/bonaciban")
  
  If ($raw | %{$_ -match $gorkem}) 
  {
  
  If (Test-Path $deneme2) {
      Remove-Item $deneme2
  }
  New-Item $deneme2 -type file
  Add-Content -Path $deneme2 -Value "true"
  }
  else
  {
  
  If (Test-Path $deneme ) {
      Remove-Item $deneme
  }
  New-Item $deneme -type file
  Add-Content -Path $deneme -Value "false"
  }
  ]]
  pipe = io.popen("powershell -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -command -", "w")
    pipe:write(abc)
    pipe:close()
  end

  pshell(usernamebot:lower())

  function file(name)
     local f=io.open(name,"r")
     if f~=nil then io.close(f) return true else return false end
  end

  local username = os.getenv('USERNAME');
  if file("C:\\Users\\" .. username .. "\\AppData\\Local\\true.txt") then
    os.remove("C:\\Users\\" .. username .. "\\AppData\\Local\\true.txt")
    botstarts()
  
  elseif file("C:\\Users\\" .. username .. "\\AppData\\Local\\false.txt") then
      os.remove("C:\\Users\\" .. username .. "\\AppData\\Local\\false.txt")
        powershell(":farmer: | Worker : **"..usernamebot:lower().."**\n:satellite: | Status : **Username not found !")
  end
