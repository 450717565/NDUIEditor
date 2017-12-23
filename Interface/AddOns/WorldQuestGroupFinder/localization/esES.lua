local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "esES") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Hace mas sencillo encontrar grupos para las Misiones de Mundo utilizando la herramienta de Buscador de Grupos."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "Ya estás en un grupo para hacer esta misión de mundo."
L["WQGF_ALREADY_QUEUED_BG"] = "Estás en cola para un Campo de Batalla. Por favor abandona la cola y prueba otra vez."
L["WQGF_ALREADY_QUEUED_DF"] = "Estás en cola en el Buscador de Mazmorras. Por favor abandona la cola y prueba otra vez."
L["WQGF_ALREADY_QUEUED_RF"] = "Estás en cola en el Buscador de Bandas. Por favor abandona la cola y prueba otra vez."
L["WQGF_APPLIED_TO_GROUPS"] = "Te has inscrito a |c00bfffff%d|c00ffffff grupo(s) para la Misión de Mundo |c00bfffff%s|c00ffffff."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "Se le ha aplicado a | c00bfffff% d | c00ffffff grupo (s) para la misión | c00bfffff% s | c00ffffff."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[Has completado la misión y dejarás el grupo en %d segundos.

Despídete!!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[Ya has completado la misión. Serás retirado del grupo en %s segundos.

¡Despídete!]=]
L["WQGF_CANCEL"] = "Cancelar"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "Esta misión de mundo no se puede completar como un grupo."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "Este tipo de misión de mundo no se puede completar como un grupo."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Aceptar automáticamente las invitaciones al grupo al no estar en combate"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Se aceptarán las invitaciones al grupo al no estar en combate"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Aceptar automáticamente las invitaciones al grupo"
L["WQGF_CONFIG_AUTOINVITE"] = "Invitar automáticamente"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Invitar automáticamente a todo el mundo"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Cualquiera que se inscriba será automáticamente invitado al grupo hasta el límite de 5 jugadores"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "Invitar automáticamente a los usuarios de WQGF"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "Los usuarios de World Quest Finder serán automáticamente invitados al grupo"
L["WQGF_CONFIG_BINDING_ADVICE"] = "Recuerda que puedes bindear el botón de WQGF a una tecla desde el menú de Atajos de teclado!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Buscar grupos de cualquier idioma (ignorar la selección de idiomas del buscador de grupos)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Se buscarán los grupos para todos los idiomas disponibles"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Filtro de idioma al buscar grupo"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "Mensaje de WQGF al conectarte"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "Ocultar el mensaje de WQGF al conectarte"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "No mostrár el mensaje de WQGF al conectarte nunca más"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Buscar automáticamente si no estoy en un grupo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "Se buscará automáticamente un grupo al entrar en una zona de misisón de mundo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Activar la detección de una zona nueva de misión de mundo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "Se te preguntará si quieres buscar un grupo cuando entres en una zona de misión de mundo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "No proponer si ya estás en otro grupo para otra misión de mundo"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Proponer buscar ungrupo al primera vez que se entre en una zona de misión de mundo "
L["WQGF_CONFIG_PAGE_CREDITS"] = "Creado por Robou, EU-Hyjal"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Activar las notificaciones de grupo"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "Se enviará un mensaje al completar al grupo una vez se haya completado la misión."
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Avisar al grupo cuando se haya completado la misión"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Evitar los Reinos PvP"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Se evitará entrar en los grupos de Reinos PvP (este parámetro se ignora para los personajes en reinos PvP)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "Reinos PvP"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Habilitar el soporte para misiones regulares"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Al activar esta opción, se mostrará un botón para buscar grupos de misiones regulares soportadas"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Soporte regular de misiones"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Activar el modo sin notificacioens"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "Cuando se activa el modo sin notificaciones, solo se mostrarán los mensajes de WQGF mas importantes"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Modo sin notificaciones"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Abandonar el grupo automáticamente en 10 segundos"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Se abandonarán los grupos una vez completada la misión de mundo"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Activar el diálogo al acaba la misión de mundo"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "Se te preguntará si quieres abandonar el grupo o quitarlo del buscador de grupos al acabar la misión"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Mostrar un dialógo para dejar el grupo una vez se haya completado la misión"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Configuración del personaje:"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "El ID de la misión de mundo actual es |c00bfffff%s"
L["WQGF_DEBUG_MODE_DISABLED"] = "Se ha desactivado el modo Debug."
L["WQGF_DEBUG_MODE_ENABLED"] = "Se ha activado el modo Debug."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "Actualmente fuera de una misión de mundo."
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "Zonas de misión de mundo entradas en esta sesión:"
L["WQGF_DELIST"] = "Quitarlo"
L["WQGF_DROPPED_WB_SUPPORT"] = [=[El jefe mundial y el apoyo de misiones mundiales ha sido eliminado en WQGF 0.21.3.
Utilice el botón de interfaz de usuario predeterminado para buscar un grupo.]=]
L["WQGF_FIND_GROUP_TOOLTIP"] = "Buscar grupo con WQGF"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Haga clic para crear un grupo nuevo"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Haz click en el botón para unirte al grupo "
L["WQGF_FRAME_APPLY_DONE"] = [=[Has solicitado todos los grupos disponibles.
]=]
L["WQGF_FRAME_CLICK_TWICE"] = "Haga clic en el botón % veces para crear un grupo nuevo."
L["WQGF_FRAME_CREATE_WAIT"] = "Podrás crear un grupo nuevo si no obtienes respuestas."
L["WQGF_FRAME_FOUND_GROUPS"] = "Encontrado(s) % grupo(s). Haga clic en el botón para solicitar."
L["WQGF_FRAME_GROUPS_LEFT"] = "% grupo(s) ha(n) abandonado, ¡sigue clicando!"
L["WQGF_FRAME_INIT_SEARCH"] = "Haga clic en el botón para inicializar la búsqueda"
L["WQGF_FRAME_NO_GROUPS"] = "Ningún grupo encontrado, haga clic en el botón para crear un grupo nuevo."
L["WQGF_FRAME_SEARCH_GROUPS"] = "Haz click al botón para buscar grupos..."
L["WQGF_GLOBAL_CONFIGURATION"] = "Configuración global:"
L["WQGF_GROUP_CREATION_ERROR"] = "Ha ocurrido un error al intentar crear una entrada para el buscador de grupos. Por favor inténtalo de nuevo."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "Tu grupo ya no está haciendo la misión |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "Tu grupo ya no está haciendo la misión de mundo |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "Tu grupo está haciendo la misión |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "Tu grupo está haciendo la misión |c00bfffff%s|c00ffffff. Ya has completado esta misión."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "Tu grupo está haciendo la misión |c00bfffff%s|c00ffffff. No cumples con los requisitos para hacer esta misión."
L["WQGF_GROUP_NOW_DOING_WQ"] = "Tu grupo está ahora haciendo la misión de mundo |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "Tu grupo está ahora haciendo la misión de mundo |c00bfffff%s|c00ffffff. Ya has completado esa misión de mundo."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "Tu grupo está ahora haciendo la misión de mundo |c00bfffff%s|c00ffffff. No cumples los requisitos para hacer esa misión."
L["WQGF_INIT_MSG"] = "Haz click con el botón central del ratón en el seguimiento de la misión para encontrar un grupo."
L["WQGF_JOINED_WQ_GROUP"] = "Te has unido al grupo de |c00bfffff%s|c00ffffff para |c00bfffff%s|c00ffffff. Pásalo bien!"
L["WQGF_KICK_TOOLTIP"] = "Expulsar a todos los jugadores que se encuentren demasiado lejos"
L["WQGF_LEADERS_BL_CLEARED"] = "Has limpiado la lista negra de líderes."
L["WQGF_LEAVE"] = "Abandonar"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "WQGF_MIEMBRO_DEMASIADO_LEJOS"
L["WQGF_NEW_ENTRY_CREATED"] = "Se ha creado una nueva entrada de buscador de grupo para |c00bfffff%s|c00ffffff."
L["WQGF_NO"] = "No"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "Ninguna de tus inscripciones para |c00bfffff%s|c00ffffff han sido respondidas a tiempo. Intentando encontrar nuevos grupos..."
L["WQGF_NO_APPLY_BLACKLIST"] = "No te has inscrito a %d grupo(s) porqué su lider estaba en la lista negra. Puedes usar |c00bfffff/wqgf unbl |c00ffffffpour para limpiar la lista negra."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "No eres el líder del grupo."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[Ya has completado la misión.

¿Abandonar el grupo?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Ya has completado la misión.

¿Quieres abandonar el grupo o borrarlo de la lista del Buscador de Grupo?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffADVERTENCIA:|c00ffffff Este grupo está en modo Banda, por lo cual no se podrán completar la misión de mundo. Deberías preguntar al lider para cambiar el tipo del grupo si es posible. El grupo se cambiará automáticamente de modo si te combiertes en el lider."
L["WQGF_REFRESH_TOOLTIP"] = "Buscar otro grupo"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Buscar o crear un grupo"
L["WQGF_SEARCHING_FOR_GROUP"] = "Buscando un grupo para la misión |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Buscando un grupo para la misión |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffBarra de comandos (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Abre la configuración del addon"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Limpia la lista negra de líderes"
L["WQGF_SLASH_COMMANDS_4"] = "| C00bfffff / wqgf toggle: Cambia la detección de nueva zona de búsqueda mundial"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[Ya estás en un grupo para una misión.

¿Seguro que quieres crear uno nuevo?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[Estás en un grupo para otra misión de mundo.

Estas seguro que quieres empezar otro?]=]
L["WQGF_STAY"] = "Permanecer"
L["WQGF_STOP_TOOLTIP"] = "Deja de hacer esta búsqueda mundial"
L["WQGF_TRANSLATION_INFO"] = "Traducción al Español por Ooka (EU-DunModr)."
L["WQGF_USER_JOINED"] = "Un usuario de World Quest Group Finder se ha unido al grupo!"
L["WQGF_USERS_JOINED"] = "Los usuarios de World Quest Group Finder se han unido al grupo!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[Has entrado en una nueva zona de misión de mundo,pero ya estás en un grupo para otra misión de mundo.

Te gustaría dejar el grupo para encontrar otro para "%s" ?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[Has entrado en una nueva zona de misión de mundo.

¿Te gustaría buscar un grupo para "%s" ?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[Has completado la misión de mundo.

Quieres abandonar el grupo?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Has completado la misión de mundo.

Te gustaría abandonar el grupo o quitarlo del Buscador de Grupos?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "Has cancelado la inscripción para el grupo de |c00bfffff%s|c00ffffff para la misión de |c00bfffff%s|c00ffffff. WQGF intentará no volver a unirse a este grupo hasta que relogees o limpies la lista negra de líderes."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Creado automáticamente por World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "No estás en el lugar adecuado para esta Misión de Mundo."
L["WQGF_YES"] = "Si"
L["WQGF_ZONE_DETECTION_DISABLED"] = "La detección de nuevas zonas de misiones de mundo está ahora deshabilitado."
L["WQGF_ZONE_DETECTION_ENABLED"] = "Ahora está habilitada la detección de zona de las nuevas misiones del mundo."
