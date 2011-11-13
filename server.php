<?php
error_reporting(-1);
$input = json_decode(stripslashes($_GET['i']));
if($input->cmd == "info"){
  $data = new stdClass();
  $data->uid = md5(uniqid()."salt");
  $data->console = "Welcome to seppi's server! ".uniqid();
  echo json_encode($data);
} elseif($input->cmd == "pull"){
  $decode = json_decode($_GET['i']);
  $data = new stdClass();
  $data->health = time()%6;
  $data->maxhealth = 5;
  $data->x = 100;
  $data->y = 500;
  $data->v_x = 0;
  $data->v_y = 0;
  $data->time = microtime(1);
  $data->enemies = array();
  for($i = 0; $i < 10; $i++){
    $enemy = new stdClass();
    $enemy->x = rand(1,740);
    $enemy->y = rand(1,400);
    $enemy->v_x = rand(-100,100);
    $enemy->v_y = rand(-100,100);
    $data->enemies[] = $enemy;
  }
  $data->bullets = array();
  for($i = 0; $i < 1500; $i++){
    $bullet = new stdClass();
    $bullet->x = rand(1,780);
    $bullet->y = rand(1,900);
    $bullet->v_x = 0;
    $bullet->v_y = rand(-200,-500);
    $data->bullets[] = $bullet;
  }
  $data->players = array();
  $player = new stdClass();
  $player->x = 400;
  $player->y = 500;
  $player->v_x = 100;
  $player->v_y = 0;
  $data->players[] = $player;
  $player2 = clone $player;
  $player2->x = 100;
  $player2->v_x = -100;
  $data->players[] = $player2;
  echo json_encode($data);
} else {
  $data = new stdClass();
  $data->uid = md5(uniqid()."salt");
  $data->console = $_GET['i'];
}
