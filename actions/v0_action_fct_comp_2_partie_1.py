
import sqlite3
from utils import display
from PyQt5.QtWidgets import QDialog
from PyQt5.QtCore import pyqtSlot
from PyQt5 import uic

# Classe permettant d'afficher la fonction à compléter 2
class AppFctComp2Partie1(QDialog):

    # Constructeur
    def __init__(self, data:sqlite3.Connection):
        super(QDialog, self).__init__()
        self.ui = uic.loadUi("gui/fct_comp_2.ui", self)
        self.data = data

    # Fonction de mise à jour de l'affichage
    @pyqtSlot()
    def refreshResult(self):
        # TODO 1.2 : fonction à modifier pour remplacer la zone de saisie par une liste de valeurs issues de la BD une fois le fichier ui correspondant mis à jour
        display.refreshLabel(self.ui.label_fct_comp_2, "")
        if not self.ui.comboBox.currentText().strip():
            self.ui.table_fct_comp_2.setRowCount(0)
            display.refreshLabel(self.ui.label_fct_comp_2, "Veuillez indiquer un nom de catégorie")
            try:
                cursor = self.data.cursor()
                result2 = cursor.execute("SELECT distinct catZone FROM V0_LesPlaces")
            except Exception as e:
                self.ui.table_fct_comp_1.setRowCount(0)
                display.refreshLabel(self.ui.label_fct_comp_1, "Impossible d'afficher les résultats : " + repr(e))
            else:
                display.refreshGenericCombo(self.ui.comboBox, result2)
        else:
            try:
                cursor = self.data.cursor()
                result = cursor.execute(
                    "SELECT noPlace, noRang, noZone FROM V0_LesPlaces WHERE catZone = ?",
                    [self.ui.comboBox.currentText().strip()])
            except Exception as e:
                self.ui.table_fct_comp_2.setRowCount(0)
                display.refreshLabel(self.ui.label_fct_comp_2, "Impossible d'afficher les résultats : " + repr(e))
            else:
                i = display.refreshGenericData(self.ui.table_fct_comp_2, result)
                if i == 0:
                    display.refreshLabel(self.ui.label_fct_comp_2, "Aucun résultat")