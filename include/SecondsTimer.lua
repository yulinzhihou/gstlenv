-- 秒级心跳脚本[测试]
-- by 心语难诉 2020-9-22 16:03:33 V1
-- by 心语难诉 2021-1-15 14:39:46 V2

-- 脚本ID
x666898_g_scriptId	= 666898
--**********************************
--交互入口
--**********************************
function x666898_OnCharacterTimer( sceneId, objId, dataId, uTime )
	-- 只有ScriptGlobal中开启的GM在线工具才会生效
	if GMDATA_ISOPEN_GMTOOLS == 1 then
		-- 通过API获取最新数据写入到SecondsTimerData.txt
		execute("cd /home/tlbb/Server/SecondsTimer;wget -q 'http://你的域名或者IP/index.php?privateKey=你在PHP文件中配置的验证KEY' -O SecondsTimerData.txt")
		-- 每次只获取第一行数据
		local SecondsTimerData = openfile("./SecondsTimer/SecondsTimerData.txt", "r")
		local DataStr = read(SecondsTimerData, "*l")
		closefile(SecondsTimerData)
		-- 执行相关事件开始
		if DataStr ~= nil then
			local _,_,id,event,param1,param2,param3,param4 = strfind(DataStr,"(.*),(.*),(.*),(.*),(.*),(.*)")
			if event == 'SendGlobalNews' then -- 发公告
				x666898_SendGlobalNews(sceneId, param1)
			end
			if event == 'GivePlayerItem' then -- 发物品
				x666898_GivePlayerItem(sceneId, param1, param2, param3)
			end
			if event == 'SetPlayerLevel' then -- 设置人物等级
				x666898_SetPlayerLevel(sceneId, param1, param2)
			end
			if event == 'GivePlayerYuanBao' then -- 发元宝
				x666898_GivePlayerYuanBao(sceneId, param1, param2)
			end
		end
		if DataStr ~= nil then
			local _,_,id,event,param1,param2,param3,param4 = strfind(DataStr,"(.*),(.*),(.*),(.*),(.*),(.*)")
			local SecondsTimerLog = openfile("./SecondsTimer/SecondsTimerLog.txt", "a+")
			write(SecondsTimerLog, "["..date('%Y-%m-%d %H:%M:%S').."][id]:"..id..",[Event]："..event..",[Param1]："..param1..",[Param2]："..param2..",[Param3]："..param3..",[Param4]："..param4.."\n")
			closefile(SecondsTimerLog)
		end
		-- 执行相事件结束
	end
end

--**********************************
--根据玩家名称获得主城场景内指定玩家的objId [后续更新]
--**********************************
function x666898_GetScenePlayerObjId(PlayerName)
	local sceneIdList = {
		0, -- 洛阳
		1, -- 苏州
		2, -- 大理
		186, -- 楼兰
	}
	local sId = ''
	local objId = ''

	--检测玩家是否在某个场景
	for _, tmpSceneId in sceneIdList do
		local RenNum = LuaFnGetCopyScene_HumanCount(tmpSceneId)
		for i=0, RenNum-1 do
			local EveryBodyID = LuaFnGetCopyScene_HumanObjId(tmpSceneId, i)	  --取得当前场景里人的objId
			if GetName(tmpSceneId, EveryBodyID) == PlayerName then
				sId = tmpSceneId
				objId = EveryBodyID
				break
			end
		end
		if sId ~= nil then
			break
		end
	end

	if objId == nil then
		objId = 0
	end

	return objId
end


--**********************************
--设置等级
--**********************************
function x666898_SetPlayerLevel(sceneId, PlayerName, level)
	local RenNum = LuaFnGetCopyScene_HumanCount( sceneId )
	for i=0, RenNum-1 do
		local EveryBodyID = LuaFnGetCopyScene_HumanObjId( sceneId, i )	  --取得当前场景里人的objId
		if GetName(sceneId, EveryBodyID) == PlayerName then
			SetLevel(sceneId, EveryBodyID, level)
			LuaFnSendSpecificImpactToUnit(sceneId, EveryBodyID, EveryBodyID, EveryBodyID, 49, 0)
			x666898_tips(sceneId, EveryBodyID, '管理员为您提升等级成功！')
			break
		end
	end
end

--**********************************
--给予玩家物品
--**********************************
function x666898_GivePlayerItem(sceneId, PlayerName, itemId, num)
	local RenNum = LuaFnGetCopyScene_HumanCount( sceneId )
	for i=0, RenNum-1 do
		local EveryBodyID = LuaFnGetCopyScene_HumanObjId( sceneId, i )	  --取得当前场景里人的objId
		if GetName(sceneId, EveryBodyID) == PlayerName then
			BeginAddItem(sceneId)
			AddItem(sceneId, itemId, num)
			EndAddItem(sceneId,EveryBodyID)
			AddItemListToHuman(sceneId,EveryBodyID)
			LuaFnSendSpecificImpactToUnit(sceneId, EveryBodyID, EveryBodyID, EveryBodyID, 49, 0)
			x666898_tips(sceneId, EveryBodyID, '管理员为您发放物品，请在背包中查收！')
			break
		end
	end
end

--**********************************
--给予玩家元宝
--**********************************
function x666898_GivePlayerYuanBao(sceneId, PlayerName, yuanbaoNum)
	local RenNum = LuaFnGetCopyScene_HumanCount( sceneId )
	for i=0, RenNum-1 do
		local EveryBodyID = LuaFnGetCopyScene_HumanObjId( sceneId, i )	  --取得当前场景里人的objId
		if GetName(sceneId, EveryBodyID) == PlayerName then
			YuanBao(sceneId,EveryBodyID,-1,1,yuanbaoNum)
			LuaFnSendSpecificImpactToUnit(sceneId, EveryBodyID, EveryBodyID, EveryBodyID, 49, 0)
			x666898_tips(sceneId, EveryBodyID, '管理员为您发放元宝：'..yuanbaoNum..' ,请注意查收！')
			break
		end
	end
end

--**********************************
--发送全局滚动公告
--**********************************
function x666898_SendGlobalNews(sceneId, notice)
	local noticeFormat = format ("@*;SrvMsg;SCA:"..notice)
	AddGlobalCountNews(sceneId,noticeFormat)
end

--**********************************
--提示函数
--**********************************
function x666898_tips(sceneId, selfId, Tip)
	BeginEvent(sceneId)
	AddText(sceneId, Tip)
	EndEvent(sceneId)
	DispatchMissionTips(sceneId, selfId)
end