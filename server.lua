local eventoAtivo = false
local textoEvento = ""
local localizacaoEvento = nil
local dimensaoEvento = 1000 -- ID da dimensão para o evento
local criadorEvento = nil

-- Comando para criar evento
RegisterCommand("criarevento", function(source, args)
    local xPlayer = source

    -- Verificar se já existe um evento ativo
    if eventoAtivo then
        TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^1[Erro]", "Já existe um evento ativo!" } })
        return
    end

    -- Ativar evento
    eventoAtivo = true
    criadorEvento = xPlayer
    local pos = GetEntityCoords(GetPlayerPed(xPlayer))
    localizacaoEvento = pos

    -- Solicitar texto para o evento
    TriggerClientEvent("evento:anunciar", -1, "UM NOVO EVENTO DISPONÍVEL! DIGITE /EVENTO PARA PARTICIPAR!")


    -- Adicionar o criador à dimensão do evento
    SetPlayerRoutingBucket(xPlayer, dimensaoEvento)
end)

-- Receber o texto do evento e anunciar
RegisterNetEvent("evento:receberTexto")
AddEventHandler("evento:receberTexto", function(texto)
    local source = source

    if not eventoAtivo then return end

    textoEvento = texto

    -- Enviar mensagem para todos os jogadores
    TriggerClientEvent("evento:anunciar", -1, textoEvento)

    -- Mostrar mensagem no chat
    TriggerClientEvent("chat:addMessage", -1, { args = { "^2[Evento]", "Um novo evento foi iniciado: " .. textoEvento } })
end)

RegisterCommand("sair", function(source, args)
    local xPlayer = source
    TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^1[Erro]", "Você saiu do evento." } })
    SetPlayerRoutingBucket(xPlayer, 0)
end)
-- Receber o texto do evento
RegisterNetEvent("evento:receberTexto")
AddEventHandler("evento:receberTexto", function(texto)
    local source = source

    if not eventoAtivo then return end

    textoEvento = texto
    TriggerClientEvent("chat:addMessage", -1, { args = { "^2[Evento]", "Um novo evento foi iniciado: " .. textoEvento } })
end)

-- Comando para entrar no evento
RegisterCommand("evento", function(source, args)
    local xPlayer = source

    -- Verificar se o evento está ativo
    if not eventoAtivo then
        TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^1[Erro]", "Não há nenhum evento ativo no momento!" } })
        return
    end

    -- Verificar se o jogador já está na dimensão do evento
    local currentDimension = GetPlayerRoutingBucket(xPlayer)
    if currentDimension == dimensaoEvento then
        TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^2[Info]", "Você já está no evento!" } })
        return
    end

    -- Teleportar jogador para o evento e alterar a dimensão
    SetEntityCoords(GetPlayerPed(xPlayer), localizacaoEvento.x, localizacaoEvento.y, localizacaoEvento.z, false, false, false, true)
    SetPlayerRoutingBucket(xPlayer, dimensaoEvento)

    TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^2[Sucesso]", "Você foi teleportado para o evento!" } })
end)


-- Comando para fechar evento
RegisterCommand("fecharevento", function(source, args)
    local xPlayer = source

    -- Verificar se o jogador é o criador do evento
    if xPlayer ~= criadorEvento then
        TriggerClientEvent("chat:addMessage", xPlayer, { args = { "^1[Erro]", "Somente o criador do evento pode encerrá-lo!" } })
        return
    end

    -- Resetar dados do evento
    eventoAtivo = false
    textoEvento = ""
    localizacaoEvento = nil
    criadorEvento = nil

    -- Enviar mensagem de encerramento
    TriggerClientEvent("chat:addMessage", -1, { args = { "^1[Evento]", "O evento foi encerrado!" } })
end)
