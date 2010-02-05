#!/usr/bin/python

# quitbutton.py

import sys
from PyQt4 import QtGui, QtCore, QtOpenGL

class QTNoteTextWidget(QtGui.QTextEdit):
    def keyPressEvent(self, event):
        QtGui.QTextEdit.keyPressEvent(self, event)
        
        # find the cursor position in the document.
        cursorPos = self.textCursor().position()
        
        # look back for some important patterns...
        
        # if we just hit space then...
        #    [asterix][space] means start a bullet list
        #    [hash][space] means start a numbered list
        #    [equals][space] means evaluate an expression
 
class QTNote(QtGui.QWidget):
    def __init__(self, parent=None):
        QtGui.QWidget.__init__(self, parent)

        self.setGeometry(640, 480, 640, 480)
        self.setWindowTitle('QTNote')

        graphicsScene = QtGui.QGraphicsScene()
        graphicsScene.setSceneRect(0, 0, 600, 400)
        graphicsView = QtGui.QGraphicsView(self)
        graphicsView.setScene(graphicsScene)
        graphicsView.setGeometry(0, 0, 640, 480)
        graphicsView.setViewport(QtOpenGL.QGLWidget())
      
        textWidget = QTNoteTextWidget()
        textWidget.setHtml("Hello!<br><ul><li>Hello</li><li>There</li></ul>")
        textWidget.setAutoFormatting(QtGui.QTextEdit.AutoNone)
        textProxy = graphicsScene.addWidget(textWidget)
        
        self.textGI = graphicsScene.addText("QTNote")
        self.textGI.setHtml("<b><font size='+8'>QTNote</font></b>")
        self.textGI.moveBy(100, 100)
        self.actualOpacity = 1.0
        
        self.fadeAnimator = QtCore.QTimer(self)
        self.fadeAnimator.setInterval(60)
        self.fadeAnimator.setSingleShot(False)
        self.fadeAnimator.start()
        self.fadeAnimator.timeout.connect(self.handleFadeTick)
        
    def handleFadeTick(self):
        self.actualOpacity -= 0.07
        self.textGI.setOpacity(self.actualOpacity)
        
        if(self.actualOpacity < 0):
            print "Terminating logo fade."
            self.fadeAnimator.stop()
            self.textGI.deleteLater()
            self.fadeAnimator.deleteLater()
        
# Run the application.
app = QtGui.QApplication(sys.argv)
qb = QTNote()
qb.show()
sys.exit(app.exec_())
