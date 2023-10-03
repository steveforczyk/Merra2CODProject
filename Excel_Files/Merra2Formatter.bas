Attribute VB_Name = "Module1"
Sub Format_TAUHGH_Report()
Attribute Format_TAUHGH_Report.VB_Description = "This will format the TAUHGH data from the Merra 2 Script ProcessCODData"
Attribute Format_TAUHGH_Report.VB_ProcData.VB_Invoke_Func = " \n14"
'
' Format_TAUHGH_Report Macro
' This will format the TAUHGH data from the Merra 2 Script ProcessCODData
'

'
    Range("A1:G1").Select
    Selection.Font.Bold = True
    Selection.Columns.AutoFit
    Columns("A:A").Select
    Selection.ColumnWidth = 13.29
    Selection.ColumnWidth = 11.71
    Range("A1:F1").Select
    With Selection.Font
        .Color = -16776961
        .TintAndShade = 0
    End With
    Columns("B:F").Select
    Selection.NumberFormat = "0"
End Sub
