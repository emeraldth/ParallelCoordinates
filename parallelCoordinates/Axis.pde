class Axis {
  
  int totalAxes;
  float x, filterValue1, filterValue2;
  float[] filterRange;
  String label;
  Number min, max;
  String[] itemNames;
  boolean selected;
  boolean filtered;
  ArrayList<String> hiddenItems;
  
  // Access/lookup for data corresponding to datapoint name 
  // Can be int or float
  HashMap<String, Number> values;
  
  Axis(String label, HashMap<String, Number> values, String[] itemNames, //int currentPos, 
  int totalAxes) {
    this.label = label;
    this.values = values;
    this.itemNames = itemNames;
    //this.currentPos = currentPos;
    this.totalAxes = totalAxes;
    hiddenItems = new ArrayList<String>();
    filterRange = new float[2];
    filterRange[0] = filterRange[1] = 0;
   
    //get min
    min = values.get(itemNames[0]);
    for (String name : itemNames) {
      Number current = values.get(name);
      if (min.floatValue() > current.floatValue()) min = current;
    }
    
    //get max
    max = values.get(itemNames[0]);
    for (String name : itemNames) {
      Number current = values.get(name);
      if (max.floatValue() < current.floatValue()) max = current;
    }
  }
  
  void newFilterStart(float initYValue) { 
    removeFilter();
    filterValue1 = initYValue;
    filtered = true;
  }
  
  void newFilterEnd(float endYValue) {
    filterValue2 = endYValue;
    filtered = false;
    if (filterValue1 <= filterValue2) {
      filterRange[0] = filterValue1;
      filterRange[1] = filterValue2;
    } else {
      filterRange[0] = filterValue2;
      filterRange[1] = filterValue1;
    }
    
    // find items outside of filtered range
    for (String name : itemNames)  {
      if (getY(name) < filterRange[0] || getY(name) > filterRange[1]) hiddenItems.add(name);
    }
  }
  
  void removeFilter() {
    filtered = false;
    hiddenItems.clear();
    filterRange[0] = filterRange[1] = 0;
  }
 
  void display(int position) {
    if (selected) { x = mouseX; }
    else { x = ((width-80) / ((float) totalAxes-1))*position + 40; }
    stroke(255);
    strokeWeight(1);
    textAlign(CENTER);
    textSize(15);
    fill(255);
    
    //main line
    line(x, 50, x, 482);
    
    //title
    if(position%2 == 0) text(label, x, 20);
    else text(label, x, 35);
    
    //sizeLabels
    textAlign(RIGHT, CENTER);
    text(max.toString(), x-3, 50);
    text(min.toString(), x-3, 482);
    
    //ticks
    line(x-4, 50, x+4, 50);
    line(x-4, 482, x+4, 482);
    
    if (filterRange[0] != 0) {
      stroke(255);
      strokeWeight(1);
      fill(255,150);
      rect(x-3, filterRange[0], 6, filterRange[1]-filterRange[0]);
      // add labels for ends of filter
    }
  }
  
  void select() { selected = true; }
  void deselect() { selected = false; } 
  boolean getSelected() { return selected; }
  boolean getFiltered() { return filtered; }
  float getX() { return x; }
  float getY(String item) { return -432*((values.get(item).floatValue()-min.floatValue())/(max.floatValue()-min.floatValue())) + 482; }
  float getY(float value) { return -432*((value-min.floatValue())/(max.floatValue()-min.floatValue())) + 482; } 
  float getLabelWidth() { return textWidth(label); }
  ArrayList<String> getHiddenItems() { return hiddenItems; }
  String toString() { return label + ": min " + min + ", max " + max + "\n"; } 
}