<?php
error_reporting(-1);

// CONFIG

$mysql_host = "localhost";
$mysql_user = "user";
$mysql_pass = "";
$mysql_dtbs = "bacongamejam-01";

// END OF CONFIG

$link = mysql_connect($mysql_host,$mysql_user,$mysql_pass) or die('Could not connect: ' . mysql_error());
mysql_select_db($mysql_dtbs) or die('Could not select database');
$input = json_decode(stripslashes(@$_GET['i']));
$data = new stdClass();
if(isset($input->uid)){
  if(isset($input->left) and isset($input->right)){
    if($input->left){
      $v_x = -200;
    } elseif($input->right){
      $v_x = 200;
    } else {
      $v_x = 0;
    }
    $query = "UPDATE `users` SET 
    x = x + v_x * ('".microtime(1)."' - `lastupdate`),
    y = y + v_y * ('".microtime(1)."' - `lastupdate`),
    `v_x` =  '$v_x', `lastupdate` = '".microtime(1)."' WHERE  `uid` =  '".$input->uid."'";
    mysql_query($query) or die('Query failed: ' . mysql_error());
  }
  $query = "SELECT * FROM users WHERE `uid` = '".$input->uid."'";
  $result = mysql_query($query) or die('Query failed: ' . mysql_error());
  $user = mysql_fetch_array($result, MYSQL_ASSOC);
  if($user['health'] < 0){
    $data->console = "Points: ".$user['points'];
    $query3 = "UPDATE  `users` SET  `health` = `maxhealth`, `x` = 400, points = 0 WHERE  `uid` = '".$input->uid."'";
    mysql_query($query3) or die('Query failed: ' . mysql_error());
  }
}

if(isset($input->space)){
  if($input->space){
    if(microtime(1)-$user['lastbullet']>0.25){
      $query3 = "UPDATE  `users` SET  `lastbullet` = ".microtime(1)." WHERE  `uid` = '".$input->uid."'";
      mysql_query($query3) or die('Query failed: ' . mysql_error());
      $query = "INSERT INTO  `objects` (`type` ,`lastupdate` ,`x` ,`y` ,`v_x` ,`v_y`) VALUES ('bullet',  '".microtime(1)."',  '".($user['x']+32)."',  '".($user['y']-32)."',  '0',  '-300');";
      mysql_query($query) or die('Query failed: ' . mysql_error());
      $query = "INSERT INTO  `objects` (`type` ,`lastupdate` ,`x` ,`y` ,`v_x` ,`v_y`) VALUES ('bullet',  '".microtime(1)."',  '".($user['x']-32)."',  '".($user['y']-32)."',  '0',  '-300');";
      mysql_query($query) or die('Query failed: ' . mysql_error());
    }
  }
  $query = "UPDATE `objects` SET 
  x = x + v_x * ('".microtime(1)."' - `lastupdate`),
  y = y + v_y * ('".microtime(1)."' - `lastupdate`),
  `lastupdate` = '".microtime(1)."' WHERE 1";
  mysql_query($query) or die('Query failed: ' . mysql_error());
}
//cleanup bullets
$query = "DELETE FROM `objects` WHERE `y` < -128 or `y` > 728";
mysql_query($query) or die('Query failed: ' . mysql_error());

$query = 'SELECT SUM(points) FROM users WHERE '.microtime(1).' - lastupdate < 2';
$result = mysql_query($query) or die('Query failed: ' . mysql_error());
$line = mysql_fetch_array($result, MYSQL_ASSOC);
$pointsum = $line['SUM(points)'];

$query = "SELECT COUNT(*) FROM `objects` WHERE `type` = 'enemy'";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());
$line = mysql_fetch_array($result, MYSQL_ASSOC);
if( $line['COUNT(*)'] < ($pointsum/100 + 10) ){
  $query = "INSERT INTO  `objects` ( `type` , `lastupdate` , `x` ,  `y` ,  `v_x` , `v_y` ) VALUES (  'enemy',  '".microtime(1)."',  '".rand(32,800-32)."',  '-127',  '0',  '100' )";
  mysql_query($query) or die('Query failed: ' . mysql_error());
}

$query = "SELECT * FROM `objects` WHERE `type` = 'enemy'";
$result = mysql_query($query) or die('Query failed: ' . mysql_error());
while($line = mysql_fetch_array($result, MYSQL_ASSOC)){
  $query2 = "SELECT * FROM `objects` WHERE `type` = 'bullet'";
  $result2 = mysql_query($query2) or die('Query failed: ' . mysql_error());
  while($line2 = mysql_fetch_array($result2, MYSQL_ASSOC)){
    if(distance($line,$line2) < 32){
      $query3 = "DELETE FROM `objects` WHERE `id` = '".$line['id']."' or `id` = '".$line2['id']."'";
      mysql_query($query3) or die('Query failed: ' . mysql_error());
      $query3 = "UPDATE  `users` SET  `points` = `points` + 1 WHERE  `uid` = '".$input->uid."'";
      mysql_query($query3) or die('Query failed: ' . mysql_error());
    }
  }
  
  $query2 = 'SELECT * FROM users WHERE '.microtime(1).' - lastupdate < 2';
  $result2 = mysql_query($query2) or die('Query failed: ' . mysql_error());
  while($line2 = mysql_fetch_array($result2, MYSQL_ASSOC)){
    if(distance($line,$line2) < 64){
      $query3 = "UPDATE  `users` SET  `health` = `health` - 1 WHERE  `uid` = '".$input->uid."'";
      mysql_query($query3) or die('Query failed: ' . mysql_error());
      $query3 = "DELETE FROM `objects` WHERE `id` = '".$line['id']."'";
      mysql_query($query3) or die('Query failed: ' . mysql_error());
    }
  }
}

function distance($obj1,$obj2){
  $dx = $obj1['x']-$obj2['x'];
  $dy = $obj1['y']-$obj2['y'];
  return sqrt($dx*$dx + $dy*$dy);
}

if(@$input->cmd == "info"){
  $data->uid = md5(uniqid()."salt");
  $data->console = "Welcome to seppi's server! ".uniqid();
  $query = "INSERT INTO `users` (`uid` ,`health` ,`maxhealth` ,`lastupdate` ,`x` ,`y` ,`v_x` ,`v_y`) VALUES
  ('".$data->uid."',  '5',  '5',  '".microtime(1)."',  '400',  '550',  '0',  '0')";
  mysql_query($query) or die('Query failed: ' . mysql_error());
} elseif(@$input->cmd == "pull") {
  $query = 'SELECT * FROM users WHERE '.microtime(1).' - lastupdate < 2';
  $console = 
  $result = mysql_query($query) or die('Query failed: ' . mysql_error());
  $data->players = array();
  while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
    if($line['uid'] == $input->uid){
      $data->health = (int)$line['health'];
      $data->maxhealth = (int)$line['maxhealth'];
      $data->points = (int)$line['points'];
      $data->pointsum = (int)$pointsum;
      $data->x = (int)($line['x'] + $line['v_x']*(microtime(1)-$line['lastupdate']));
      $data->y = (int)($line['y'] + $line['v_y']*(microtime(1)-$line['lastupdate']));
      $data->v_x = (int)$line['v_x'];
      $data->v_y = (int)$line['v_y'];
    } else {
      $player = new stdClass();
      $player->x = (int)($line['x'] + $line['v_x']*(microtime(1)-$line['lastupdate']));
      $player->y = (int)($line['y'] + $line['v_y']*(microtime(1)-$line['lastupdate']));
      $player->v_x = (int)$line['v_x'];
      $player->v_y = (int)$line['v_y'];
      $data->players[] = $player;
    }
  }
  if(count($data->players) == 0){
    unset($data->players);
  }
  mysql_free_result($result);
  $query = 'SELECT * FROM objects';
  $result = mysql_query($query) or die('Query failed: ' . mysql_error());
  $data->enemies = array();
  $data->bullets = array();
  while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
    if($line['type'] == "bullet"){
      $bullet = new stdClass();
      $bullet->x = (int)$line['x'];
      $bullet->y = (int)$line['y'];
      $bullet->v_x = (int)($line['v_x'] + $line['v_x']*(microtime(1)-$line['lastupdate']));
      $bullet->v_y = (int)($line['v_y'] + $line['v_y']*(microtime(1)-$line['lastupdate']));
      $data->bullets[] = $bullet;
    } else {
      $enemy = new stdClass();
      $enemy->x = (int)$line['x'];
      $enemy->y = (int)$line['y'];
      $enemy->v_x = (int)($line['v_x'] + $line['v_x']*(microtime(1)-$line['lastupdate']));
      $enemy->v_y = (int)($line['v_y'] + $line['v_y']*(microtime(1)-$line['lastupdate']));
      $data->enemies[] = $enemy;
    }
  }
  if(count($data->bullets) == 0){
    unset($data->bullets);
  }
  if(count($data->enemies) == 0){
    unset($data->enemies);
  }
  mysql_free_result($result);
  mysql_close($link);
}
echo json_encode($data);
?>
