import sqlite3
from utils import display
from PyQt5.QtWidgets import QDialog
from PyQt5.QtCore import pyqtSlot
from PyQt5 import uic


# Classe permettant d'afficher la fonction à compléter 1
class AppFct2_2(QDialog):

    # Constructeur
    def __init__(self, data: sqlite3.Connection):
        super(QDialog, self).__init__()
        self.ui = uic.loadUi("gui/fct_2_2.ui", self)
        self.data = data
        self.refreshAllTables()

    # Fonction de mise à jour de l'affichage d'une seule table
    def refreshTable(self, label, table, query):
        display.refreshLabel(label, "")
        try:
            cursor = self.data.cursor()
            result = cursor.execute(query)
        except Exception as e:
            table.setRowCount(0)
            display.refreshLabel(label, "Impossible d'afficher les données de la table : " + repr(e))
        else:
            display.refreshGenericData(table, result)

    def refreshAllTables(self):
        self.refreshTable(self.ui.label, self.ui.table,
                          "WITH R AS (SELECT COUNT(*) as nbPlVendu,dateRep FROM LesVentes GROUP BY DateRep)"
                          "SELECT noSpec, nomSpec, dateRep,COALESCE(nbPlVendu,0) "
                          "FROM LesRepresentations JOIN LesSpectacles using(noSpec) LEFT OUTER JOIN R USING(dateRep)")
