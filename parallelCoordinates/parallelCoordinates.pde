String file = "cars-cleaned.tsv";
TableReader data;
ArrayList<Axis> axes;
String[] itemNames;
String[] attributeNames;
int[] displayOrder;
ArrayList<String> filteredItems;
boolean dragging;
boolean filtering;
int selected;
float filterStart;

void setup() {
  size(1024, 512, P2D);
  background(0);
  dragging = filtering = false;

  loadData();
  makeAxes();
}

void loadData() {
  data = new TableReader(file);
  itemNames = data.getItemNames();
  attributeNames = data.getAttributes();
  filteredItems = new ArrayList<String>();
  for (String item : itemNames) filteredItems.add(item);
}

void makeAxes() {
  axes = new ArrayList<Axis>();
  for (int i = 0; i < attributeNames.length; i++) {
    axes.add(new Axis(attributeNames[i], data.getAxisData(i+1), itemNames, attributeNames.length));
  }
}

void drawAxes() {
  for (int i = 0; i < axes.size(); i++) axes.get(i).display(i) ;
} 

void checkFiltered() {
  for (Axis a : axes) {
    ArrayList<String> hiddenItems = a.getHiddenItems();
    for (String item : hiddenItems) {
      filteredItems.remove(item);
    }
  }
}

void drawData() {
  background(0);
  strokeWeight(1);
  if (dragging) stroke(color(37, 100, 0, 50));
  else stroke(color(75, 200, 0, 50));
  checkFiltered();
  
  for (String item : filteredItems) {
    for (int i = 1; i < axes.size(); i++) {
      float prevX = axes.get(i-1).getX();
      float nextX = axes.get(i).getX();
      float prevY = axes.get(i-1).getY(item);
      float nextY = axes.get(i).getY(item);

      line(prevX, prevY, nextX, nextY);
    }
  }
}

// filters are reset
void mouseClicked() {
  if (mouseY > height - 20) {
    filteredItems.clear();
    filtering = false;
    for (String item : itemNames) filteredItems.add(item);
    for (Axis a : axes) a.removeFilter();
  }
}

void mouseDragged() {
 //reordering
 if (dragging) {
 
    //find current selected axis
    selected = 0;
    while (!axes.get(selected).getSelected() && dragging) selected++; 
    
    if (selected == 1 && mouseX <= 40) swapAxes(selected,0); //swap first two axes
    else if (selected == axes.size()-2 && mouseX >= width-40) swapAxes(selected, axes.size()-1); //swap last two axes
    else {
      if (selected > 1)
        if (mouseX <= axes.get(selected-1).getX()) swapAxes(selected, selected-1); // swap to left
      if (selected < axes.size()-2)
        if (mouseX >= axes.get(selected+1).getX()) swapAxes(selected, selected+1); // swap to right
    }
  }
}

void swapAxes(int a, int b) {
  Axis axis1 = axes.get(a);
  Axis axis2 = axes.get(b);
  
  axes.remove(a);
  axes.add(a, axis2);
  axes.remove(b);
  axes.add(b, axis1);
}

void mousePressed() {
  if (mouseY < 50) { //rearrange if dragging label
    dragging = true;
    for (int i = 0; i < axes.size(); i ++) {
      if (mouseX > axes.get(i).getX()-axes.get(i).getLabelWidth()/2 && mouseX < axes.get(i).getX()+axes.get(i).getLabelWidth()/2)
        axes.get(i).select(); // this will select 2 if clicked in a region where labels overlap
    }
  }
  else if (mouseY >= 50 && mouseY <= height-20) { // filter
    for (int i = 0; i < axes.size(); i ++) {
      if (mouseX > axes.get(i).getX()-axes.get(i).getLabelWidth()/2 && mouseX < axes.get(i).getX()+axes.get(i).getLabelWidth()/2) {
        axes.get(i).newFilterStart(mouseY); // this will select 2 if clicked in a region where labels overlap
        filterStart = mouseY;
        filtering = true;
      }
    }
  }
}

void mouseReleased() {
  dragging = false;
  for (Axis a : axes) a.deselect();
  
  if (filtering) {
    filtering = false; 
    int i = 0;
    while (!axes.get(i).getFiltered()) i++;
    axes.get(i).newFilterEnd(mouseY);
  }
}

void draw() { 
  drawData(); 
  drawAxes();
  
  if (filtering) {
    int i = 0;
    while (!axes.get(i).getFiltered()) i++;
    strokeWeight(10);
    stroke(255, 150);
    line(axes.get(i).getX(), filterStart, axes.get(i).getX(), mouseY);
  }
}