<?php

/**
 * [TextFileData] 
 * 
 * [说明：
 * 天龙文本数据操作类，用于在线GM工具
 * 二次开发扩展类。也可以单独使用]
 * 
 * @autho 雨林之后 <yulinzhihou@qq163.com>
 * @date 2025-04-16
 */
class TextFileData
{
    /**
     * [$gemInfo 宝石数据]
     * @var [array]
     */
    public static $gemInfo;

    /**
     * [$commonItem 物品数据]
     * @var [array]
     */
    public static $commonItem;

    /**
     * [$equipBase 装备数据]
     * @var [array]
     */
    public static $equipBase;

    /**
     * [$allItem 所有数据]
     * @var [array]
     */
    public static $allItem;

    /**
     * [TEXT_FILE_PATH 文本数据常量]
     */
    const TEXT_FILE_PATH = [
        'gemInfo'    => '/tlgame/tlbb/Public/Config/GemInfo.txt',
        'commonItem' => '/tlgame/tlbb/Public/Config/CommonItem.txt',
        'equipBase'  => '/tlgame/tlbb/Public/Config/EquipBase.txt',
    ];

    /**
     * [init 初始化文本数据]
     */
    public static function init()
    {
        self::$gemInfo    = self::getGemList();
        self::$commonItem = self::getEquipList();
        self::$equipBase  = self::getCommonItemList();
        self::$allItem  = array_merge(self::$gemInfo, self::$commonItem, self::$equipBase);
    }

    /**
     * [getGemList 获取宝石列表]
     *
     * @param   [type]  $readNums      [$readNums 读取个数，默认0 = 所有]
     *
     * @return  [type]                 [return 宝石数组]
     */
    public static function getGemList($readNums = 0)
    {
        $textDataFile = fopen(self::TEXT_FILE_PATH['gemInfo'], 'r');
        // 已读取行数
        $readedNumbs = 0;
        // 储存数组
        $itemList = [];
        // 循环读取
        while ($data = fgetcsv($textDataFile)) {
            if ($readNums != 0 && $readedNumbs > $readNums) {
                break;
            }
            $item = explode('	', $data[0]);
            if (is_numeric($item[0])) {
                $itemList[] = [
                    'id' => $item[0],
                    'itemName' => $item[7]
                    // 'itemName' => iconv('gbk', 'utf-8', $item[7])
                ];
            }
            $readedNumbs++;
        }
        fclose($textDataFile);
        return $itemList;
    }

    /**
     * [getEquipList 获取装备列表]
     *
     * @param   [type]  $readNums      [$readNums 读取个数，默认0 = 所有]
     *
     * @return  [type]                 [return 装备数组]
     */
    public static function getEquipList($readNums = 0)
    {
        $textDataFile = fopen(self::TEXT_FILE_PATH['equipBase'], 'r');
        // 已读取行数
        $readedNumbs = 0;
        // 储存数组
        $itemList = [];
        while ($data = fgetcsv($textDataFile)) {
            if ($readNums != 0 && $readedNumbs > $readNums) {
                break;
            }
            $item = explode('	', $data[0]);
            if (is_numeric($item[0])) {
                $itemList[] = [
                    'id' => $item[0],
                    'itemName' => $item[10]
                    // 'itemName' => iconv('gbk', 'utf-8', $item[10])
                ];
            }
            $readedNumbs++;
        }
        fclose($textDataFile);
        return $itemList;
    }

    /**
     * [getCommonItemList 获取装备列表]
     *
     * @param   [type]  $readNums      [$readNums 读取个数，默认0 = 所有]
     *
     * @return  [type]                 [return 物品数组]
     */
    public static function getCommonItemList($readNums = 0)
    {
        $textDataFile = fopen(self::TEXT_FILE_PATH['commonItem'], 'r');
        // 已读取行数
        $readedNumbs = 0;
        // 储存数组
        $itemList = [];
        while ($data = fgetcsv($textDataFile)) {
            if ($readNums != 0 && $readedNumbs > $readNums) {
                break;
            }
            $item = explode('	', $data[0]);
            if (is_numeric($item[0])) {
                $itemList[] = [
                    'id' => $item[0],
                    'itemName' => $item[6]
                    // 'itemName' => iconv('gbk', 'utf-8', $item[6])
                ];
            }
            $readedNumbs++;
        }
        fclose($textDataFile);
        return $itemList;
    }

    /**
     * [search description]
     * @param   [type]  $item  [$item 搜索内容 ID或者名称]
     *
     * @return  [type]         [return 物品数组]
     */
    public static function search($item)
    {
        $tempList = [];
        if (is_numeric($item)) {
            $type = 'id';
        } else {
            $type = 'itemName';
        }
        foreach (self::$allItem as $key => $value) {
            // 如果是通过ID搜索，那么必然只会有一个结果，查询到后直接break
            if ($type == 'id' && $value['id'] == $item) {
                $tempList[] = $value;
                break;
            }
            // 如果是通过名称搜索，那么模糊查询可能有多个结果，依次循环取出
            if ($type == 'itemName' && strpos($value['itemName'], $item) !== false) {
                $tempList[] = $value;
            }
        }
        return $tempList;
    }
}
// 文本数据操作类初始化
// TextFileData::init();
// 获取记录文本数据存放路径
// $res = TextFileData::TEXT_FILE_PATH;
// 获取宝石列表
// $res = TextFileData::getGemList();
// 获取装备列表
// $res = TextFileData::getEquipList(20);
// 获取物品列表
// $res = TextFileData::getCommonItemList(20);
// 获取所有物品列表(用于搜索)
// $res = TextFileData::$allItem;
// 搜索物品
// $res = TextFileData::search('重楼甲');