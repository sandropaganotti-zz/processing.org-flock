class Creature {
 int sng_x;
 int sng_y;
 float sng_x_speed;
 float sng_y_speed;
 
 Creature(){
   sng_x = 0;
   sng_y = 0;
   sng_x_speed = 0;
   sng_y_speed = 0;
 }

 float calc_dist(Creature k){
   return sqrt(pow(this.sng_x - k.sng_x,2) + pow(this.sng_y - k.sng_y,2));
 } 
 void to_text(){
   println("X: " + sng_x + " Y: " + sng_y);
 }
}


int canvas_width  = 400;
int canvas_height = 400;
int min_separation = 15;
int circle_size = 5;
int num_sheep = 100;
int max_noise = 250;
int mint_follow_x = 0;
int mint_follow_y = 0;
int follow_amount = 100;
float max_speed_variance = 0.001;
float min_speed = 0.005;
float max_speed = 0.01;

Creature[] flock = new Creature[num_sheep]; 

void setup(){
  int i;
  int j;
  boolean bln_separation;
  size(canvas_width,canvas_height);
  
  for(int x=0; x < flock.length; x++){
    bln_separation = false;
    flock[x] = new Creature();
    while(!bln_separation){
      flock[x].sng_x = int(random(1,canvas_width));
      flock[x].sng_y = int(random(1,canvas_height));
      bln_separation = true;
      for(int y=0; y < x; y++){
        if(flock[x].calc_dist(flock[y]) <= min_separation){
          bln_separation = false;
          break;
        }
      }
    }
  }
}

void draw(){
  background(100);
  float sng_dist;
  float sng_x_speed = 0.0;
  float sng_y_speed = 0.0;
  int sng_x_sum;
  int sng_y_sum;
  float sng_x_avg;
  float sng_y_avg;
  float sng_x_dist;
  float sng_y_dist;
  int sng_tmp_x;
  int sng_tmp_y;
  
  for(int x=0; x < flock.length; x++){
    sng_dist = 0;
    for(int y=0; y < flock.length; y++){    
      if(x!=y){
        if(sng_dist == 0.0 || flock[x].calc_dist(flock[y]) < sng_dist){
          sng_dist = flock[x].calc_dist(flock[y]);
          sng_x_speed = flock[y].sng_x_speed;
          sng_y_speed = flock[y].sng_y_speed;
        }
      }
    }
    
    flock[x].sng_x_speed = sng_x_speed + max_speed_variance;
    flock[x].sng_y_speed = sng_y_speed + max_speed_variance;
    if(flock[x].sng_x_speed < min_speed) flock[x].sng_x_speed = min_speed;
    if(flock[x].sng_y_speed < min_speed) flock[x].sng_y_speed = min_speed;
    if(flock[x].sng_x_speed > max_speed) flock[x].sng_x_speed = max_speed;
    if(flock[x].sng_y_speed > max_speed) flock[x].sng_y_speed = max_speed;
    
    sng_x_sum = 0;
    sng_y_sum = 0;
    for(int y=0; y < flock.length; y++){
      sng_x_sum = sng_x_sum + flock[y].sng_x;
      sng_y_sum = sng_y_sum + flock[y].sng_y;
    }
    
    sng_x_avg = float(sng_x_sum / num_sheep) + (random(1) * max_noise) - (max_noise / 2.0) + mint_follow_x;
    sng_y_avg = float(sng_y_sum / num_sheep) + (random(1) * max_noise) - (max_noise / 2.0) + mint_follow_y;  
    
    sng_tmp_x = flock[x].sng_x;
    sng_tmp_y = flock[x].sng_y;
    sng_x_dist = sng_x_avg - flock[x].sng_x;
    sng_y_dist = sng_y_avg - flock[x].sng_y;
    flock[x].sng_x = int(flock[x].sng_x + sng_x_dist * flock[x].sng_x_speed);
    flock[x].sng_y = int(flock[x].sng_y + sng_y_dist * flock[x].sng_y_speed);

    for(int y=0; y < flock.length; y++){
      if( x!=y && flock[x].calc_dist(flock[y]) <= min_separation ){
        flock[x].sng_x = sng_tmp_x;
        flock[x].sng_y = sng_tmp_y;
        break;
      }
    }
    
    if(flock[x].sng_x > canvas_width) flock[x].sng_x = flock[x].sng_x - canvas_width;
    if(flock[x].sng_x < 0) flock[x].sng_x = flock[x].sng_x + canvas_width;
    if(flock[x].sng_y > canvas_height) flock[x].sng_y = flock[x].sng_y - canvas_height;
    if(flock[x].sng_y < 0) flock[x].sng_y = flock[x].sng_y + canvas_height;
    
     ellipse(flock[x].sng_x,flock[x].sng_y,circle_size,circle_size);
  }  
}

void keyPressed() {
  if (key == 'w') mint_follow_y = mint_follow_y - follow_amount;
  if (key == 's') mint_follow_y = mint_follow_y + follow_amount;   
  if (key == 'a') mint_follow_x = mint_follow_x - follow_amount;
  if (key == 'd') mint_follow_x = mint_follow_x + follow_amount;
}

