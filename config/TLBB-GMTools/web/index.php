<?php
session_start();
header("Content-type: text/html; charset=utf8");
header("Cache-Control: no-cache");
header("Pragma: no-cache");

require_once 'Angular.php';
require_once 'Db.php';
require_once 'RedisSingle.php';
require_once 'GMTools.php';
require_once 'TextFileData.php';

/**
 *====================================================
 *====================================================
 * 业务流程开始
 *====================================================
 *====================================================
 */

// 初始化 GmTools
$GmTools = new GmTools;
$redis = new RedisSingle;

// 正常抓取流程
if (isset($_GET['privateKey']) && !empty($_GET['privateKey'])) {
	// 获取最新未执行事件
	$privateKey = $_GET['privateKey'];
	$res = GmTools::fetchLastEvent($privateKey);
	echo $res;
	exit;
} else {
	$view = new Angular(GmTools::$templateConfig);
	if (!@$_SESSION['user']) {
		// 登录流程
		if (empty($_POST['password'])) {
			$view->display('login');
		} else {
			if ($_POST['password'] == GmTools::$loginPassworld) {
				$_SESSION['user'] = 'Admin';
				echo json_encode(['status' => 'success']);
			} else {
				echo json_encode(['status' => 'fail']);
			}
			exit;
		}
	} else if ($_SESSION['user'] && isset($_GET['r']) && !empty($_GET['r'])) {
		$r = $_GET['r'];
		if ($r == 'addEvent') {
			// 非抓取事件
			if ($_POST['event'] == 'AddGamePoint') {
				$res = GmTools::AddGamePoint($_POST['param1'], $_POST['param2']);
			} else {
				$res = GmTools::addEvent([
					'event'			=> $_POST['event'],
					'eventnote'		=> iconv('utf-8', 'gbk', $_POST['eventnote']),
					'createtime'	=> time(),
					'status'		=> 0,
					'param1'		=> iconv('utf-8', 'gbk', $_POST['param1']),
					'param2'		=> iconv('utf-8', 'gbk', $_POST['param2']),
					'param3'		=> iconv('utf-8', 'gbk', $_POST['param3']),
					'param4'		=> iconv('utf-8', 'gbk', $_POST['param4']),
				]);
			}
			echo $res;
			exit;
		} elseif ($r == 'clearAllEvents') {
			$res = GmTools::delAllEvents();
			echo $res;
			exit;
		} elseif ($r == 'quickLogin') {
			unset($_SESSION['user']);
			echo json_encode(['status' => 'success']);
			exit;
		} elseif ($r == 'searchAll') {
			$item = urldecode($_GET['item']);
			$item = iconv('utf-8', 'gbk', $item);
			$res = GmTools::searchAll($item);
			foreach ($res as $key => $value) {
				$res[$key]['itemName'] = urlencode(iconv('gbk', 'utf-8', $value['itemName']));
			}
			echo json_encode($res);
			exit;
		}
	} else {
		// 首页
		$eventsList = [
			'发公告' => 'SendGlobalNews',
			'充值点数' => 'AddGamePoint',
			'发物品' => 'GivePlayerItem',
			'设置人物等级' => 'SetPlayerLevel',
			'发元宝' => 'GivePlayerYuanBao',
		];
		$res = GmTools::fetchAllEvents();
		$view->assign('eventsList', $eventsList);
		$view->assign('list', $res);
		$view->display('index');
	}
}
