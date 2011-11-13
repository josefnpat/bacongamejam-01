<?php
$input = json_decode(stripslashes($_GET['i']));
if($input->cmd == "info"){
  $data = new stdClass();
  $data->uid = md5(uniqid()."salt");
  $data->console = "Welcome to seppi's server! ".uniqid();
  echo json_encode($data);
} elseif($input->cmd == "pull"){
  $decode = json_decode($_GET['i']);
  $data = new stdClass();
  $data->health = 100;
  $data->maxhealth = 100;
  $data->enemies = array();
  $enemy = new stdClass();
  $enemy->x = 10;
  $enemy->y = 10;
  $enemy->v_x = 10;
  $enemy->v_y = 10;
  $data->enemies[] = $enemy;
  $data->bullets = array();
  $bullet->x = 10;
  $bullet->y = 10;
  $bullet->v_x = 10;
  $bullet->v_y = 10;
  $data->bullets[] = $bullet;
  $data->players = array();
  $player->x = 10;
  $player->y = 10;
  $player->v_x = 10;
  $player->v_y = 10;
  $data->players[] = $player;
  echo json_encode($data);
} else {
  $data = new stdClass();
  $data->uid = md5(uniqid()."salt");
  $data->console = $_GET['i'];
}
