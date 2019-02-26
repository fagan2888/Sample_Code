Attribute VB_Name = "Module1"
' File Name: FormatPresentation.bas
' Description: format the chart to presentation standard
' Author: Shijie Shi
' Last updated on: 05/16/2016
'
' Note: !!! 1. Click on the chart that need to be formated;
'       !!! 2. Choose the chart size in line 19-21;


Sub FormatPresentation()

    ActiveWindow.Zoom = 100
    
    Set cht = ActiveSheet.Shapes(LTrim(Replace(ActiveChart.Name, ActiveSheet.Name, "")))
    With cht
        .Fill.Visible = msoFalse
        .Line.Visible = msoFalse
        .Height = 345.6
'        .Width = 295.2          ' 4.8 * 4.1 chart
        .Width = 432            ' 4.8 * 6 chart
'        .Width = 72 * 12.4      ' 4.8 * 12.4 chart
    End With
        
    With ActiveSheet.ChartObjects(LTrim(Replace(ActiveChart.Name, ActiveSheet.Name, ""))).Chart.ChartArea.Format.TextFrame2.TextRange.Font
        .NameComplexScript = "Times New Roman"
        .NameFarEast = "Times New Roman"
        .Name = "Times New Roman"
        .Size = 18
        .Bold = msoTrue
        .Fill.ForeColor.ObjectThemeColor = msoThemeColorText1
        .Fill.ForeColor.TintAndShade = 0
        .Fill.ForeColor.Brightness = 0
        .Fill.Transparency = 0
        .Fill.Solid
    End With
    
    ActiveChart.PlotArea.Select
    Selection.Format.Fill.Visible = msoFalse
    With Selection.Format.Line
        .Visible = msoTrue
        .ForeColor.ObjectThemeColor = msoThemeColorAccent1
        .ForeColor.ObjectThemeColor = msoThemeColorText1
        .ForeColor.TintAndShade = 0
        .ForeColor.Brightness = 0
        .Transparency = 0
        .Weight = 0.75
    End With
    
    ActiveChart.Axes(xlCategory).Select
    Selection.Format.Fill.Visible = msoFalse
    With Selection.Format.Line
        .Visible = msoTrue
        .ForeColor.ObjectThemeColor = msoThemeColorText1
        .ForeColor.TintAndShade = 0
        .ForeColor.Brightness = 0
        .Transparency = 0
        .Weight = 0.75
    End With
    Selection.TickLabels.Orientation = xlHorizontal
    
    ActiveChart.Axes(xlValue).Select
    Selection.MajorTickMark = xlNone
    ActiveChart.ChartArea.Select
    ActiveChart.Axes(xlCategory).Select
    Selection.MajorTickMark = xlNone
End Sub



