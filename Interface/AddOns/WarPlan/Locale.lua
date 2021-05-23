local _, T = ...

local C, z, V, K = GetLocale(), nil
V =
    C == "deDE" and { -- 22/22 (100%)
      "%d |4Mission:Missionen; verfügbar", "%d |4Mission:Missionen; abgeschlossen", "%d laufende |4Mission:Missionen;", "%d |4Mission:Missionen; übrig", "%d |4Gruppe:Gruppen; übrig", "Missionskosten: %s", "Bonuswurfbelohnung", "Lösche alle geplanten Gruppen", "Abschließen", "Alle abschließen",
      "Vor %s abgeschlossen", "Noch verfügbar:", "BONUS erhalten!", "In geplanter Gruppe:", "Mission fehlgeschlagen", "Missions-Verlauf", "Mission erfolgreich", "Keine möglichen Gruppen", "Lädt das Inteface neu ohne %s zu starten bis zum nächsten Reload.", "Ergebnisse vergangener Missionen werden hier angezeigt.",
      "Zurück zum Blizzard UI", "Schicke geplante Gruppen",
    }
    or C == "esES" and { -- 22/22 (100%)
      "%d |4misión:misiones; disponibles", "%d |4misión:misiones; completadas", "%d |4misión:misiones; en progreso", "%d |4misión:misiones; restantes...", "%d |4grupo:grupos; restantes...", "Coste de misión base: %s", "Recompensa extra", "Limpiar todos los grupos tentativos", "Clic para completar", "Completar Todas",
      "Completada hace %s", "Expira en:", "Gran éxito", "En el Grupo Tentativo:", "Misión fallida", "Histórico de Misión", "Éxito en la misión", "No hay grupos viables.", "Recarga la interfaz y no actives %s hasta la próxima recarga.", "Los resultados de las misiones completadas se guardaran y se mostrarán aquí.",
      "Revertir a interfaz de Blizzard", "Enviar Grupos Tentativos",
    }
    or C == "frFR" and { -- 22/22 (100%)
      "%d |4mission:missions; |4disponible:disponibles", "%d |4mission:missions; |4terminée:terminées", "%d |4mission:missions; en cours", "%d |4mission:missions; |4restante:restantes ...", "%d |4groupe:groupes; |4restant:restants ...", "Coût de la mission: %s", "Récompense Bonus", "Effacer la sélection en cours", "Cliquer pour terminer", "Tout Terminer",
      "Terminé il y a %s", "Expire dans:", "Succès Total", "En Groupe:", "Mission Échouée", "Historique des Missions", "Mission Accomplie", "Aucun groupe adapté.", "Recharge l'interface et désactive %s jusqu'au prochain rechargement.", "L'historique des précédentes missions terminées sera enregistré et affiché ici.",
      "Revenir à l'UI de Blizzard", "Envoyer en mission",
    }
    or C == "itIT" and { -- 22/22 (100%)
      "%d |4 missione disponibile:missioni disponibili;", "%d |4 missione completata:missioni completate;", "%d |4 missione:missioni; in corso", "%d |4 missione rimanente:missioni rimanenti; ...", "%d |4 gruppo rimanente:gruppi rimanenti; ...", "Costo missione base: %s", "Ricompensa del tiro bonus", "Cancella tutti i gruppi provvisori", "Clicca per completare", "Completa tutto",
      "Completato %s fa", "Scade tra:", "Grande successo", "Nel gruppo provvisorio:", "Fallimento della missione", "Storia della missione", "Missione compiuta", "Nessun gruppo fattibile.", "Ricarica l'interfaccia e non attivare %s fino al successivo ricaricamento.", "I risultati delle missioni completate verranno registrati e visualizzati qui.",
      "Torna all'IU di Blizzard", "Invia i gruppi provvisori",
    }
    or C == "koKR" and { -- 22/22 (100%)
      "%d |4mission:missions; 수행 가능", "%d |4mission:missions; 완료", "%d |4mission:missions; 진행중", "%d |4mission:missions; 남음...", "%d |4party:parties; 남음...", "기본 임무 비용: %s", "보너스 굴림 보상", "임시 멤버 초기화", "임무 완료", "모든 임무 완료",
      "%s 전 완료됨", "만료:", "위대한 성공", "임시 그룹", "임무 실패", "임무 기록", "임무 성공", "생존 가능 그룹 없음", "UI 재시작 및 다음 재시작까지 %s 비활성화", "완료한 임무 결과를 이곳에서 확인 가능",
      "블리자드 UI로 복구", "임시 그룹 보내기",
    }
    or C == "ruRU" and { -- 22/22 (100%)
      "%d |4миссия доступна:миссии доступны:миссий доступно; ", "%d |4миссия завершена:миссии завершены:миссий завершено;", "%d |4миссия:миссии:миссий; в процессе ", "%d |4миссия:миссии:миссий; осталось....", "%d |4группа осталась:группы осталось:групп осталось;...", "Стоимость миссии: %s", "Награда бонусного броска", "Очистить все пробные группы", "Нажмите, чтобы завершить", "Завершить все",
      "Завершено %s назад", "Заканчивается через", "Грандиозный  успех", "В пробной группе:", "Миссия провалена", "История миссий ", "Миссия  выполнена", "Нет возможных групп", "Перезагрузить интерфейс и не активировать %s до следующей перезагрузки.", "Результаты выполненных миссий будут записаны и отображены здесь.",
      "Возврат к интерфейсу Blizzard ", "Отправить пробные группы",
    }
    or C == "zhCN" and { -- 22/22 (100%)
      "%d |4任务:任务; 可派遣", "%d |4任务:任务; 已完成", "%d |4任务:任务; 进行中", "%d |4任务:任务; 持续中...", "%d |4队伍:队伍; 持续中...", "花费：%s", "额外拾取", "清除所有预设队列", "点击完成", "一键完成",
      "%s 前", "有效期：", "大获全胜", "预设队列中：", "任务失败", "任务记录", "任务完成", "暂无可用队列", "重载界面并在下次重载前禁用%s", "这里显示已完成的任务记录。",
      "显示原生界面", "分配预设队列",
    }
    or C == "zhTW" and { -- 22/22 (100%)
      "%d |4任務:任務; 可用", "%d |4任務:任務; 完成", "%d |4任務:任務; 進行中", "%d |4任務:任務; 剩餘...", "%d |4隊伍:隊伍; 剩餘...", "基本任務花費: %s", "額外擲骰獎勵", "清除所有隊伍分派", "點擊以完成", "完成全部",
      "已在 %s 前完成", "過期於:", "大獲全勝", "在分派隊伍中:", "任務失敗", "任務歷史紀錄", "任務成功", "沒有可行的隊伍。", "重新載入介面，並在下次載入前不要啟用 %s。", "已完成任務的結果將被記錄並顯示在此處。",
      "恢復為暴雪內建UI", "派發分配隊伍",
    } or nil

K = V and {
      "%d |4mission:missions; available", "%d |4mission:missions; complete", "%d |4mission:missions; in progress", "%d |4mission:missions; remaining...", "%d |4party:parties; remaining...", "Base mission cost: %s", "Bonus roll reward", "Clear all tentative parties", "Click to complete", "Complete All",
      "Completed %s ago", "Expires in:", "Grand Success", "In Tentative Group:", "Mission Failure", "Mission History", "Mission Success", "No viable groups.", "Reload the interface and do not activate %s until next reload.", "Results of completed missions will be recorded and displayed here.",
      "Revert to Blizzard UI", "Send Tentative Parties",
}

local L = K and {}
for i=1,K and #K or 0 do
	L[K[i]] = V[i]
end

T.L = newproxy(true)
getmetatable(T.L).__call = function(_, k)
	return L and L[k] or k
end