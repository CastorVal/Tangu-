import processing.serial.*;
Serial port;


//ESTA ES LA LIBRERÏA DE SONIDOS - Instalar Minim
import ddf.minim.*;

//Libreria para captura de imagen - Open CV 
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

//Instancia De la captura de imagen
Capture video;
OpenCV opencv;

//Instancia del sonido
Minim minim;
AudioPlayer amb; //para la musica de fondo 
AudioPlayer Titi; //Estos dos son los elementos para llamarlos abajo y que suene la música
AudioPlayer Guaca;
AudioPlayer CinematicaIntro;
AudioPlayer VozInicio;
AudioPlayer Tuto;
AudioPlayer win;
AudioPlayer lose;

//Variables Scena
//0 InterfazDeInicio
//1 EscogerTuPersonaje();
//2 TutorialDeMovimiento()
//3 Jugando
//4 Ganaste
//5 Perdiste

//PUERTA
int sensorPuerta;

PFont font;
//Fondos
PImage Fondo;
PImage Inicio;
PImage ganaron;
PImage perdieron;

//UI
PImage V1;
PImage V2;
PImage V3;
PImage UI;
float estadoVida[];

//Estado Escena
int Scene = 0;

//Botones
int BotonStart;
int BotonStartX;
int BotonStartY;
int btnsize=100;

//BotonMenu
int BotonMenu;
int BotonMenuX;
int BotonMenuY;
int btnMenusize=200;

//Guaca
PImage PlayerGuaca;
float PlayerGuacaX;
float PlayerGuacaY;

//Titi
PImage PlayerTiti;
float PlayerTitiX;
float PlayerTitiY;

//Frutas
PImage FrutaGuaca;
PImage FrutaTiti;
PImage RanaDorada;
float posXfruta[];
float posYfruta[];
float posXnaranja[];
float posYnaranja[];
float posXranaD[];
float posYranaD[];

//Mallas
PImage malla;
int mallaX= int(random(5,1675));
int mallaY=-20;
int estadoMalla [];
float distanciaMalla=0;
int mallaVel =1;
boolean activeMalla=true;
int soltarMalla=30;
int timeranas=80;


//vidas
int vida=3;


float velocidad=2;

//Puntaje
float distancia=110;
float distancia2=100;
float distancia3=100;
float distancia4=100;
float distancia5=0;
float distancia6=0;
float distancia7=0;
float distancia8=0;


int puntaje=0;
int puntajeRanas=0;
int estado[];

//Fondo Moviendose
int x1=0;
int x2=1680;

//Pwerdieron
int tiempoPerdieron=60;

void setup()
{  
  size(1680,1050);
  font= loadFont("font.vlw");
  
  //printArray (Serial.list());
  //PUERTO SERIAL ARDUINO
 port=new Serial(this,"/dev/cu.usbmodem1411",9600);
  
  
  //Fondos
  Fondo = loadImage("fondo.png");
  Inicio = loadImage("Inicio.png");
  ganaron= loadImage("ganaron.png");
  perdieron= loadImage("perdieron.png");
  
  
  //Jugadores
  PlayerGuaca = loadImage("Guaca.png");
  PlayerTiti = loadImage("Titi.png");
  FrutaGuaca = loadImage("FrutaGuaca.png");
  //frutaNaranja
  FrutaTiti = loadImage("naranja.png");
  //RanaDorada
  RanaDorada = loadImage("Rana.png");
  
  //Audio
  minim = new Minim(this);
  Guaca = minim.loadFile("mono.mp3"); 
  Titi = minim.loadFile("guacamaya.mp3"); 
  amb = minim.loadFile("Origami1.mp3"); 
  VozInicio = minim.loadFile("Bienvenida.mp3");
  Tuto=minim.loadFile("OrdenCompletaTutorial.mp3");
  win=minim.loadFile("13_HemosLlegadoALaSalida.mp3");
  lose=minim.loadFile("16_VuelveloAIntentar.mp3");
  
  //Captura De Video
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
    
  //Inicializar Fruta Fresa
  
    posXfruta= new float[100];
    posYfruta= new float[100];
     estado = new int[100]; //Numero de bolitas
      for (int i=0; i<100; i++)
      {
        posXfruta[i]=random (3000);
        posYfruta[i]=random (1000);
          estado [i]=1;
      }

  //Inicializar Fruta naranja
  
      posXnaranja= new float[100];
      posYnaranja= new float[100];
      estado = new int[100]; //Numero de bolitas
      for (int i=0; i<100; i++)
      {
       posXnaranja[i]=random (3360);
        posYnaranja[i]=random (700);
          estado [i]=1;
      }
      
  //Inicializar Rana Dorada
  
      posXranaD= new float[100];
      posYranaD= new float[100];
      estado = new int[100]; //Numero de ranas
      for (int i=0; i<100; i++)
      {
       posXranaD[i]=random (3360);
       posYranaD[i]=random (1100);
          estado [i]=1;
      }
          
      
   //Mallas
   estadoMalla = new int [100];
     
     for(int i=0; i<3; i++){
        
       malla = loadImage("red.png");
      image(malla,mallaX,mallaY,20,20);
        //ellipse(mallaX,mallaY,20,20);//malla
  
        estadoMalla[i]=1;
      }
      
      //arreglo de imagenes para UI de las vidas
      UI= loadImage("UI.png");
      V1= loadImage("0.png");
      V2= loadImage("1.png");
      V3= loadImage("2.png");
}
 
  

void draw()
{
   //Orienta las escenas a las que va a ir cuando oprima un boton
   if (Scene ==0){
    //InterfazDeInicio();
 Ganaste();
} 
    else if(Scene==1){
    EscogerTuPersonaje();}
    else if(Scene==2){
    TutorialDeMovimiento();}
    else if(Scene==3){
    Jugando();}
    else if(Scene==4){
    Ganaste();}
    else if(Scene==5){
    Perdiste();
  }
  
}



void InterfazDeInicio()
{  
  background(Inicio);
  //rect(255,455,85,52);
  botonComenzar(BotonStartX,BotonStartY);
  fill(25,36,52);
  VozInicio.play();
  win.pause();
  lose.pause();
  
}

void EscogerTuPersonaje()
{
  background(2,85,78);
}





 //VersionUltima
void TutorialDeMovimiento()
{
  VozInicio.pause();
  background(Fondo);
  fill(255,58,50);
  Tuto.play();
  int FrutaTutoX=1500;
  int FrutaTutoY=400;
  image(FrutaTiti,FrutaTutoX,FrutaTutoY);
  distancia7= dist (PlayerTitiX, PlayerTitiY,FrutaTutoX, FrutaTutoY);
  distancia8= dist (PlayerGuacaX, PlayerGuacaY,FrutaTutoX, FrutaTutoY);

       
       //comer
      if (distancia7<100)
      {
       Scene=3;
        } 
 
       //comer
      if (distancia8<100)
      {
       Scene=3;
        } 
 
  
  
  amb.play();
  image(PlayerGuaca,PlayerGuacaX,PlayerGuacaY);
  image(PlayerTiti,PlayerTitiX,PlayerTitiY);
  PlayerGuacaX=100;
  PlayerGuacaY=200;
  PlayerTitiX=100;
  PlayerTitiY=1000;
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
   for (int i = 0; i < faces.length; i++) {
  
    //Espejooo
    float comparar = map(faces[i].x,0,200,1685,0);    
    if(comparar<=842){
    float gX = map(faces[i].x,165,200,1685,0);
    float gY = map(faces[i].y,20,50,0,200);    
    PlayerGuacaX=gX;
    PlayerGuacaY=gY;    
    println(faces[i].x);
    }
    else if(comparar>842){      
     float lX = map(faces[i].x,0,35,1685,0);
     float lY = map(faces[i].y,-20,92,0,1050);     
     if(lY>=600){
        lY=600;
      }      
    PlayerTitiX=lX;
    PlayerTitiY=lY;
    println(faces[i].x);}  
    }
   scale(5.25); 
   opencv.loadImage(video);
}


  void Jugando(){
 
  //Fondo///////////////////  
  image(Fondo,x1,0,1680,1050);
  image(Fondo,x2,0,1680,1050);
  Tuto.pause();
  
  x1-=5;
  x2-=5;
  if(x1<-1680){
    x1=1680;
  }
  if(x2<-1680){
    x2=1680;
  }     
  ///Audio/////////////////////
  amb.play();
  //Jugadores
  image(PlayerGuaca,PlayerGuacaX,PlayerGuacaY);
  image(PlayerTiti,PlayerTitiX,PlayerTitiY);
  //Frutas
  
  /////Fruticas
   puntaje=0;   
    for( int i=0; i<10; i++)
    {    
      //fill(198,100,70);
       if(posXfruta[i]<40){
    posXfruta[i]=x1;
    
     
   if(estado[i]==0){
           estado[i]=1;
    }  
    
   // posYfruta[i]=x2;
    
    }
   if(posXnaranja[i]<40){
    posXnaranja[i]=x1;
   // posYfruta[i]=x2;
     if(estado[i]==0){
           estado[i]=1;
    }
    }
      
     // if(posXfruta[i]==0){
     //   posXfruta[i]=x1;
      //}
      
      posXfruta[i]=posXfruta[i]-velocidad; //+5 Velocidad 
      posXnaranja[i]=posXnaranja[i]-velocidad; //+5 Velocidad
      
      
      if(estado[i]==1)      
      {           
        //rect (posX[i], posY[i],50,30);
        image(FrutaGuaca,posXfruta[i], posYfruta[i]);
        image(FrutaGuaca,posXfruta[i], posYfruta[i]);
        image(FrutaTiti,posXnaranja[i], posYnaranja[i]);
        image(FrutaTiti,posXnaranja[i], posYnaranja[i]); 
        
      }      
      else 
      {
      puntaje=puntaje+1;      
      }              
   } 
   
   
   
   
   
   
 
   /////Ranas
   puntajeRanas=0;

   timeranas--;
   
      
     for( int i=0; i<5; i++)
    {
    if(posXranaD[i]<10){
    posXranaD[i]=x1;
   // posYfruta[i]=x2;   
    }
      posXranaD[i]=posXranaD[i]-velocidad; //+5 Velocidad          
      if(estado[i]==1)      
      {           
      
        //rect (posX[i], posY[i],50,30);
        image(RanaDorada,posXranaD[i], posYranaD[i]);
        image(RanaDorada,posXranaD[i], posYranaD[i]); 
       
     
   
      }      
      else 
      {
      puntajeRanas=puntajeRanas+1;      
      }              
   } 
     
   //COMER
    for( int i=0; i<100; i++)
    {   
      distancia= dist (PlayerGuacaX, PlayerGuacaY,posXfruta[i], posYfruta[i]);
      distancia2= dist (PlayerTitiX, PlayerTitiY,posXfruta[i], posYfruta[i]);
      distancia3= dist (PlayerGuacaX, PlayerGuacaY,posXnaranja[i], posYnaranja[i]);
      distancia4= dist (PlayerTitiX, PlayerTitiY,posXnaranja[i], posYnaranja[i]);
      distancia5= dist (PlayerGuacaX, PlayerGuacaY,posXranaD[i], posYranaD[i]);
      distancia6= dist (PlayerTitiX, PlayerTitiY,posXranaD[i], posYranaD[i]);
           
         //comer
      if (distancia<=50)
      {
       estado [i]=0;
       
       
        if(posXnaranja[i]<40){
        if(estado[i]==0){
           estado[i]=1;
    }
    }
       
       
       
       
       
       
       
       
            
        } 
        
     if (distancia2<=50)
      {
       estado [i]=0;
        } 
        
     if (distancia3<=50)
      {
       estado [i]=0;
        } 
        
     if (distancia4<=50)
      {
       estado [i]=0;
        }  
      
     if (distancia5<=50)
      {
       estado [i]=0;
        } 
        
     if (distancia6<=50)
      {
       estado [i]=0;
        }               
       
       
       
     }
   
   
    
      
    //código de puntaje
    fill(255);
    textFont(font,40);
    
    text("Frutas: "+puntaje,230,80);
    text("Ranas: "+puntajeRanas,50,80);
    text("Vida: "+vida,80,120);
    //volver a menu
    //rect(255,455,105,52);
    //botonMenu(BotonMenuX,BotonMenuY);
    //noStroke();
    //fill(25,36,52);
    
    //GanarJuego
    //if(puntajeRanas==3){
    //Scene=4;}
 
 //Mallas 
    
     soltarMalla--; //entra conteo de tiempo
     if(soltarMalla<=0){//inicio del metodo
      mallaY=mallaY+mallaVel; //caida malla
      for(int i=0; i<10;i++){
    if(estadoMalla[i]==1) {
       image(malla,mallaX,mallaY,100,100);
        //ellipse(mallaX,mallaY,50,50);//colocar malla
   }
  
   //personaje 1 malla
   if(mallaX<=PlayerTitiX && mallaX+50 >=PlayerTitiX && activeMalla){
     
      vida=vida-1;
        println("vida");
        activeMalla=false; //boolean malla
        mallaY=height+2;
        println("la altura es"+mallaY);
        if(vida==0){
        Scene=5;
        //vida=3;
    
    
  }
   }
  //personaje 2 malla 
  
     if(mallaX<=PlayerGuacaX && mallaX+50 >=PlayerGuacaX && activeMalla){
       
        vida=vida-1;
        println("vida");
         activeMalla=false; //boolean malla
         mallaY=height+2;
         println("la altura es"+mallaY);
        if(vida==0){
        Scene=5;
        vida=3;
        }
    }

  }
  
  if(mallaY>height){
    soltarMalla=30; //reinicio de variables
    activeMalla=true;
    mallaX= int(random(5,1675));
    mallaY=-20;
  }
     }
  
  //VidasUi
  image(UI,1450,70,180,50);
  
  if(vida==3){
    
    image(V1,1470,70,50,50);
    image(V2,1510,70,50,50);
    image(V3,1550,70,50,50);
  }
  
  if(vida==2){
    
    image(V1,1470,70,50,50);
    image(V2,1510,70,50,50);
   
  }
  
  if(vida==1){
    
    image(V1,1470,70,50,50);
   
  }
     
     
 //GanarJuego
    if(puntajeRanas==3|| puntaje==5){
    Scene=4;}
 
 //Camara abajo
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
   for (int i = 0; i < faces.length; i++) {
    //Espejooo
    float comparar = map(faces[i].x,0,200,1685,0);    
    if(comparar<=842){
    float gX = map(faces[i].x,165,200,1685,0);
    float gY = map(faces[i].y,20,92,0,100);    
    PlayerGuacaX=gX;
    PlayerGuacaY=gY;    
    println(faces[i].x);
    }
    else if(comparar>842){      
     float lX = map(faces[i].x,0,35,1685,0);
     float lY = map(faces[i].y,-20,92,0,1050);     
     if(lY>=600){
        lY=600;
      }
    PlayerTitiX=lX;
    PlayerTitiY=lY;
    println(faces[i].x);}
    }
   
    
   opencv.loadImage(video);
   
   scale(1); 
   image(video,0,800);
   Rectangle[] faces2 = opencv.detect();
   
    for (int i = 0; i < faces2.length; i++) {
    println(faces2[i].x + "," + faces2[i].y);
    rect(faces2[i].x, faces2[i].y, faces2[i].width, faces2[i].height);
  }
  
    
 }
  
    


void Perdiste()
{  

background(perdieron);
tiempoPerdieron--;
lose.play();

if(tiempoPerdieron<=0){
  //JugarDenuevo
  Scene=0;
  InterfazDeInicio();
 lose.pause();
}


}

void Ganaste()
{
  win.play();
   //if (port.available()<0) 
 // { 
    port.write(sensorPuerta);
    sensorPuerta=1;
    //sensorPuerta =  port.write(val[]);
    println(sensorPuerta);
    
    
   
 // }
  
 background(ganaron);
 tiempoPerdieron--;

if(tiempoPerdieron<=10){
  //JugarDenuevo
  Scene=0;
  InterfazDeInicio();
 
  
}
 
}

public void mousePressed(){
  //Si estas en la pantalla de inicio ve a la escena del juego
  if (Scene ==0){
   Scene=2;
}
  //Si estas en la pantalla del tutorial ve a la escena del juego

  if (Scene ==2){
  Scene=2;
}

 if (Scene ==3){
 
}


}

void captureEvent(Capture c) {
  c.read();
  
}


void botonComenzar(int posX, int posY){
 if(mousePressed==true)
 { 
   if(mouseX <= posX+btnsize && mouseX >=posX)
      {
        Scene=1;
   
             if(mouseY <= posY+btnsize && mouseY >=posY)
             {                             
             }
      }  
 } 
}


 

 
 
 
 
 
