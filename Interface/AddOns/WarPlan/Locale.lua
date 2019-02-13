local L, _, T = GetLocale(), ...

local z, V = nil
V = L == "ruRU" and {
		"%d |4миссия доступна:миссии доступны:миссий доступно;", "%d |4миссия завершена:миссии завершено:миссий завершено;", "%d |4миссия:миссии:миссий; в процессе", "%d |4миссия:миссии:миссий; осталось...", "%d |4група осталась:групы осталось:груп осталось;...", "Стоимость миссии: %s", "Награда бонусного броска", "Очистить все пробные групы", "Нажмите, чтобы завершить", "Завершить все",
		"Завершено %s назад", "Заканчивается в", "Грандиозный  успех", "В пробной группе:", "Миссия провалена", "История миссий", "Миссия  выполнена", "Нет возможных групп", "Перезагрузит интерфейс и не активирует %s до следующей перезагрузки.", "Результаты выполненных миссий будут записаны и отображены здесь.",
		"Возврат к интерфейсу Blizzard", "Отправить пробные групы",
	}
	or L == "zhCN" and {
		"%d |4任务:任务; 可派遣", "%d |4任务:任务; 已完成", "%d |4任务:任务; 进行中", "%d |4任务:任务; 持续中...", "%d |4队伍:队伍; 持续中...", "花费：%s", "额外拾取", "清除所有预设队列", "点击完成", "一键完成",
		"%s 前", "有效期：", "大获全胜", "预设队列中：", "任务失败", "任务记录", "任务完成", "暂无可用队列", "重载界面并在下次重载前禁用%s", "这里显示已完成的任务记录。",
		"显示原生界面", "分配预设队列",
	}
	or L == "zhTW" and {
		"%d |4任務:任務; 可用", "%d |4任務:任務; 完成", "%d |4任務:任務; 進行中", "%d |4任務:任務; 剩餘...", "%d |4隊伍:隊伍; 剩餘...", "基本任務花費: %s", "額外擲骰獎勵", "清除所有隊伍分派", "點擊以完成", "完成全部",
		"已在 %s 前完成", "過期於:", "大獲全勝", "在分派隊伍中:", "任務失敗", "任務歷史紀錄", "任務成功", "沒有可行的隊伍。", "重新載入介面，並在下次載入前不要啟用 %s。", "已完成任務的結果將被記錄並顯示在此處。",
		"恢復為暴雪內建UI", "派發分配隊伍",
	}
L = V and {
	["%d |4mission:missions; available"]=V[1],
	["%d |4mission:missions; complete"]=V[2],
	["%d |4mission:missions; in progress"]=V[3],
	["%d |4mission:missions; remaining..."]=V[4],
	["%d |4party:parties; remaining..."]=V[5],
	["Base mission cost: %s"]=V[6],
	["Bonus roll reward"]=V[7],
	["Clear all tentative parties"]=V[8],
	["Click to complete"]=V[9],
	["Complete All"]=V[10],
	["Completed %s ago"]=V[11],
	["Expires in:"]=V[12],
	["Grand Success"]=V[13],
	["In Tentative Group:"]=V[14],
	["Mission Failure"]=V[15],
	["Mission History"]=V[16],
	["Mission Success"]=V[17],
	["No viable groups."]=V[18],
	["Reload the interface and do not activate %s until next reload."]=V[19],
	["Results of completed missions will be recorded and displayed here."]=V[20],
	["Revert to Blizzard UI"]=V[21],
	["Send Tentative Parties"]=V[22],
} or nil

T.L = newproxy(true)
getmetatable(T.L).__call = function(_, k)
	return L and L[k] or k
end