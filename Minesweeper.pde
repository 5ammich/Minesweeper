import de.bezier.guido.*;
private int NUM_ROWS = 30;
private int NUM_COLS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined
private boolean loser = false;
void setup ()
{
    size(780, 780);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
 
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for (int i = 0; i < NUM_ROWS; i++){
      for (int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    for (int k = 0; k < 101; k++){
      setMines();
    }
}
public void setMines()
{
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int counter = 0;
    for (int i = 0; i < mines.size(); i++){
      if (mines.get(i).isFlagged()){
        counter++;
      }
    }
    if (counter == mines.size()){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    buttons[10][11].setLabel("Y");
    buttons[10][12].setLabel("O");
    buttons[10][13].setLabel("U");
    buttons[11][11].setLabel("L");
    buttons[11][12].setLabel("O");
    buttons[11][13].setLabel("S");
    buttons[11][14].setLabel("E");
}
public void displayWinningMessage()
{
    buttons[10][11].setLabel("Y");
    buttons[10][12].setLabel("O");
    buttons[10][13].setLabel("U");
    buttons[11][11].setLabel("W");
    buttons[11][12].setLabel("I");
    buttons[11][13].setLabel("N");
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = row - 1; i <= row + 1; i++){
      for (int j = col - 1; j <= col + 1; j++){
        if (isValid(i,j) == true && mines.contains(buttons[i][j])){
          numMines++;
        }
      }
      
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 800/NUM_COLS;
         height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(loser == false){
      if (mouseButton == LEFT){
        clicked = true;
      }
      if (mouseButton == RIGHT){
        flagged = !flagged;
        if (flagged == false){
          clicked = false;
        }
      }
      else if (mines.contains(this)){
        displayLosingMessage();
        loser = true;
      }
      else if (countMines(myRow,myCol) > 0){
        setLabel(countMines(myRow,myCol));
      }
      else{
        if (isValid(myRow-1,myCol) == true && !buttons[myRow-1][myCol].clicked){
          buttons[myRow-1][myCol].mousePressed();
        }
        if (isValid(myRow+1,myCol) == true && !buttons[myRow+1][myCol].clicked){
          buttons[myRow+1][myCol].mousePressed();
        }
        if (isValid(myRow,myCol-1) == true && !buttons[myRow][myCol-1].clicked){
          buttons[myRow][myCol-1].mousePressed();
        }
        if (isValid(myRow,myCol+1) == true && !buttons[myRow][myCol+1].clicked){
          buttons[myRow][myCol+1].mousePressed();
        }
        if (isValid(myRow+1,myCol+1) == true && !buttons[myRow+1][myCol+1].clicked){
          buttons[myRow+1][myCol+1].mousePressed();
        }
        if (isValid(myRow-1,myCol-1) == true && !buttons[myRow-1][myCol-1].clicked){
          buttons[myRow-1][myCol-1].mousePressed();
        }
        if (isValid(myRow-1,myCol+1) == true && !buttons[myRow-1][myCol+1].clicked){
          buttons[myRow-1][myCol+1].mousePressed();
        }
        if (isValid(myRow+1,myCol-1) == true && !buttons[myRow+1][myCol-1].clicked){
          buttons[myRow+1][myCol-1].mousePressed();
        }
      }
      }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void reset(){
      flagged = clicked = false;
      loser = false;
      myLabel = "";
    }
}
public void keyPressed(){
  if (key == 'r' || key == 'R'){
    for (int i = 0; i < NUM_ROWS; i++){
      for (int j = 0; j < NUM_COLS; j++){
        buttons[i][j].reset();
      }
    }
  for (int k = 0; k < mines.size(); k++){
    mines.remove(k);
  }
  for (int k = 0; k < 101; k++){
    setMines();
  }
  }
}
