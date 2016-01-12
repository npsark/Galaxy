import damkjer.ocd.*;



Camera camera1;
PImage bloomImg;

int nArms = 4;
int nStars = 100;
float[][][][] stars = new float[nArms][360][nStars][5];

void setup() {
  size(500, 500, P3D);
  background(0);
  //noLoop();


  camera1 = new Camera(this, 0, 10, 10, 1, 10000);

  initBloom();

  float da = 360/nArms;
  for (int i=0; i<nArms; i++) {

    float r = 0;
    for (int j=0; j<360; j++) {

      float a = (j+i*da)*PI/180;
      r += 0.2;

      float spread = map(j, 0, 360, 1, 0.1);
      for (int k=0; k<nStars; k++) {

        float an = a+random(-1, 1)*1.1*spread;
        float rn = r+random(-1, 1)*10*spread;

        stars[i][j][k][0] = rn*cos(an);
        stars[i][j][k][1] = pow((sin(map(j, 0, 359, 0, PI))+1)/2, 2)*random(-1, 1)*5 + random(-1, 1)*sin(map(j, 0, 359, 0, PI))*5;
        stars[i][j][k][2] = rn*sin(an);

        if (random(1)<.01) {
          stars[i][j][k][3] = 2;
        } else {
          stars[i][j][k][3] = 0.5;
        }

        if (random(1)<0.01) {
          stars[i][j][k][4] = int(color(255, 0, 0));
        } else {
          stars[i][j][k][4] = int(color(  map(rn, 0, 75, 255, 0), map(rn, 0, 75, 255, 0), map(rn, 0, 75, 200, 50)   ));
        }
      }
    }
  }
}

void draw() {
  background(0);
  camera1.feed();

  noStroke();
  fill(0);
  sphere(7);

  rotateY(frameCount*.005);



  /*stroke(255);
   strokeWeight(1);
   for (int i=0; i<50000; i++) {
   float a = random(TWO_PI);
   float r = random(30);
   
   float density = map(r, 0, 30, 10, 1)*pow(noise((a*10)*0.1, r*.1)+.1,2);
   
   for (int k=0; k<round(density); k++) {
   float rippleR = 2;
   
   float an = a+random(-1, 1)*0.1;
   float rn = 2*r+random(-1, 1)*0.1;
   
   point( rn*cos(an), 3*(sin(r/4)/2 - 1)*random(-1, 1)*sqrt(pow(rippleR, 2) - pow(r%(rippleR*2)-rippleR, 2)), rn*sin(an));
   }
   }*/

  stroke(255);

  for (int i=0; i<stars.length; i++) {
    for (int j=0; j<stars[i].length; j++) {
      for (int k=0; k<stars[i][j].length; k++) {
        strokeWeight(stars[i][j][k][3]);
        stroke(int(stars[i][j][k][4]));
        point(stars[i][j][k][0], stars[i][j][k][1], stars[i][j][k][2]);
      }
    }
  }

  bloom(128, 2, 5, 1);
}




void bloom(int thresh, int blur, int res, int str) {
  bloomImg.resize(width, height);

  loadPixels();
  bloomImg.loadPixels();
  for (int i=0; i<bloomImg.pixels.length; i++) {
    color curr = pixels[i];
    if (brightness(curr) > thresh) {
      bloomImg.pixels[i] = curr;
    } else {
      bloomImg.pixels[i] = color(0);
    }
  }
  bloomImg.updatePixels();


  bloomImg.resize(width/res, height/res);
  bloomImg.filter(BLUR, blur);
  for (int k=0; k<str; k++) {
    bloomImg.blend(bloomImg, 0, 0, bloomImg.width, bloomImg.height, 0, 0, bloomImg.width, bloomImg.height, ADD);
  }
  blend(bloomImg, 0, 0, bloomImg.width, bloomImg.height, 0, 0, width, height, ADD);
}

void initBloom() {
  bloomImg = new PImage(width, height, RGB);

  bloomImg.loadPixels();
  for (int i=0; i<bloomImg.pixels.length; i++) {
    bloomImg.pixels[i] = color(0, 0, 0);
  }
  bloomImg.updatePixels();
}

float rnd() {
  if (random(1)<.5) {
    return -1;
  }
  return 1;
}

void keyPressed() {
  if (key=='w') {
    camera1.dolly( -1 );
  } else if (key=='s') {
    camera1.dolly( 1 );
  } else if (key=='a') {
    camera1.truck(-1);
  } else if (key=='d') {
    camera1.truck(1);
  } else if (key=='r') {
    camera1.aim(0,0,0);
  }
}

void mouseMoved() {
  //camera1.dolly( (mouseX-pmouseX)*-1 );
  //camera1.boom(mouseY - pmouseY);
  //camera1.arc(radians(mouseY - pmouseY));
  //camera1.circle(radians(1));
  //camera1.look(radians(mouseX - pmouseX) / 1.0, radians(mouseY - pmouseY) / 1.0);
  //camera1.tumble(radians(mouseX - pmouseX), radians(mouseY - pmouseY));
  camera1.pan(radians(mouseX - pmouseX) / 2.0);
  camera1.tilt(radians(mouseY - pmouseY) / 2.0);
}
