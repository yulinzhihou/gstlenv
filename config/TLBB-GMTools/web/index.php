<?php

/**
 * GmTools
 */
class GmTools
{
	/**
	 * [$loginPassworld 登录密码]
	 */
	public static $loginPassworld = '123123';

	/**
	 * [$privateKey 私密KEY]
	 * [服务端请求事件时必须与私密KEY对应才能请求成功事件]
	 */
	private static $privateKey = 'Gsgameshare.comPass';

	/**
	 * [$dbConfig GM工具数据库配置]
	 */
	private static $dbConfig = [
		'hostname'     => "gsmysql",
		'dbname'       => 'web',
		'username'     => 'root',
		'password'     => '123456',
		'prefix'       => '',
		'charset'      => 'utf8'
	];

	/**
	 * [$webDbConfig 账号数据库配置]
	 */
	private static $webDbConfig = [
		'hostname'     => "gsmysql",
		'dbname'       => 'web',
		'username'     => 'root',
		'password'     => '123456',
		'prefix'       => '',
		'charset'      => 'utf8'
	];

	/**
	 * [$templateConfig 后台系统模板配置项]
	 */
	public static $templateConfig = [
		'debug'            => true,
		'tpl_path'         => './templates/',
		'tpl_suffix'       => '.html',
		'tpl_cache_path'   => './templates/cache/',
		'tpl_cache_suffix' => '.php',
		'attr'             => 'php-',
		'max_tag'          => 10000,
	];

	/**
	 * [$DB 初始化账号数据库变量]
	 */
	private static $webDB = null;

	/**
	 * [$DB 初始化GM工具数据库配置]
	 */
	private static $DB = null;

	/**
	 * [__construct 初始化类时实例化数据库]
	 */
	public function __construct()
	{
		if (!(self::$DB instanceof Db)) {
			self::$DB = Db::getInstance(self::$dbConfig);
		}
		if (!(self::$webDB instanceof Db)) {
			self::$webDB = Db::getInstance(self::$webDbConfig);
		}
	}


	/**
	 * [addEvent 添加执行事件]
	 * @param   [arr]  $data  [事件参数]
	 * @return  [json]        [反馈添加事件的结果]
	 */
	public static function addEvent($data)
	{
		$res = self::$DB->create('eventlist', $data);
		return $res >= 1
			? self::return_json('success', 'addEvent Success')
			: self::return_json('fail', 'addEvent Fail!');
	}

	/**
	 * [fetchAllEvents 获取所有事件列表]
	 */
	public static function fetchAllEvents()
	{
		$res = self::$DB->fetchAll('eventlist', ['order' => ['id', 'desc']]);
		return $res;
	}

	/**
	 * [fetchLastEvent 获取最新一条未执行事件]
	 */
	public static function fetchLastEvent($privateKey)
	{
		if ($privateKey != self::$privateKey) {
			return '';
		}
		$res = self::$DB->fetch('eventlist', [
			'where'  => [
				['status', '=', 0]
			],
			'order' => ['id', 'desc']
		]);
		self::$DB->update('eventlist', ['status' => '1', 'requesttime' => time()], [
			'where' => [['id', '=', $res['id']]]
		]);
		if (!empty($res)) {
			$res = "{$res['id']},{$res['event']},{$res['param1']},{$res['param2']},{$res['param3']},{$res['param4']}";
		} else {
			$res = '';
		}
		return $res;
	}

	/**
	 * [AddGamePoint 充值游戏点数]
	 */
	public static function AddGamePoint($userAccount, $point)
	{
		$oldPoint = self::$webDB->getColumn('account', 'point', [
			'where'  => [
				['name', '=', $userAccount . '@game.sohu.com']
			]
		]);
		// 添加点数
		self::$webDB->update('account', ['point' => $oldPoint + $point], [
			'where' => [
				['name', '=', $userAccount . '@game.sohu.com']
			]
		]);
		// 添加非执行事件
		$addEvent = self::addEvent([
			'event'            => 'AddGamePoint',
			'eventnote'        => '充值点数',
			'createtime'    => time(),
			'requesttime'     => time(),
			'status'        => 1,
			'param1'        => iconv('utf-8', 'gbk', $userAccount . '@game.sohu.com'),
			'param2'        => iconv('utf-8', 'gbk', $point),
			'param3'        => "发放人：{$_SESSION['user']}",
			'param4'        => 0,
		]);
		echo $addEvent;
	}

	/**
	 * [searchAll 查询接口]
	 * @param   [type]  $item  [$item 查询条件，可以是ID，也可以是物品名称，模糊搜索]
	 */
	public static function searchAll($item)
	{
		TextFileData::init();
		// $res = TextFileData::search($item);
		return TextFileData::search($item);
	}

	/**
	 * [delAllEvents 清空事件日志]
	 */
	public static function delAllEvents()
	{
		$res = self::$DB->delete('eventlist', ['where' => [['status', '>=', 0]]]);
		return $res >= 1
			? self::return_json('success', 'delete AllEvents Success')
			: self::return_json('fail', 'delete AllEvents Fail!');
	}

	/**
	 * [return_json 返回json数据]
	 * @param   [str]$status   [返回状态]
	 * @param   [str]$message  [返回信息]
	 * @param   [arr]$data     [数组,如果有的话]
	 * @return  [json]         [json]
	 */
	private static function return_json($status, $message, $data = [])
	{
		return json_encode(['status' => $status, 'message' => $message, 'data' => $data]);
	}
}
