class TableReader {
  
  Table table;
  
  String[] attributes;
  String[] itemNames;
  
  // constructor
  TableReader(String file) {
    table = loadTable(file, "header");
    
    //remove columns of non-numeric data
    for(int i = 1; i < table.getColumnCount(); i++) {
      Character c = new Character((table.getString(0, i).charAt(0)));
      if (Character.isLetter(c)) table.removeColumn(i);
    }
    
    // get attribute names for labels
    String[] columnTitles = table.getColumnTitles();
    attributes = new String[columnTitles.length - 1];
    for (int i = 1; i < columnTitles.length; i++) {
      attributes[i-1] = columnTitles[i];
    }
    
    //get names of data points in table
    itemNames = table.getStringColumn(0); 
  }
  
  
  String[] getAttributes() { return attributes; }
  int getNumAxes() { return attributes.length; }
  String[] getItemNames() { return itemNames; }

  // return the data/value pairs for a single attribute
  HashMap<String, Number> getAxisData(int column) {
    
    HashMap<String, Number> axisData = new HashMap<String, Number>();
    
    // check if float by seeing if "." character appears in column
    String[] check = table.getStringColumn(column);
    String allValues = "";
    for (String current : check) { allValues += current; }
    if (allValues.contains(".")) { // if float
      for (int i = 0; i < table.getRowCount(); i++) {
        axisData.put(table.getString(i,0), table.getFloat(i,column));
      }
    } else { // if int
      for (int i = 0; i < table.getRowCount(); i++) {
        axisData.put(table.getString(i,0), table.getInt(i,column));
      }
    }
      
    return axisData;
  }
}