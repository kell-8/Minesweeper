import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();  //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons [r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines() {
  while (mines.size() < 83) {
    final int row = (int)(Math.random()*20);
    final int col = (int)(Math.random()*20);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
      System.out.println(row + ", " + col);
    }
  }
}



public void draw () {
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon() {
  int count = 0;
  for (int i = 0;  i < mines.size(); i++){
    if (mines.get(i).isFlagged() == true){
      count++;
    }
  }
  if (count == mines.size()){
    return true;
  }
  return false;
}

public void displayLosingMessage() {
  //your code here
}

public void displayWinningMessage() {
  //your code here
}

public boolean isValid(int r, int c) {
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col) {
  int numMines = 0;
  for (int i = row-1; i < row+2; i++) {
    for (int k = col-1; k < col+2; k++) {
      if (isValid(row, col) && mines.contains(buttons[i][k])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  System.out.println("Mines: " + numMines);
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
        clicked = false;
      } else {
        flagged = true;
      }
    } else if (mines.contains(buttons[myRow][myCol])) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int i = -1; i < 2; i++) {
        for (int k = -1; k <2; k++) {
          if (isValid(myRow+i, myCol+k) == true && buttons[myRow+i][myCol+k].clicked == false) {
            buttons[myRow+i][myCol+k].mousePressed();
          }
        }
      }
    }
  }

  public void draw() {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }
}
