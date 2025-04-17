<?php
/**
 * EasyAPI PHP Framework
 * Db操作类 (MYSQL PDO)
 * @author  Wigiesen <[<wigiesen.cn@gmail.com>]>
 */

class Db
{
	private static $instance;
	private $db;

	private function __construct($config){
		if (!empty($config['hostname'])) {
	        try {
	            $this->dsn = 'mysql:host='.$config['hostname'].';dbname='.$config['dbname'];
	            $this->db = new PDO($this->dsn, $config['username'], $config['password']);
	            $this->db->exec('SET character_set_connection='.$config['charset'].', character_set_results='.$config['charset'].', character_set_client=binary');
	            $this->db->exec("SET NAMES ".$config['charset']);
	        } catch (PDOException $e) {
	            $this->printError($e->getMessage());
	        }
		}
	}

	/**
	 * [getInstance 单例唯一实例化]
	 * @param  [type] $config [description]
	 * @return [type]         [description]
	 */
	public static function getInstance($config){
        // if(!(self::$instance instanceof self)){
            self::$instance = new self($config);
        // }
        return self::$instance;
	}

	/**
	 * [create 新增数据]
	 * @param  [type] $table [description]
	 * @param  array  $data  [description]
	 * @return [type]        [description]
	 */
	public function create($table, $data = []){
		$sql = "INSERT INTO `$table` (`".implode('`,`', array_keys($data))."`) VALUES ('".implode("','", $data)."')";
		$result = $this->db->exec($sql);
		$this->getError();
		return $this->db->lastInsertId();
	}

	/**
	 * [update 修改数据]
	 * @param  [type] $table     [description]
	 * @param  array  $data      [description]
	 * @param  array  $condition [description]
	 * @return [type]            [description]
	 */
	public function update($table, $data = [], $condition = []){
		$sql = '';
        foreach ($data as $key => $value) {
            $sql .= ", `$key`='$value'";
        }
        $sql = substr($sql, 1);
		if (!empty($condition)) {
			extract($this->bulidSQL($condition));
            $sql = "UPDATE `$table` SET {$sql} {$where} {$group} {$having} {$order}";
		}else{
			$sql = "UPDATE `$table` SET {$sql}";
		}
		$result = $this->db->exec($sql);
		$this->getError();
		return $result;
	}

	/**
	 * [delete 删除数据]
	 * @param  [type] $table     [description]
	 * @param  array  $condition [description]
	 * @return [type]            [description]
	 */
	public function delete($table, $condition = []){
		if (!empty($condition)) {
			extract($this->bulidSQL($condition));
			$sql = "DELETE FROM `$table` {$where} {$group} {$having} {$order}";
			$result = $this->db->exec($sql);
			$this->getError();
			return $result;
		}else{
			$this->printError('condition is Null');
		}
	}

	/**
	 * [getColumn 获取但个字段数据]
	 * @param  [type] $table     [description]
	 * @param  [type] $column    [description]
	 * @param  array  $condition [description]
	 * @return [type]            [description]
	 */
	public function getColumn($table, $column, $condition = []){
		if (!empty($column)) {
			extract($this->bulidSQL($condition));
			$result = $this->db->query("SELECT {$column} FROM `{$table}` {$where} {$group} {$having} {$order} limit 1", PDO::FETCH_ASSOC);
			$result = $result->fetch();
			return $result[$column];
		}else{
			$this->printError('column is Null');
		}
	}

	/**
	 * [fetch 读取一行数据]
	 * @param  [type] $table     [description]
	 * @param  array  $fields    [description]
	 * @param  array  $condition [description]
	 * @return [type]            [description]
	 */
	public function fetch($table, $condition = []){
		extract($this->bulidSQL($condition));
		$result = $this->db->query("SELECT {$fields} FROM `{$table}` {$where} {$group} {$having} {$order} LIMIT 1", PDO::FETCH_ASSOC);
		if (!is_object($result)) {
			$result = [];
		}else{
			$result = $result->fetch();
		}
		$this->getError();
		return $result;
	}

	/**
	 * [fetchAll 获取全部数据]
	 * @param  [type] $table     [description]
	 * @param  array  $fields    [description]
	 * @param  array  $condition [description]
	 * @return [type]            [description]
	 */
	public function fetchAll($table, $condition = []){
		extract($this->bulidSQL($condition));
		$result = $this->db->query("SELECT {$fields} FROM `{$table}` {$where} {$group} {$having} {$order} {$limit}", PDO::FETCH_ASSOC);
		if (!is_object($result)) {
			$result = [];
		}else{
			$result = $result->fetchAll();
		}
		$this->getError();
		return $result;
	}

	public function query($sql, $mode = 'all'){
		$result = $this->db->query($sql, PDO::FETCH_ASSOC);
		if (!is_object($result)) {
			return [];
		}
		if ($mode == 'all') {
			$result = $result->fetchAll();
		}elseif ($mode == 'row') {
			$result = $result->fetch();
		}else{
			$this->printError('mode is false');
		}
		$this->getError();
		return $result;
	}

	/**
	 * [bulidSQL 生成SQL条件]
	 */
	private function bulidSQL($condition = []){
		$bulidSQL['fields'] = !empty($condition['fields']) ? implode(",", $condition['fields']) : '*';
		$bulidSQL['where']  = !empty($condition['where']) ? $this->condition($condition['where']) : '';
		$bulidSQL['group']  = !empty($condition['group']) ? 'GROUP BY '.implode(",", $condition['group']) : '';
		$bulidSQL['having'] = !empty($condition['having']) ? "HAVING {$condition['having'][0]} {$condition['having'][1]} {$condition['having'][2]}" : '';
		$bulidSQL['order']  = !empty($condition['order']) ? "ORDER BY {$condition['order'][0]} {$condition['order'][1]}" : '';
		$bulidSQL['limit']  = !empty($condition['limit']) ? "LIMIT {$condition['limit']}" : '';
		return $bulidSQL;
	}

	/**
	 * [condition WHERE条件处理]
	 * @param  [type] $condition [description]
	 * @return [type]            [description]
	 */
	private function condition($condition){
		$where = '';
		if (!empty($condition)) {
			foreach ($condition as $value) {
				$where .= "`".(string)$value[0]."` ".$value[1]." '".(string)$value[2]."' AND ";
			}
		}
		$where = "WHERE " . rtrim($where, ' AND ');
		return $where;
	}

	/**
	 * getPDOError 捕获PDO错误信息
	 */
	private function getError()
	{
	    if ($this->db->errorCode() != '00000') {
	        $error = $this->db->errorInfo();
	        $this->printError($error[2]);
	    }
	}

	/**
	 * [printError 输出异常信息]
	 * @param  [type] $ErrMsg [description]
	 * @return [type]         [description]
	 */
    private function printError($ErrMsg)
    {
        throw new Exception('MySQL Error: '.$ErrMsg);
    }

	private function __clone(){}
	
	public function __destruct(){
		$this->db = null;
	}
}