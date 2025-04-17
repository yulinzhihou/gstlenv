<?php

/**
 * RedisSingle - 单文件Redis操作类
 * 要求：1. PHP安装redis扩展 2. Redis服务器已启动
 */
class RedisSingle
{
    private $redis;
    private $config = [
        'host'       => 'gsredis',
        'port'       => 6379,
        'password'   => '',
        'database'   => 0,
        'timeout'    => 0,
        'persistent' => false
    ];

    public function __construct(array $config = [])
    {
        if (!extension_loaded('redis')) {
            throw new RuntimeException('Redis extension is not installed');
        }

        $this->config = array_merge($this->config, $config);
        $this->redis = new \Redis();
        $this->connect();
    }

    private function connect()
    {
        try {
            if ($this->config['persistent']) {
                $this->redis->pconnect(
                    $this->config['host'],
                    $this->config['port'],
                    $this->config['timeout']
                );
            } else {
                $this->redis->connect(
                    $this->config['host'],
                    $this->config['port'],
                    $this->config['timeout']
                );
            }

            if (!empty($this->config['password'])) {
                $this->redis->auth($this->config['password']);
            }

            if ($this->config['database'] != 0) {
                $this->redis->select($this->config['database']);
            }
        } catch (\RedisException $e) {
            throw new RuntimeException('Redis connection failed: ' . $e->getMessage());
        }
    }

    private function _checkConnection()
    {
        try {
            $this->redis->ping();
        } catch (RedisException $e) {
            $this->connect();
        }
    }

    //---------------- String 操作 -----------------
    public function set(string $key, $value, int $ttl = 0)
    {
        $this->_checkConnection();
        if ($ttl > 0) {
            return $this->redis->setex($key, $ttl, $value);
        }
        return $this->redis->set($key, $value);
    }

    public function get(string $key)
    {
        $this->_checkConnection();
        return $this->redis->get($key);
    }

    public function incr(string $key, int $step = 1)
    {
        $this->_checkConnection();
        return $step === 1 ? $this->redis->incr($key) : $this->redis->incrBy($key, $step);
    }

    public function decr(string $key, int $step = 1)
    {
        $this->_checkConnection();
        return $step === 1 ? $this->redis->decr($key) : $this->redis->decrBy($key, $step);
    }

    //---------------- List 操作 -----------------
    public function lPush(string $key, $value)
    {
        $this->_checkConnection();
        return $this->redis->lPush($key, $value);
    }

    public function rPush(string $key, $value)
    {
        $this->_checkConnection();
        return $this->redis->rPush($key, $value);
    }

    public function lPop(string $key)
    {
        $this->_checkConnection();
        return $this->redis->lPop($key);
    }

    public function rPop(string $key)
    {
        $this->_checkConnection();
        return $this->redis->rPop($key);
    }

    public function lRange(string $key, int $start = 0, int $end = -1)
    {
        $this->_checkConnection();
        return $this->redis->lRange($key, $start, $end);
    }

    //---------------- Set 操作 -----------------
    public function sAdd(string $key, $value)
    {
        $this->_checkConnection();
        return $this->redis->sAdd($key, $value);
    }

    public function sRem(string $key, $value)
    {
        $this->_checkConnection();
        return $this->redis->sRem($key, $value);
    }

    public function sMembers(string $key)
    {
        $this->_checkConnection();
        return $this->redis->sMembers($key);
    }

    public function sIsMember(string $key, $value)
    {
        $this->_checkConnection();
        return $this->redis->sIsMember($key, $value);
    }

    //---------------- Hash 操作 -----------------
    public function hSet(string $key, string $field, $value)
    {
        $this->_checkConnection();
        return $this->redis->hSet($key, $field, $value);
    }

    public function hGet(string $key, string $field)
    {
        $this->_checkConnection();
        return $this->redis->hGet($key, $field);
    }

    public function hGetAll(string $key)
    {
        $this->_checkConnection();
        return $this->redis->hGetAll($key);
    }

    public function hDel(string $key, string $field)
    {
        $this->_checkConnection();
        return $this->redis->hDel($key, $field);
    }

    public function hIncrBy(string $key, string $field, int $increment = 1)
    {
        $this->_checkConnection();
        return $this->redis->hIncrBy($key, $field, $increment);
    }

    //---------------- 通用操作 -----------------
    public function expire(string $key, int $ttl)
    {
        $this->_checkConnection();
        return $this->redis->expire($key, $ttl);
    }

    public function exists(string $key)
    {
        $this->_checkConnection();
        return $this->redis->exists($key);
    }

    public function del(string $key)
    {
        $this->_checkConnection();
        return $this->redis->del($key);
    }

    //---------------- 事务操作 -----------------
    public function multi()
    {
        $this->_checkConnection();
        return $this->redis->multi();
    }

    public function exec()
    {
        $this->_checkConnection();
        return $this->redis->exec();
    }

    public function discard()
    {
        $this->_checkConnection();
        return $this->redis->discard();
    }

    //---------------- 其他方法 -----------------
    public function getRedisObject(): Redis
    {
        return $this->redis;
    }

    public function __destruct()
    {
        if ($this->redis instanceof Redis) {
            $this->redis->close();
        }
    }
}

/* 使用示例：
$redis = new RedisSingle(['password' => 'your_password']);

// String操作
$redis->set('name', 'John', 3600);
echo $redis->get('name');

// List操作
$redis->rPush('list', 'item1');
$redis->rPush('list', 'item2');
print_r($redis->lRange('list', 0, -1));

// Hash操作
$redis->hSet('user', 'name', 'Alice');
$redis->hSet('user', 'age', 30);
print_r($redis->hGetAll('user'));

// 事务操作
$redis->multi();
$redis->set('counter', 0);
$redis->incr('counter');
$redis->exec();
*/