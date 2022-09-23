######  PROGRAM MEMANGGIL WINDOWS PYQT5 ##########################

####### memanggil library PyQt5 ##################################
#----------------------------------------------------------------#
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5.QtQml import * 
from PyQt5.QtWidgets import *
from PyQt5.QtQuick import *  
import sys
import threading
#----------------------------------------------------------------#
from bs4 import BeautifulSoup
import csv

pd = ""
address = ""
folder = ""
convert = ""
status = "DONE :)"
file_output = ""

file_js = ""

# csv file name
address_csv = ""
filename_csv = ""

# initializing the titles and rows list
fields = []
rows = []


latlon = 0
lat = 0
latwrite = 0
long = 0
longwrite = 0
save_text = ""

save_text_prev = ""

file_output_js = ""

########## mengisi class table dengan instruksi pyqt5#############

#----------------------------------------------------------------#
class table(QObject):    
    def __init__(self, parent = None):
        super().__init__(parent)
        self.app = QApplication(sys.argv)
        self.engine = QQmlApplicationEngine(self)
        self.engine.rootContext().setContextProperty("backend", self)    
        self.engine.load(QUrl("main.qml"))
        sys.exit(self.app.exec_())
        
    @pyqtSlot(str)
    def folder_read(self, message):
        global folder
        global address
        address = message
        folder = address.replace("file:///","").replace("/","\\")
        print(folder)
        
    
    @pyqtSlot(str)
    def folder_csv_read(self, message):
        global filename_csv
        address_csv = message
        filename_csv = address_csv.replace("file:///","").replace("/","\\")
        print(filename_csv)
    
    @pyqtSlot(str, str)
    def convert(self, message1, message2):
        global convert
        global file_output
        convert = message1
        file_output = str(message2)+str(".csv")
        print(convert)
        print(file_output)
        
        
    @pyqtSlot(str)
    def convert_js(self, message1):
        global file_output_js
        convert_js = message1
        file_output_js = str(message1)+str(".js")
        print(file_output_js)
        
    
        
    @pyqtSlot(result=str)
    def folder_write(self):  return folder
    
    @pyqtSlot(result=str)
    def folder_csv_write(self):  return filename_csv
    
    @pyqtSlot(result=str)
    def status(self):  return status
    
        
#----------------------------------------------------------------#
def mainloop(num):
    global convert
    global status
    
    global latlon
    global lat
    global latwrite
    global long
    global longwrite
    global save_text
    global save_text_prev
    
    
    while True:
        if (convert == "yes"):
            
            status = "PROCESSING......."
            
            with open(folder, 'r') as f:
                s = BeautifulSoup(f, 'xml')
            
            for coords in s.find_all('coordinates'):
                data = process_coordinate_string(coords.string)
                
            lats = [float(x) for index, x in enumerate(data) if index % 2 == 0]
            lons = [float(x) for index, x in enumerate(data) if index % 2 == 1]
                
            print("done")            
            convert = "no"
            
        
            
            status = "DONE :)"
            
            
            
            
        if (convert == "yes_1"):
            status = "PROCESSING......."
            
            with open(filename_csv, 'r') as csvfile:
                csvreader = csv.reader(csvfile)
                fields = next(csvreader)
                
                for row in csvreader:
                    rows.append(row)
                    
                print("Total no. of rows: %d"%(csvreader.line_num))
            
            for row in rows:
                for col in row:
                    latlon = str(row).split(',')
                    long = str(latlon[0])
        
                    try:
                        longwrite = float(str(long).replace("'", "").replace("[", ""))
                    except ValueError:
                        pass
        
        
                    try:
                        lat = str(latlon[1])
                    except IndexError:
                        pass
                
                    latwrite = lat.replace("'", "")
                    save_text = str('[') + str(latwrite) + str(',') + str(longwrite) + str(']') + str(',')
                    
                if (save_text != save_text_prev):
                    file1 = open(file_output_js,"a")
                    file1.writelines(save_text)
  
                save_text_prev = save_text
                
            
            print("hehe")
            convert = "no"
            status = "DONE :)"
            


#----------------------------------------------------------------#

def process_coordinate_string(str):

    space_splits = str.split(" ")
    ret = []
    
    for split in space_splits[1:]:
        comma_split = split.split(',')
        
        with open(file_output, 'a') as csvfile:
                    csvwriter = csv.writer(csvfile)
                    rows = [comma_split]
                    csvwriter.writerows(rows)
    return ret



########## memanggil class table di mainloop######################
#----------------------------------------------------------------#    
if __name__ == "__main__":
    t1 = threading.Thread(target=mainloop, args=(10,))
    t1.start()
    
    main = table()
    
    
#----------------------------------------------------------------#