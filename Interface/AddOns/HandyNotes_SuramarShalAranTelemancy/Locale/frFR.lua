-- $Id: frFR.lua 27 2017-05-14 14:37:20Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_SuramarShalAranTelemancy", "frFR", false)

if not L then return end

if L then
L["AddOn Settings"] = "Paramètres de l'addon"
L["Entrance"] = "Entrée"
L["Entrance of %s"] = "Entrée de %s"
L["Fountain"] = "Fontaine"
L["Garden"] = "Jardin"
L["Great Eagle"] = "Grand Aigle"
L["HandyNotes - Suramar & Shal'Aran Telemancy"] = "HandyNotes - Télémancie de Suramar et Shal'Aran"
L["Icon Alpha"] = "Transparence de l'icône"
L["Icon Scale"] = "Taille de l'icône"
L["Icon settings"] = "Paramètres de l'icône"
L["Ignore in-/out-door"] = "Ignorer intérieur/extérieur"
L["Ignore whether it is currently indoor or outdoor, show all nodes."] = "Montrer toutes les balises, en intérieur et extérieur"
L["Leyline Entrances"] = "Entrées des lignes telluriques"
L["Library"] = "Bibliothèque"
L["Outside of The Drift"] = "Extérieur de La Congère"
L["Portal"] = "Portail"
L["Portal to %s"] = "Portail vers %s"
L["Query from server"] = "Requête du serveur"
L["Reset hidden nodes"] = "Réinitialiser les balises cachées"
L["Send query request to server to lookup NPC's localized name. May be a little bit slower for the first time lookup but would be very fast once the name is found and cached."] = "Envoyer une requête au serveur pour chercher le nom du PNJ dans votre langue. Peut être lent lors de la première recherche mais devrait être très rapide une fois le nom trouvé et mis en cache"
L["Shal'Aran Portals"] = "Portails de Shal'Aran"
L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."] = "Montre toutes les balises manuellement cachées par clic droit -> \"cacher\""
L["Show entrances which lead to the leyline."] = "Afficher les entrées menant à la ligne tellurique"
L["Show note"] = "Afficher la note"
L["Show portals inside Shal'Aran."] = "Afficher les portails à l'intérieur de Shal'Aran."
L["Show Telemetry Lab related telemancies, mainly quest related from Oculeth's quest: \"The Delicate Art of Telemancy\"."] = "Afficher les chemins de télémancie du Laboratoire de Télémétrie, principalement lié à la quête \"L’art délicat de la télémancie\" donnée par Oculeth."
L["Show the entrances which are not specified more precisely."] = "Afficher les entrées qui ne sont pas indiquées plus précisément."
L["Show the entrances which lead to known caves or space."] = "Afficher les entrées menant aux grottes ou lieux connus."
L["Show the node's additional notes when it's available."] = "Montre les notes additionnelles de la balise quand disponnible"
L["Shows the telemancy between Shal'Aran and nodes in Suramar"] = "Affiche les chemins de télémancie entre Shal'Aran et les balises de Suramar"
L["Specified Entrances"] = "Entrées indiquées"
L["Storage"] = "Entrepôt"
L["Suramar & Shal'Aran Telemancy"] = "Télémancie de Suramar et Shal'Aran"
L[ [=[Telemancy to: 
  - Garden]=] ] = [=[Télémancie vers:
- Jardin]=]
L[ [=[Telemancy to: 
  - Storage]=] ] = [=[Télémancie vers:
- Entrepôt]=]
L[ [=[Telemancy to: 
  o Fountain]=] ] = [=[Télémancie vers:
o Fontaine]=]
L[ [=[Telemancy to: 
  o Fountain
  o Warp Lab
  - Library]=] ] = [=[Télémancie vers:
o Fontaine
o Laboratoire Dimensionnel
- Bibliothèque]=]
L[ [=[Telemancy to: 
  o Garden
  - Test Chamber]=] ] = [=[Télémancie vers:
o Jardin
- Chambre de Test]=]
L[ [=[Telemancy to: 
  o Telemetry Lab
  o Garden
  x Breakfast Nook]=] ] = [=[Télémancie vers:
o Laboratoire Télémétrique
o Jardin
x Coin petit-déjeuner]=]
L[ [=[Telemancy to: 
  o Workshop]=] ] = [=[Télémancie vers:
o Atelier]=]
L["Telemetry Lab"] = "Laboratoire Télémétrique"
L["Teleportation Nexus"] = "Nexus de téléportation"
L["The alpha transparency of the icons"] = "La transparence (alpha) des icônes"
L["The scale of the icons"] = "La taille des icônes"
L["These settings control the look and feel of the icon."] = "Ces paramètres contrôlent l'apparence de l'icône"
L["These settings control what type of icons to be displayed."] = "Ces paramètres contrôlent quel type d'icône doit être affiché."
L["Unspecified Entrances"] = "Entrées non indiquées"
L["Warp Lab"] = "Laboratoire dimensionnel"
L["What to display"] = "Ce qu'il faut afficher"

-- ToC
L["Description"] = "Affiche les chemins de télémancie entre Shal'Aran et les balises de Suramar"
L["Title"] = "HandyNotes - Télémancie de Suramar et Shal'Aran"

end
