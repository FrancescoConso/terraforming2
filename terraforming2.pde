import ddf.minim.analysis.*;
import ddf.minim.*;

//Indica il numero di linee della griglia
//I riquadri totali sono il numero -1
int riquadri=11;

Minim oggettoMinim;

//Per la dimostrazione si usa un file audio ad hoc
//Quindi la fonte è un AudioPlayer
//Per ricevere l'audio da un device input (ie microfono o mixer)
//Si sarebbe usato AudioInput
//AudioInput fonteAudio;
AudioPlayer fonteAudio;

//FFT è la classe della trasformata di Fourier
FFT fftL;
FFT fftR;

//La matrice contiene le informazioni sulle altezze della griglia
int altezzaGriglie[][]=new int[riquadri][riquadri];

int i=0, j=0;
int countJ=0;

float varRotZ=0;
//La formula magica è la formula che calcola l'altezza
//di ciascun punto della griglia gr
float formulaMagica=0;

//Per evitare problemi legati al garbage
//collector esistono solo due PShape
PShape lineeOrizzontali=new PShape();
PShape lineeVerticali=new PShape();

void setup()
{
  //fullScreen(P3D);
  size(1280, 720, P3D);
  background(0);

  oggettoMinim=new Minim (this);

  //fonteAudio = oggettoMinim.getLineIn();
  fonteAudio = oggettoMinim.loadFile("Envision+TestTunes.mp3");
  fonteAudio.play();

  //Inizializzo le trasformate di fourier dei due canali audio
  fftL = new FFT(fonteAudio.bufferSize(), fonteAudio.sampleRate());
  fftR = new FFT(fonteAudio.bufferSize(), fonteAudio.sampleRate());

  fftL.linAverages(riquadri);
  fftR.linAverages(riquadri);

  stroke(255, 0, 255);
  strokeWeight(2);
  noFill();

  lineeOrizzontali=new PShape();
  lineeVerticali=new PShape();
}

void draw()
{

  background(0);
  //disegno sullo schermo i credits e i warning

  textAlign(CENTER);
  textSize(20);
  text("After the song the program will play some test tunes.\nHeadphone users beware!", width/2, height/20);
  text("\"Envision\" Kevin MacLeod (incompetech.com)\nLicensed under Creative Commons: By Attribution 4.0 License\nhttp://creativecommons.org/licenses/by/4.0/", width/2, (height/10*9)-10);

  //Eseguo le trasformate di fourier dei canali destro e sinistro della fonte audio
  fftL.forward(fonteAudio.left);
  fftR.forward(fonteAudio.right);

  //Con queste operazioni di traslazione posso disegnare la griglia ad un angolo conveniente
  translate(width/2, width/5, -width/6*5);
  varRotZ+=PI/720;
  varRotZ=varRotZ%(PI*2);
  rotateX(PI/3);
  rotateZ(PI/2);
  rotateZ(varRotZ);

  //Disegno della "base" della griglia
  rect(-width/2, -width/2, width, width);


  //Qui succede la magia, i valori delle FFT sono sommati
  //e manipolati per sollevare i punti della griglia
  for (i=0; i<riquadri; i++)
  {
    for (j=0; j<riquadri; j++)
    {
      if (i==0 && j==0)
      {
        formulaMagica=(fftL.getAvg(i)+fftR.getAvg(j))/6*sqrt(riquadri-(i-j)/2);
        altezzaGriglie[i][j]=floor(formulaMagica)*height/50;
      } else if (i==0 || j==0)
      {
        formulaMagica=(fftL.getAvg(i)+fftR.getAvg(j))/3*sqrt(riquadri-(i-j)/2);
        altezzaGriglie[i][j]=floor(formulaMagica)*height/50;
      } else
      {
        formulaMagica=(fftL.getAvg(i)+fftR.getAvg(j))*2*sqrt(riquadri-(i-j)/2);
        altezzaGriglie[i][j]=floor(formulaMagica)*height/50;
      }
    }
  }

  //l'inserimento deve essere del tipo
  //fissa riga/colonna
  //avanza in ordine ascendente
  //incrementa riga/colonna
  //avanza in ordine discendente
  //possiamo farlo come for?

  lineeOrizzontali=createShape();
  lineeVerticali=createShape();
  lineeOrizzontali.beginShape();
  lineeVerticali.beginShape();
  lineeOrizzontali.noFill();
  lineeVerticali.noFill();

  //per ottimizzare l'inserimento si incrementano i e j tatticamente
  //per disegnare le linee come una "serpentina"
  //i fisso, incremento j
  i=0;
  for (i=0; i<riquadri; i++)
  {
    //se i è pari vado in modo ascendente, else discendente
    if (i%2==1)
    {
      for (j=0; j<riquadri; j++)
      {
        lineeOrizzontali.vertex(width/2-width/(riquadri-1)*i, width/2-width/(riquadri-1)*(riquadri-1-j), altezzaGriglie[i][(riquadri-1-j)]);
        lineeVerticali.vertex(width/2-width/(riquadri-1)*(riquadri-1-j), width/2-width/(riquadri-1)*i, altezzaGriglie[(riquadri-1-j)][i]);
      }
    }
    if (i%2==0)
    {
      for (j=0; j<riquadri; j++)
      {
        lineeOrizzontali.vertex(width/2-width/(riquadri-1)*i, width/2-width/(riquadri-1)*j, altezzaGriglie[i][j]);
        lineeVerticali.vertex(width/2-width/(riquadri-1)*j, width/2-width/(riquadri-1)*i, altezzaGriglie[j][i]);
      }
    }
  }

  lineeOrizzontali.endShape();
  shape(lineeOrizzontali, 0, 0);
  lineeVerticali.endShape();
  shape(lineeVerticali, 0, 0);

  //a questo punto disegno linee orizzontali e verticali
  //quattro linee che tracciano il limite dell terreno
  line(width/2, width/2, 0, width/2, width/2, altezzaGriglie[0][0]);
  line(-width/2, -width/2, 0, -width/2, -width/2, altezzaGriglie[riquadri-1][riquadri-1]);
  line(width/2, -width/2, 0, width/2, -width/2, altezzaGriglie[0][riquadri-1]);
  line(-width/2, width/2, 0, -width/2, width/2, altezzaGriglie[riquadri-1][0]);
}
