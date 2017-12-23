local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "ptBR") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Torna fácil encontrar grupos para missões mundiais usando a ferramenta de Busca de Grupo."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "Você já está em um grupo para esta missão mundial."
L["WQGF_ALREADY_QUEUED_BG"] = "Você está em fila para Campos de Batalha. Por favor saia da fila e tente novamente."
L["WQGF_ALREADY_QUEUED_DF"] = "Você está em fila para Masmorras. Por favor saia da fila e tente novamente."
L["WQGF_ALREADY_QUEUED_RF"] = "Você está em fila para Raides. Por favor saia da fila e tente novamente."
L["WQGF_APPLIED_TO_GROUPS"] = "Você se alistou no grupo |c00bfffff%d|c00ffffff para a missão mundial |c00bfffff%s|c00ffffff."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "Você se alistou no grupo |c00bfffff%d|c00ffffff para a missão |c00bfffff%s|c00ffffff ."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[Você completou a missão mundial e irá sair do grupo em %d segundos.

Diga tchau!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[Você completou a missão e irá sair do grupo em %d segundos.

Diga tchau!]=]
L["WQGF_CANCEL"] = "Cancelar"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "Essa missão mundial não pode ser feita em grupo."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "Esse tipo de missão mundial não pode ser completado em grupo."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Aceita automaticamente convite para grupos do WQGF quando não está em combate"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Irá aceitar automaticamente convites de grupo quando não estiver em combate"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Aceitar automaticamente convites de grupo"
L["WQGF_CONFIG_AUTOINVITE"] = "Convite automático"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Convidar automaticamente a todos"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Todo candidato será convidado automaticamente para o grupo, até o limite de 5 jogadores "
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "Convite automático de usuários do WQGF"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "Usuários WQGF serão convidados automaticamente para o grupo"
L["WQGF_CONFIG_BINDING_ADVICE"] = "Lembre-se que você pode associar o botão do WQGF a uma tecla através do menu de Teclas de Atalho do jogo!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Procurar por grupos de qualquer linguagem (ignora a seleção de linguagem da busca de grupo)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Irá sempre procurar todos os grupos existentes independente da linguagem"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Filtro de linguagem na busca de grupo"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "Mensagem de login do WQGF"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "Esconda a mensagem inicial do WQGF ao logar"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "Não mostre mais a mensagem de login do WQGF"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Comece automaticamente a procurar se não estiver em um grupo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "Irá buscar automaticamente um grupo ao entrar em uma nova zona de missão mundial"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Ativar detecção de nova zona de missão mundial"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "Perguntará se quer procurar um grupo quando entrar em uma nova zona de missão mundial"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "Não proponha se já estiver em grupo para outra missão mundial"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Proponha procurar por um grupo quando entrar em uma área de missão mundial pela primeira vez"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Trazido para você por Robou, EU-Hyjal."
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Ativar notificação de grupo"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "Uma mensagem será enviada para o grupo ao completar a missão mundial"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Notifique o grupo quando a missão mundial for completada"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Evite juntar-se a grupos em reinos PvP"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Irá evitar juntar-se a grupos em reinos PvP (esse parâmetro é ignorado para personagens em reinos PvP)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "Reinos PvP"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Habilitar suporte para missões normais"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Habilitando isso irá mostrar um botão para achar grupos para as missões normais suportadas."
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Suporte a missões normais"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Habilitar modo silencioso"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "Quando o modo silencioso está habilitado, somente as mensagens mais importantes do WQGF aparecerão"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Modo silencioso"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Sair automaticamente do grupo após 10 segundos"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Irá sair do grupo 10 segundos após a missão mundial ser completada"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Ativar diálogo final para missão mundial"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "Será proposto a você para sair do grupo ou retirá-lo da fila quando a missão mundial for completada "
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Mostra um diálogo para sair do grupo quando a missão mundial for completada"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Configuração de personagem:"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "ID da missão mundial atual é |c00bfffff%s"
L["WQGF_DEBUG_MODE_DISABLED"] = "Modo debug está agora desabilitado."
L["WQGF_DEBUG_MODE_ENABLED"] = "Modo debug está habilitado."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "Nenhuma missão atual"
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "Zonas de missão mundial entradas nessa seção:"
L["WQGF_DELIST"] = "Retirar"
L["WQGF_DROPPED_WB_SUPPORT"] = "O suporte a missões mundiais de chefes mundiais foi retirado no WQGF 0.21.3. Por favor use o botão padrão da UI para procurar um grupo."
L["WQGF_FIND_GROUP_TOOLTIP"] = "Procurar grupo com WQGF"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Clique com o botão direito para navegar pelos grupos"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Clique no botão para entrar no grupo"
L["WQGF_FRAME_APPLY_DONE"] = "Você se alistou a todos os grupos disponíveis."
L["WQGF_FRAME_CLICK_TWICE"] = "Clique no botão %d vezes para criar um novo grupo."
L["WQGF_FRAME_CREATE_WAIT"] = "Você poderá criar um novo grupo caso não receba nenhum convite."
L["WQGF_FRAME_FOUND_GROUPS"] = "Encontrado(s) %d grupo(s). Clique no botão para alistar-se."
L["WQGF_FRAME_GROUPS_LEFT"] = "Restam %d grupo(s), continue clicando!"
L["WQGF_FRAME_INIT_SEARCH"] = "Clique no botão para iniciar a busca"
L["WQGF_FRAME_NO_GROUPS"] = "Nenhum grupo encontrado, clique no botão para criar um novo grupo."
L["WQGF_FRAME_RELIST_GROUP"] = "Clique no botão para listar seu grupo novamente."
L["WQGF_FRAME_SEARCH_GROUPS"] = "Clique no botão para procurar grupos..."
L["WQGF_GLOBAL_CONFIGURATION"] = "Configuração global:"
L["WQGF_GROUP_CREATION_ERROR"] = "Ocorreu um erro ao tentar criar uma nova busca de grupo. Por favor tente outra vez."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "O seu grupo não está mais fazendo a missão |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "O seu grupo não está mais fazendo a missão mundial |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "O seu grupo está fazendo agora a missão |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "O seu grupo está fazendo agora a missão |c00bfffff%s|c00ffffff. Você já completou esta missão."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "O seu grupo está fazendo agora a missão |c00bfffff%s|c00ffffff. Você não é elegível para esta missão."
L["WQGF_GROUP_NOW_DOING_WQ"] = "O seu grupo está fazendo agora a missão mundial |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "O seu grupo está fazendo agora a missão mundial |c00bfffff%s|c00ffffff. Você já completou esta missão."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "O seu grupo está fazendo agora a missão mundial |c00bfffff%s|c00ffffff. Você não é elegível para esta missão."
L["WQGF_INIT_MSG"] = "Clique com o botão do meio do mouse na missão mundial, na janela de rastreamento de objetivo, para procurar um grupo."
L["WQGF_JOINED_WQ_GROUP"] = "Você entrou no grupo |c00bfffff%s|c00ffffff's para |c00bfffff%s|c00ffffff. Divirta-se!"
L["WQGF_KICK_TOOLTIP"] = "Remove todos os jogadores que estão muito longe"
L["WQGF_LEADERS_BL_CLEARED"] = "A lista negra de lideres foi limpa."
L["WQGF_LEAVE"] = "Sair"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "O membro do grupo %s está %s metros de distância. Use o botão de chute automático para removê-lo do grupo."
L["WQGF_NEW_ENTRY_CREATED"] = "Um novo grupo foi criado para |c00bfffff%s|c00ffffff."
L["WQGF_NO"] = "Não"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "Nenhum de seus convites para |c00bfffff%s|c00ffffff respondeu a tempo. Tentando encontrar novos grupos..."
L["WQGF_NO_APPLY_BLACKLIST"] = "Você não se alistou para o grupo %d pois o líder está na lista negra  |c00bfffff/wqgf unbl |c00ffffffpara limpar a lista."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "Você não é o líder do grupo."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[Você completou a missão.

Gostaria de sair do grupo?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Você completou a missão.

Gostaria de sair do grupo ou retirá-lo da busca ?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffATTENTION:|c00ffffff Este grupo está convertido para raide, isso significa que você não pode completar a missão mundial. Você pode pedir para o líder converter novamente para grupo se possível. Esse grupo sera convertido automaticamente se você se tornar o líder."
L["WQGF_REFRESH_TOOLTIP"] = "Procurar outro grupo"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Procurar ou Criar Grupo"
L["WQGF_SEARCHING_FOR_GROUP"] = "Procurando um grupo para a missão mundial |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Procurando um grupo para a missão |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffComandos de barra (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Abre a configuração do addon"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Limpa a lista negra de líderes"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : Alterna nova detecção de zona de missão mundial"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[No momento você está em grupo para outra missão.

Tem certeza que gostaria de começar outro?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[No momento você está em grupo para outra missão mundial.

Tem certeza que gostaria de começar outro?]=]
L["WQGF_STAY"] = "Ficar"
L["WQGF_STOP_TOOLTIP"] = "Pare de fazer esta missão mundial"
L["WQGF_TRANSLATION_INFO"] = "Traduzido para português por Lobeom-Nemesis. Correções por Canettieri."
L["WQGF_USER_JOINED"] = "Um usuário do WQGF entrou no grupo!"
L["WQGF_USERS_JOINED"] = "Usuários do WQGF entraram no grupo!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[Você entrou na área de uma nova missão mundial, mas já está em grupo para outra missão.

Gostaria de sair do grupo atual e procurar um novo para "%s" ?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[Você entrou na área de uma nova missão mundial.

Gostaria de procurar um novo grupo para "%s" ?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[Você completou esta missão mundial.

Gostaria de sair do grupo ?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Você completou essa missão mundial.

Gostaria de sair do grupo ou retirá-lo da busca ?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "Você cancelou seu convite ao grupo |c00bfffff%s|c00ffffff' para |c00bfffff%s|c00ffffff. WQGF não irá tentar juntar-se a este grupo novamente até você que relogue ou limpe a lista negra."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Criado automaticamente por World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "Você não está no local certo para esta missão mundial."
L["WQGF_YES"] = "Sim"
L["WQGF_ZONE_DETECTION_DISABLED"] = "Detecção de nova zona de missão mundial agora está desativada."
L["WQGF_ZONE_DETECTION_ENABLED"] = "Detecção de nova zona de missão mundial agora está habilitada."
