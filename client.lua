print("test")

-- Função para abrir teclado nativo e capturar texto
function abrirTeclado(titulo, limite)
    -- Título do teclado (mensagem exibida)
    AddTextEntry("FMMC_KEY_TIP1", titulo)

    -- Abrir teclado com limite de caracteres
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", limite)

    -- Aguardar resposta do teclado
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end

    -- Capturar a entrada do usuário
    local status = UpdateOnscreenKeyboard()
    if status == 1 then
        return GetOnscreenKeyboardResult() -- Retorna o texto digitado
    elseif status == 2 then
        return nil -- O jogador cancelou
    end
end

-- Evento para abrir teclado e capturar texto
RegisterNetEvent("evento:abrirTexto")
AddEventHandler("evento:abrirTexto", function()
    -- Abrir o teclado do FiveM
    local textoEvento = abrirTeclado("Digite o texto do evento", 400)

    if textoEvento then
        -- Enviar texto para o servidor
        TriggerServerEvent("evento:receberTexto", textoEvento)
    else
        -- Caso o jogador cancele a entrada de texto
        TriggerEvent("chat:addMessage", { args = { "^1[Erro]", "Nenhum texto foi inserido para o evento." } })
    end
end)

RegisterNetEvent("evento:anunciar")
AddEventHandler("evento:anunciar", function(mensagem)
    -- Enviar mensagem para o NUI
    print("announcement")
    SendNUIMessage({
        type = "showAnnouncement",
        text = mensagem
    })
end)

