local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "frFR") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Permet de trouver facilement des groupes pour les expéditions en utilisant l'outil de recherche de groupe."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "Vous êtes déjà dans un groupe pour cette expédition."
L["WQGF_ALREADY_QUEUED_BG"] = "Vous êtes actuellement en file d'attente de champ de bataille. Veuillez quitter la file et réessayer."
L["WQGF_ALREADY_QUEUED_DF"] = "Vous êtes actuellement en file d'attente de recherche de donjon. Veuillez quitter la file et réessayer."
L["WQGF_ALREADY_QUEUED_RF"] = "Vous êtes actuellement en file d'attente de recherche de raid. Veuillez quitter la file et réessayer."
L["WQGF_APPLIED_TO_GROUPS"] = "Vous avez été inscrit à |c00bfffff%d|c00ffffff groupe(s) pour l'expédition |c00bfffff%s|c00ffffff."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "Vous avez été inscrit à |c00bfffff%d|c00ffffff groupe(s) pour la quête |c00bfffff%s|c00ffffff."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[Vous avez terminé l'expédition et allez quitter le groupe dans %d secondes.

Dites au revoir !]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[Vous avez terminé la quête et allez quitter le groupe dans %d secondes.

Dites au revoir !]=]
L["WQGF_CANCEL"] = "Annuler"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "Cette expédition ne peut pas être effectuée en groupe."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "Ce type d'expédition ne peut pas être effectué en groupe."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Accepter automatiquement les invitations aux groupes WQGF lorsque vous n'êtes pas en combat"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Acceptera automatiquement les invitations aux groupes lorsque le joueur n'est pas en combat"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Acceptation automatique des invitations de groupe"
L["WQGF_CONFIG_AUTOINVITE"] = "Invitation automatique"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Inviter tout le monde automatiquement"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Chaque joueur inscrit sera automatiquement invité dans le groupe, dans une limite de 5 joueurs"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "Inviter les utilisateurs de WQGF automatiquement"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "Les utilisateurs de World Quest Group Finder seront automatiquement invités dans le groupe"
L["WQGF_CONFIG_BINDING_ADVICE"] = "N'oubliez pas que vous pouvez assigner le bouton de WQGF à une touche à partir du menu Raccourcis de WoW !"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Rechercher un groupe parmi toutes les langues (ignorer la sélection de langues de l'outil LFG)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Recherchera toujours tous les groupes disponibles peu importe leur langue"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Filtre de langue lors de la recherche"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "Message de WQFG à la connexion"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "Cacher le message d'initialisation de WQGF à la connexion"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "N'affichera plus le message de WQFG à la connexion"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Lancer automatiquement la recherche si vous n'êtes pas déjà dans un groupe"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "Un groupe sera automatiquement recherché lors de l'entrée dans une nouvelle zone d'expédition"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Activer la détection des nouvelles zones d'expédition"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "Une proposition de recherche de groupe vous sera faite en entrant dans une nouvelle zone d'expédition"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "Ne pas proposer si déjà groupé pour une autre expédition"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Proposer de rechercher un groupe en entrant dans une zone d'expédition pour la première fois"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Vous est présenté par Robou, EU-Hyjal"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Activer les notifications au groupe"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "Un message sera envoyé au groupe lorsque l'expédition sera terminée"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Notifier le groupe lorsque l'expédition est terminée"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Eviter de rejoindre des groupes sur des serveurs JcJ"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Evitera de rejoindre des groupes sur des serveurs JcJ (ce paramètre est ignoré sur les personnages de serveurs JcJ)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "Serveurs JcJ"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Activer le support des quêtes classiques"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Activer ceci ajoutera un bouton permettant de rechercher un groupe pour les quêtes supportées"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Support des quêtes classiques"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Activer le mode silencieux"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "Lorsque le mode silencieux est activé, seuls les messages de WQGF les plus importants sont affichés"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Mode silencieux"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Quitter le groupe automatiquement au bout de 10 secondes"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Le groupe sera quitté automatiquement au bout de 10 secondes après avoir terminé une expédition"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Activer le dialogue de fin d'expédition"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "Il vous sera proposé de quitter le groupe ou le désinscrire lorsque l'expédition sera terminée"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Afficher un dialogue pour quitter le groupe lorsque l'expédition est terminée"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Configuration du personnage:"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "L'identifiant de l'expédition actuelle est |c00bfffff%s"
L["WQGF_DEBUG_MODE_DISABLED"] = "Le mode debug est maintenant désactivé."
L["WQGF_DEBUG_MODE_ENABLED"] = "Le mode debug est maintenant activé."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "Aucune expédition en cours."
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "Zones d'expéditions rencontrées durant la session:"
L["WQGF_DELIST"] = "Désinscrire"
L["WQGF_DROPPED_WB_SUPPORT"] = "Le support des expéditions de World Boss a été supprimé dans WQGF 0.21.3. Veuillez utiliser le bouton de l'interface par défaut pour chercher un groupe."
L["WQGF_FIND_GROUP_TOOLTIP"] = "Trouver un groupe avec WQGF"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Clic du milieu pour créer un nouveau groupe"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Cliquez sur le bouton pour rejoindre le groupe"
L["WQGF_FRAME_APPLY_DONE"] = "Vous êtes inscrit à tous les groups disponibles."
L["WQGF_FRAME_CLICK_TWICE"] = "Cliquez %d fois sur le bouton pour créer un groupe."
L["WQGF_FRAME_CREATE_WAIT"] = "Vous pourrez créer un groupe si personne ne répond."
L["WQGF_FRAME_FOUND_GROUPS"] = "%d groupe(s) trouvé(s). Cliquez sur le bouton pour vous inscrire."
L["WQGF_FRAME_GROUPS_LEFT"] = "Encore %d groupe(s), continuez à cliquer !"
L["WQGF_FRAME_INIT_SEARCH"] = "Cliquez sur le bouton pour initialiser la recherche"
L["WQGF_FRAME_NO_GROUPS"] = "Aucun groupe trouvé, cliquez sur le bouton pour en créer un nouveau."
L["WQGF_FRAME_RELIST_GROUP"] = "Cliquez sur le bouton pour réinscrire le groupe"
L["WQGF_FRAME_SEARCH_GROUPS"] = "Cliquez sur le bouton pour rechercher un groupe..."
L["WQGF_GLOBAL_CONFIGURATION"] = "Configuration globale:"
L["WQGF_GROUP_CREATION_ERROR"] = "Une erreur a été rencontrée lors de la tentative de création d'un nouveau groupe. Merci de réessayer."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "Votre groupe a arrêté de faire la quête |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "Votre groupe a arrêté de faire l'expédition |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "Votre groupe effectue à présent la quête |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "Votre groupe effectue à présent la quête |c00bfffff%s|c00ffffff. Vous avez déjà terminé cette quête."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "Votre groupe effectue à présent la quête |c00bfffff%s|c00ffffff. Vous n'êtes pas éligible pour effectuer cette quête."
L["WQGF_GROUP_NOW_DOING_WQ"] = "Votre groupe effectue à présent l'expédition |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "Votre groupe effectue à présent l'expédition |c00bfffff%s|c00ffffff. Vous avez déjà terminé cette expédition."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "Votre groupe effectue à présent l'expédition |c00bfffff%s|c00ffffff. Vous n'êtes pas éligible pour effectuer cette expédition."
L["WQGF_INIT_MSG"] = "Cliquez avec le bouton du milieu de la souris sur une expédition dans la fenêtre de suivi des objectifs afin de rechercher un groupe."
L["WQGF_JOINED_WQ_GROUP"] = "Vous avez rejoint le groupe de |c00bfffff%s|c00ffffff's pour |c00bfffff%s|c00ffffff. Amusez-vous bien !"
L["WQGF_KICK_TOOLTIP"] = "Retirer tous les joueurs se trouvant trop loin"
L["WQGF_LEADERS_BL_CLEARED"] = "La blacklist des chefs de groupe a été vidée."
L["WQGF_LEAVE"] = "Quitter"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "Le membre du groupe %s se trouve à %s mètres. Utilisez le bouton de kick automatique pour le retirer du groupe."
L["WQGF_NEW_ENTRY_CREATED"] = "Un nouveau groupe a été créé pour |c00bfffff%s|c00ffffff."
L["WQGF_NO"] = "Non"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "Aucune de vos inscriptions pour |c00bfffff%s|c00ffffff n'a reçu de réponse dans les temps. Tentative de recherche d'un nouveau groupe..."
L["WQGF_NO_APPLY_BLACKLIST"] = "Vous n'avez pas été inscrit à %d groupe(s) car leur chef de groupe était dans la blacklist. Vous pouvez utiliser |c00bfffff/wqgf unbl |c00ffffffpour vider la blacklist."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "Vous n'êtes pas le chef du groupe."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[Vous avez terminé la quête.

Souhaitez-vous quitter le groupe ?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Vous avez terminé la quête.

Souhaitez-vous quitter le groupe ou le désinscrire de l'outil recherche de groupe ?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffATTENTION:|c00ffffff Ce groupe est en mode raid, ce qui signifie que vous ne serez pas en mesure d'effectuer des quêtes et expéditions. Vous devriez demander au chef de groupe de revenir en mode Groupe si cela est possible. Le retour en mode Groupe sera automatiquement effectué si vous devenez le chef de groupe."
L["WQGF_REFRESH_TOOLTIP"] = "Trouver un autre groupe"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Rechercher ou créer un groupe"
L["WQGF_SEARCHING_FOR_GROUP"] = "Recherche d'un groupe pour l'expédition |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Recherche d'un groupe pour la quête |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffCommandes slash (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Ouvre la configuration de l'addon"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Vide la blacklist des chefs de groupe"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : inverse le paramètre de détection des expéditions"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[Vous êtes actuellement déjà groupé pour une autre quête.

Êtes-vous sûr de vouloir en commencer une nouvelle ?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[Vous êtes actuellement déjà groupé pour une autre expédition.

Êtes-vous sûr de vouloir en commencer une nouvelle ?]=]
L["WQGF_STAY"] = "Rester"
L["WQGF_STOP_TOOLTIP"] = "Arrêter de faire cette expédition"
L["WQGF_TRANSLATION_INFO"] = "Traduction française par Robou (EU-Hyjal)"
L["WQGF_USER_JOINED"] = "Un utilisateur de World Quest Group Finder a rejoint le groupe !"
L["WQGF_USERS_JOINED"] = "Des utilisateurs de World Quest Group Finder ont rejoint le groupe !"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[Vous êtes entré dans une nouvelle zone d'expédition, mais vous êtes déjà groupé pour une autre expédition.

Souhaitez-vous quitter votre groupe et en rechercher un autre pour "%s" ?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[Vous êtes entré dans une nouvelle zone d'expédition.

Souhaitez-vous rechercher un groupe pour "%s" ?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[Vous avez terminé l'expédition.

Souhaitez-vous quitter le groupe ?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Vous avez terminé l'expédition.

Souhaitez-vous quitter le groupe ou le désinscrire de l'outil recherche de groupe ?"]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "Vous avez annulé votre inscription au groupe de |c00bfffff%s|c00ffffff' pour l'expédition |c00bfffff%s|c00ffffff. WQGF n'essaiera plus de rejoindre ce groupe jusqu'à ce que vous ne vous reconnectiez ou que vous vidiez la blacklist des chefs de groupe."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Automatiquement créé par World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "Vous n'êtes pas dans la bonne zone pour cette expédition."
L["WQGF_YES"] = "Oui"
L["WQGF_ZONE_DETECTION_DISABLED"] = "La détection des expéditions est maintenant désactivée."
L["WQGF_ZONE_DETECTION_ENABLED"] = "La détection des expéditions est maintenant activée."
